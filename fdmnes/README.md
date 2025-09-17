# FDMNES
FDMNES, for Finite Difference Method Near Edge Structure, uses the density functional theory (DFT). It is thus specially devoted to the simulation of the K edges of all the chemical elements and of the L23 edges of the heavy ones. For the other edges, it includes advances by the use of the time dependent DFT (TD-DFT).

## Contents
These are the files/directories included for this example
1. `fdmnes.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `fdmfile.txt` is the run file that tells FDMNES which input files to run.
3. `Sim` is a directory that holds the input files for a standard test suite for FDMNES.

## How to run
The following are steps to run our FDMNES example. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/fdmnes
sbatch fdmnes.slurm 
```

### Cluster and Partition Info
FDMNES is available on tinkercliffs and owl clusters as there is no GPU integration at the moment in the software. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.

This specific example runs a number of different calculations and puts the output files for each individual calculation into `Sim/Test_stand`.
The FDMNES documentation and manual can be found [here](https://fdmnes.neel.cnrs.fr/).

