# cuDSS
NVIDIA cuDSS (Preview) is a library of GPU-accelerated linear solvers with sparse matrices. It provides algorithms for solving linear systems of the following type: AX = B.

## Contents
These are the files in this example
1. `cuDSS_submit.slurm` is an example slurm batch submit script for using GPUs with OpenMPI and CUDA on Falcon.
2. `mpi_cudss.cu` is an example code that needs to be compiled with both OpenMPI and cuDSS.
3. `Makefile` is a make file that contains the instructions for the make build.

## How to run
The following are steps to run our cuDSS example on Falcon with two A30 GPUs. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).

``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/cuDSS
sbatch cuDSS_submit.slurm 
```

### Cluster and Partition Info
cuDSS is available on all clusters but should only be used on GPUs. 
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
You then should be able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
For more information and various other tutorials on cuDSS, the user is directed to their [website](https://docs.nvidia.com/cuda/cudss/index.html).



