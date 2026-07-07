#!/bin/sh
# this is a bash script to exectue the hltGetConfiguration command from https://twiki.cern.ch/twiki/bin/view/CMSPublic/SWGuideGlobalHLT

hltGetConfiguration /dev/CMSSW_16_0_0/GRun \
	--globaltag 160X_dataRun3_HLT_v1 \
	--data \
	--unprescale \
	--output minimal \
	--max-events -1 \
	--eras Run3_2026 --l1-emulator	uGT --l1 L1Menu_Collisions2026_v1_1_0_xml \
	--input $(./format_file_list.sh) \
	> hltData_HLT.py 

# cmsRun hltData.py >& hltData.log

