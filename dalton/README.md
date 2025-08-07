# Dalton
 Dalton is a powerful molecular electronic structure program for performing quantum chemical calculations.

## Contents
These are the files/directories included for this example
1. `dalton_nompi.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `cc2dc_energy.dal` is the dalton run file to run to run CC2
3. `cc2dc_energy.mol` is the molecule input file for water


## How to run
The following are steps to run our Dalton example on Tinkercliffs without using mpi. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/dalton
sbatch dalton_nompi.slurm 
```

### Cluster and Partition Info
Dalton is available on tinkercliffs and owl clusters. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
The Dalton documentation can be found [here](https://daltonprogram.org/).

