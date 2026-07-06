#!/bin/sh
export X509_USER_PROXY=$1
ulimit -v 5000000
cd $TMPDIR
mkdir Job_0
cd Job_0
cd /afs/cern.ch/user/m/mspannri/CMSSW_16_0_8/src/
eval `scramv1 runtime -sh`
cd -
cp -f /afs/cern.ch/user/m/mspannri/CMSSW_16_0_8/HTCondor_jobs/Jobs/Job_0/* .
cmsRun run_cfg.py
echo '--- files in workdir after cmsRun ---'
ls -la
cp output.root /eos/user/m/mspannri/HTCondor_jobs/TEST_run_job0_Raw.root
rm -f *.root
