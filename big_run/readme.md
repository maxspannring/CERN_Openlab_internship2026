# Big Run
the goal of this workflow is to re run the same data analysis workflow I did in the last few days, but with more data. E.g. run HLT with two different global Tags, (Prompt vs NGT + running DQM and obtaining the comparison plot of the first 20 files this list: https://github.com/jprendi/sakura/blob/main/ApprovedPlots/CMS-DP-2026/028/EGamma/HLTJobSubmissions/run_398802.txt#L1-L20)

First we create the file list by going to this link and taking only the first 20 files: https://github.com/jprendi/sakura/blob/main/ApprovedPlots/CMS-DP-2026/028/EGamma/HLTJobSubmissions/run_398802.txt#L1-L20

As always, run ```cmsenv``` first. Then ```./hltGetConfiguration_HLT.sh``` and ```./hltGetConfiguration_Prompt.sh``` to get the hltData*.py files.

then ```edmConfigDump hltData_Prompt.py >& hltDataDump_Prompt.py``` and ```edmConfigDump hltData_HLT.py >& hltDataDump_HLT.py```
create directories for theoutput: 
```
mkdir /eos/user/m/mspannri/HTCondor_jobs/big_run
mkdir /eos/user/m/mspannri/HTCondor_jobs/big_run/HLT
mkdir /eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt
```

I also modified the cmsCondorDataFiles.py file so that it creates different job directories based on the job tag you give it. 
Also changed the number of threads in the dataDump files to one in order to avoid memory allocation issues!
Also, be very careful, if the target directory where the files are supposed to be copied doesn't exist, they don't get copied. 
I added ```set -euo pipefail``` in the run_*.sh in order to prevent the shell script from silently failing. 
I also added the check_all.sh file that gives a 'quick' (~60s) overview about the status of all the files that ran. Although it is not perfect.
Sometimes, there also might be hiccups in the condor system - for example, I had a job being 'evicted' because there were some networking issues with condor (but it produced perfectly fine output, it just gave weird error messages and ran the job again and again until it reached a limit)

Never forget to run mtimux beore you start a tmux session!
I ran this command to run dqm in tmux:
```
tmux new -d -s AAA 'eval "$(scram runtime -sh)";cmsRun ../src/DQM/Integration/python/clients/hlt_dqm_sourceclient-live_cfg.py inputFiles=/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job0.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job1.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job2.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job3.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job4.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job5.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job6.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job7.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job8.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job9.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job10.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job11.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job12.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job13.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job14.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job15.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job16.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job17.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job18.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/HLT/HLT_run_job19.root >& dqmclient_HLT.log;mv upload/*.root upload/HLT/.;tail dqmclient_HLT.log;cmsRun ../src/DQM/Integration/python/clients/hlt_dqm_sourceclient-live_cfg.py inputFiles=/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job0.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job1.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job2.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job3.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job4.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job5.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job6.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job7.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job8.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job9.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job10.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job11.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job12.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job13.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job14.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job15.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job16.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job17.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job18.root,/eos/user/m/mspannri/HTCondor_jobs/big_run/Prompt/Prompt_run_job19.root >& dqmclient_Prompt.log;mv upload/*.root upload/Prompt/.;tail dqmclient_Prompt.log;echo "DQM DONE (exit $?)"; exec bash'
```

