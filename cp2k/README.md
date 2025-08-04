# CP2K
CP2K molecular dynamics software, running via Apptainer container. As noted by their [documentation](https://github.com/cp2k/cp2k-containers), MPI can be run within the container or outside of the container.
It is important to note, that running MPI inside a container can only be done for a single compute node. For multi-node jobs, you must run MPI outside of the container. We provide both examples of this. 

## Contents
These are the files/directories included for this example
1. `cp2k_external_mpi.slurm` is the slurm batch submit script that runs mpi outside of the container. User may have to change the account name based on what resources are available to them. 
2. `cp2k_internal_mpi.slurm` is the slurm batch submit script that runs mpi inside the container. User may have to change the account name based on what resources are available to them. 

## How to run
The following are steps to run our CP2K external mpi example on Tinkercliffs. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/cp2k
sbatch cp2k_external_mpi.slurm 
```

### Cluster and Partition Info
CP2K is available on all clusters. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
The CP2K documentation can be found [here](https://www.cp2k.org/).

