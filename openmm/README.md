# OpenMM
OpenMM is a high-performance toolkit for molecular simulation. Use it as an application, a library, or a flexible programming environment. OpenMM includes extensive language bindings for Python, C, C++, and even Fortran.

## Contents
These are the files/directories included for this example
1. `openmm.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `Makefile` is the make file to generate the excecutatble for the example
3. `HelloArgonInC.c` is the Hello Argon example script in C

## How to run
The following are steps to run our OpenMM example on tinkercliffs. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples
cd openmm
sbatch openmm.slurm 
```

### Cluster and Partition Info
OpenMM is available on all clusters: tinkercliffs, owl, and falcon, but note that this example does use 1 gpu thus this example would not be able to run on the owl cluster.  
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
The OpenMM documentation can be found [here](https://openmm.org/).

