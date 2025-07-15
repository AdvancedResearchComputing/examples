# WRF
The Weather Research and Forecasting (WRF) Model is a next-generation mesoscale numerical weather prediction system designed to serve both operational forecasting and atmospheric research needs.
The example that we are running is taken from a test case on [WRF's github](https://github.com/wrf-model/WRF/tree/master/test/em_tropical_cyclone) to simulate a tropical cyclone. 

## Contents
These are the files/directories included for this example
1. `wrf.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `input_sounding` provides the parameters for the initial horizontally homogeneous environment.
3. `namelist.input` was edited to simulate only 1 day rather than 6 days to reduce run time.


## How to run
The following are steps to run our WRF example. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples
cd wrf
sbatch wrf.slurm 
```

### Cluster and Partition Info
WRF is available on tinkercliffs and owl clusters. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
The slurm batch script is setup to generate a new directory with the `SLURM_JOB_ID` to store all the output files from the calculation.
The WRF documentation can be found [here](https://www.mmm.ucar.edu/models/wrf).

