based on https://github.com/jprendi/diff_Tags#physics-performance-via-dqm-client
first, download these packages:

```
git cms-addpkg DQM/Integration
git cms-addpkg DQM/HLTEvF
git cms-addpkg Configuration/StandardSequences
```

fo to src directory in your cmssw release, create a upload folder:
```
mkdir upload
```
go to the following file: ```DQM/Integration/python/clients/hlt_dqm_sourceclient-live_cfg.py```
and add the followign two lines at the end: 
```
process.hltObjectsMonitor4all.processName  = cms.string("HLTX")
process.hltObjectMonitor.processName = cms.string("HLTX")
```
 then run the following command (you should have already gotten output.root from the previous workflow)

```
cmsRun DQM/Integration/python/clients/hlt_dqm_sourceclient-live_cfg.py inputFiles=output.root >& dqmclient_Prompt.log
```
this runs quite a while so maybe run it in tmux :)
once this is done, you can find the results in the upload folder. 
