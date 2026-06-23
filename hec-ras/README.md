# HEC-RAS
Hydrologic Engineering Center’s River Analysis System (HEC-RAS) version 6.6. This software allows the user to perform one-dimensional steady flow, one and two-dimensional unsteady flow computations, sediment transport/mobile bed computations, stormwater pipe network modeling, and water temperature/water quality modeling.

## Contents
These are the files/directories included for this example
1. `hec-ras.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `wrk_source/` is the source data directory for the simulation. This should remain untouched and just used to copy data from. 

## How to run
The following are steps to run our HEC-RAS example. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/hec-ras
sbatch hec-ras.slurm 
```
This software directly edits the input file, so make sure you have another copy of the input file if you wish to run the simulation again. That is why there is a `wrk_source/` directory in this example. 

### Cluster and Partition Info
This example uses HEC-RAS from on the normal_q. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
The HEC-RAS documentation can be found [here](https://www.hec.usace.army.mil/software/hec-ras/).

