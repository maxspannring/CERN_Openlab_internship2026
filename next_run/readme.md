# Next Run
Now we are trying to get all data from all 2026 runs that fulfill the following conditions: 
* proton-proton collissions
* ```stable-beam = true```
* ```l1_hlt_mode```: "collisions2026"

The ```OMS_API_query.ipynb``` runs python code that queries the CMS online monitoring System (OMS) to create the oms_runs.csv (and .json).
In total, we got 225 runs (37/76/65/47 across A–D).
For more details on how the querying actually works, see the jupyter notebook. 

For getting the root files for each run, we use the Data Aggregation System (DAS) `generate_filelists.sh` turns `oms_runs.csv` into one file list per run in `filelists/run_<N>.txt`.
Tool: `dasgoclient` (ships with CMSSW). Needs a valid grid proxy: `voms-proxy-init -voms cms -rfc`.
The DAS web UI (cmsweb.cern.ch/das) needs a grid cert loaded in the browser — never got it working, and it isn't needed. The CLI does everything.
 
Wildcards work in dataset queries but not in file queries. 
