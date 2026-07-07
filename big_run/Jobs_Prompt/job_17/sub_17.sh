#!/bin/sh
export X509_USER_PROXY=$1
ulimit -v 5000000
cd $TMPDIR
mkdir Job_17
cd Job_17
cd /afs/cern.ch/user/m/mspannri/CMSSW_16_0_8/src/
eval `scramv1 runtime -sh`
cd -
cp -f /afs/cern.ch/user/m/mspannri/CMSSW_16_0_8/big_run/Jobs_Prompt/job_17/* .
cmsRun run_cfg.py
echo '--- files in workdir after cmsRun ---'
ls -la
cp output.root /eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job17.root
rm -f *.root
