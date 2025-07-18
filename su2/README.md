# SU2
SU2 is an open-source collection of software tools written in C++ and Python for the analysis of partial differential equations (PDEs) and PDE-constrained optimization problems on unstructured meshes with state-of-the-art numerical methods.
Through the initiative of users and developers around the world, SU2 is now a well established tool with wide applicability to aeronautical, automotive, ship, and renewable energy industries, to name a few.

## Contents
These are the files/directories included for this example
1. `su2.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `tutorial_example` is the directory holding the SU2 Tutorial example files which are listed below.
    - `kenics_mixer_tutorial.cfg`
    - `Kenics_mixer_tutorial.geo`
    - `kenics.su2`


## How to run
The following are steps to run our SU2 example. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples
cd su2
sbatch su2.slurm 
```

### Cluster and Partition Info
SU2 is available on tinkercliffs and owl clusters. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
The SU2 documentation can be found [here](https://su2code.github.io/).

