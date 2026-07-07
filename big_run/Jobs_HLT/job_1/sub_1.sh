#!/bin/sh
export X509_USER_PROXY=$1
ulimit -v 5000000
cd $TMPDIR
mkdir Job_1
cd Job_1
cd /afs/cern.ch/user/m/mspannri/CMSSW_16_0_8/src/
eval `scramv1 runtime -sh`
cd -
cp -f /afs/cern.ch/user/m/mspannri/CMSSW_16_0_8/big_run/Jobs_HLT/job_1/* .
cmsRun run_cfg.py
echo '--- files in workdir after cmsRun ---'
ls -la
cp output.root /eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job1.root
rm -f *.root
