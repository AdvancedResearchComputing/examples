# Gaussian
[Gaussian](https://gaussian.com/) provides state-of-the-art capabilities for electronic structure modeling. Gaussian 16 is licensed for a wide variety of computer systems. All versions of Gaussian 16 contain every scientific/modeling feature, and none imposes any artificial limitations on calculations other than your computing resources and patience. This is the official gaussian 16 C.02 AVX2 build.

## Contents
These are the files/directories included for this example
1. `gaussian.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `g16_input.txt` is the input file for an scf gaussian calculation for dioxygen.


## How to run
The following are steps to run our Gaussian example on our Tinkercliffs cluster. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
```
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/gaussian
sbatch gaussian.slurm 
```

### Cluster and Partition Info
Gaussian is available on all ARC systems. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
There will be a slurm text file generated that will contain any error messages (if they occur) and the gaussian output file is saved as gaussian_$SLURM_JOB_ID.out.
The Gaussian software documentation can be found [here](https://www.gaussian.com/).

