#!/usr/bin/env bash
# check_all.sh summarise a batch of HTCondor/CMSSW jobs.
# Usage: ./check_all.sh [BASE_DIR] [EOS_OUTPUT_DIR]
#   BASE_DIR        holds the Jobs_<TAG>/ folders        (default: current dir)
#   EOS_OUTPUT_DIR  where output .root files were copied  (default: path below)
# Writes Markdown to $BASE/check_report.md and renders it with glow.
set -o pipefail

BASE="${1:-$PWD}"
EOS_OUT="${2:-/eos/user/m/mspannri/HTCondor_jobs/big_run}"
ME="$(whoami)"
OUT="$BASE/check_report.md"

OK=0; EMPTY=0; PROBLEM=0; MISSING=0

# One EOS traversal up front; per-job presence is then a cheap grep of this list.
EOSFILES="$(find "$EOS_OUT" -name '*.root' 2>/dev/null)"

scan_tag() {
    local tagdir="$1" label="$2"
    echo "### $label"; echo
    if [ ! -d "$tagdir" ]; then echo "_not found: \`$tagdir\`_"; echo; return; fi
    echo "| Job | Total | Passed | Errors | Status | on EOS |"
    echo "|----:|------:|-------:|-------:|:-------|:------:|"
    local jd i line total passed errors status eos
    for jd in $(ls -d "$tagdir"/job_* 2>/dev/null | sort -V); do
        i="$(basename "$jd" | sed 's/job_//')"

        # Grab the HLT-Report summary line specifically: it is the one carrying
        # "errors =". The TrigReport line also says "Events total" but has
        # "failed =" instead of "errors =", so matching bare "Events total" and
        # taking tail -1 could pick the wrong line and drop the errors field.
        line="$(grep -hE 'Events total.*errors' "$jd/hlt.stderr" "$jd/hlt.stdout" 2>/dev/null | tail -1)"
        #line="$(tail -n 400 "$jd/hlt.stderr" 2>/dev/null | grep -hE 'Events total.*errors' | tail -1)"
        #line="$(tac "jd/hlt.stderr" 2>/dev/null | grep -hE 'Events total.*errors' | tail -1)"
        if [ -z "$line" ]; then
            if [ ! -f "$jd/hlt.stderr" ]; then status="NO STDERR"
            elif grep -qiE 'Fatal Exception|FatalRootError|segmentation|bad_alloc' "$jd/hlt.stderr"; then status="CRASHED"
            else status="NO SUMMARY"; fi
            total="-"; passed="-"; errors="-"; PROBLEM=$((PROBLEM+1))
        else
            read -r total passed errors < <(echo "$line" | awk '{for(i=1;i<=NF;i++){if($i=="total")t=$(i+2);if($i=="passed")p=$(i+2);if($i=="errors")e=$(i+2)}print t,p,e}')
            total="${total:-0}"; passed="${passed:-0}"; errors="${errors:-x}"
            if   ! [[ "$errors" =~ ^[0-9]+$ ]]; then status="NO SUMMARY"; PROBLEM=$((PROBLEM+1))
            elif [ "$errors" -ne 0 ];           then status="FAIL";       PROBLEM=$((PROBLEM+1))
            elif [ "$total"  -eq 0 ];           then status="EMPTY";      EMPTY=$((EMPTY+1))
            else                                     status="OK";         OK=$((OK+1)); fi
        fi

        # Did the output file actually land on EOS for this tag+job?
        if printf '%s\n' "$EOSFILES" | grep -qiE "${label}.*_job${i}\.root$"; then
            eos="yes"
        else
            eos="NO"
            case "$status" in OK|EMPTY) MISSING=$((MISSING+1));; esac
        fi
        echo "| $i | $total | $passed | $errors | $status | $eos |"
    done
    echo
}

# Is the batch still in the queue?
queued=$(condor_q "$ME" -af ClusterId 2>/dev/null | wc -l)
held=$(condor_q "$ME" -constraint 'JobStatus==5' -af ClusterId 2>/dev/null | wc -l)
heldnote=""; [ "${held:-0}" -gt 0 ] && heldnote=" ($held held stuck)"

{
    echo "# HTCondor check $(date '+%Y-%m-%d %H:%M')"
    echo
    [ "${queued:-0}" -gt 0 ] && { echo "> **WARNING:** $queued job(s) still in the queue$heldnote this report may be incomplete. Re-run once \`condor_q\` is empty."; echo; }

    shopt -s nullglob; tagdirs=("$BASE"/Jobs_*/); shopt -u nullglob
    if [ ${#tagdirs[@]} -eq 0 ]; then
        echo "_no \`Jobs_*\` directories under \`$BASE\`_"; echo
    else
        for tagdir in "${tagdirs[@]}"; do
            scan_tag "$tagdir" "$(basename "$tagdir" | sed 's/^Jobs_//')"
        done
    fi

    echo "**Totals:** $OK ok · $EMPTY empty · $PROBLEM problem · $MISSING not-on-EOS  "
    [ "${MISSING:-0}" -gt 0 ] && echo "> **$MISSING job(s) succeeded but have no file on EOS** the silent-copy failure; check the \`cp\` / output path."
    echo "_OK = clean · EMPTY = ran, 0 events · FAIL/CRASHED/NO SUMMRY ->afeiled to open that job's hlt.stde_"
    echo

    echo "## Files on EOS (\`tree -htD\`)"
    echo '```'
    tree -htD -n "$EOS_OUT" 2>/dev/null || echo "(tree failed / path missing: $EOS_OUT)"
    echo '```'
    echo

} > "$OUT"

[ "${queued:-0}" -gt 0 ] && echo "WARNING: $queued job(s) still queued report may be incomplete." >&2
if command -v glow >/dev/null 2>&1; then glow "$OUT"; else cat "$OUT"; fi

