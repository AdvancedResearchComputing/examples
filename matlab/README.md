# MATLAB
MATLAB is a programming and numeric computing platform developed by MathWorks.  MATLAB toolboxes are professionally developed, rigorously tested, and fully documented. 

## Contents
These are the files/directories included for this example
1. `matlab.slurm` is the slurm batch submit script to run MATLAB in serial. User may have to change the account name based on what resources are available to them. 
3. `matlab_job.m` is the sample MATLAB script.
4. `archived_examples` is a folder that holds old scripts and additional examples. 

## How to run
The following are steps to run our MATLAB example in serial. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedMATLABesearchComputing/examples.git
cd examples/matlab
sbatch matlab.slurm 
```
### Cluster and Partition Info
MATLAB is available on all ARC clusters.
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
This example was inspired by:[https://wiki.orc.gmu.edu/mkdocs/Matlab_with_Slurm/](https://wiki.orc.gmu.edu/mkdocs/Matlab_with_Slurm/)

More information about MATLAB can be found on in their documentation [here](https://www.mathworks.com/products/matlab.html).

