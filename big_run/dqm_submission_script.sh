#!/bin/bash
set -euo pipefail

# define directories
BASE=/afs/cern.ch/user/m/mspannri/CMSSW_16_0_8/big_run
CFG=/afs/cern.ch/user/m/mspannri/CMSSW_16_0_8/src/DQM/Integration/python/clients/hlt_dqm_sourceclient-live_cfg.py

# get input files for HLT and Prompt
INPUT_HLT=$(find /eos/user/m/mspannri/HTCondor_jobs/big_run/HLT \
    -type f -name '*.root' | sort -V | paste -sd, -)
INPUT_PROMPT=$(find /eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt \
    -type f -name '*.root' | sort -V | paste -sd, -)

mkdir -p "$BASE/upload/HLT" "$BASE/upload/Prompt" # make sure the output directory really exists
systemctl --user start tmux.service # because apparently them tmux alias doesn't work in shell scripts

# build the work as one string; newlines are real command separators 
read -r -d '' WORK <<COMMAND || true
cd "$BASE"
eval "\$(scram runtime -sh)"
cmsRun ../src/DQM/Integration/python/clients/hlt_dqm_sourceclient-live_cfg.py inputFiles=$INPUT_HLT >& dqmclient_HLT.log
mv upload/*.root upload/HLT/.
tail dqmclient_HLT.log
cmsRun ../src/DQM/Integration/python/clients/hlt_dqm_sourceclient-live_cfg.py inputFiles=$INPUT_PROMPT >& dqmclient_Prompt.log
mv upload/*.root upload/Prompt/.
tail dqmclient_Prompt.log
echo "DQM DONE (exit \$?)"; exec bash
COMMAND

echo "trying to execute the following commands in tmux: $WORK"

tmux new -d -s DQM "$WORK"
tmux ls
echo "script ran succesfully"
