# mpi4py
MPI for Python (mpi4py) provides MPI bindings for the Python programming language, allowing any Python program to exploit multiple processors. This package build on the MPI specification and provides an object oriented interface which closely follows MPI-2 C++ bindings.

## Contents
These are the files/directories included for this example
1. `mpi4py.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `hello_mpi.py` is the python script to show how to run mpi4py

## How to run
The following are steps to run our mpi4py example on our Tinkercliffs cluster. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
```
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/mpi4py
sbatch mpi4py.slurm 
```

### Cluster and Partition Info
mpi4py is available on all ARC systems. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
This batch script write the mpi4py output to a file named hello_mpi_$SLURM_JOB_ID.out.
The mpi4py software documentation can be found [here](https://mpi4py.readthedocs.io/en/stable/mpi4py.html).

