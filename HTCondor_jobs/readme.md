# HTCondor
The goal is to get familiar with HTCondor.

Do ```cmsenv``` first! -> you have to place this folder insdie a CMSSW release, e.g. CMSSW_16_0_8.
I also created a ```filelist_short.txt``` file to play around with a smaller number of files that have to be run.

Also, you can not directly use the config files that come out of ```hltGetConfiguration```-> you have to run this command first: 
```edmConfigDump hltData_Prompt.py >& hltDataDump.py``` and then ```hltDataDump.py``` will become your input config file for job submission. 
create an output directory on eos: ```mkdir /eos/user/m/mspannri/HTCondor_jobs```

run ```vomsi``` to create grid certificate. 

Then I ran this comand to test the job submission:
```
python3 cmsCondorDataFiles.py \
hltDataDump.py \
"$CMSSW_BASE/src/" \
/eos/user/m/mspannri/HTCondor_jobs \
-p /tmp/x509up_u196241 \
-n 1 \
--inputList filelist_short.txt \
--jobTag TEST
```
This creates a ```condor_cluster.sub``` file - don't forget to submit it with ```condor_submit condor_cluster.sub```

You can see the job submission status with ```condor_q```

Then it creates a Jobs/ folder in the directory you ran it - you can see the hlt.stout, hlt.stderr files etc in there. 

Then, I also had to modify the ```cmsCondorDataFiles.py``` file so that it copies the right files to the target direcory on eos (we don't have scouting data)
