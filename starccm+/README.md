# Overview

This workflow runs a Simcenter STAR-CCM+ simulation in batch (non-GUI) mode on an HPC cluster using SLURM.

## Contents
These are the files/directories included for this example
1. `submit_starccm+.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `simple_airfoil_flow.sim` STAR-CCM+ simulation file


## How to run
The following are steps to run our SU2 example. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/starccm+
sbatch submit_starccm+.slurm 
```

### Cluster and Partition Info
STAR-CCM+ is available on all clusters.  
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

## Machine File Generation (Required for multi-node jobs)
You can run STAR-CCM+ across multiple nodes. If you are going to do this, you must create a file that holds the host names of the nodes that are allocated to the job.

Uncomment the lines in the `submit_starccm+.slurm` script that create this machine file and include it in the starccm+ executable.

```
 # Multi-node jobs (machine file required), uncomment both lines below:
 scontrol show hostnames $SLURM_JOB_NODELIST > machinefile.$SLURM_JOB_ID
 starccm+ -licpath 1999@starccm.software.vt.edu -batch -np $SLURM_NTASKS -machinefile machinefile.$SLURM_JOB_ID simple_airfoil_flow.sim
```

- STAR-CCM+ requires a machinefile for multi-node jobs.
- SLURM dynamically generates the list of allocated hosts.
- The file is unique per job ($SLURM_JOB_ID).


### License limits

Depending on the license you're using, the license server may allow only a limited number of `ccmppower` tokens scale with the level of parallelization.

These are the two licenses servers that we have seen people use for StarCCM+ on ARC systems:

 - `-licpath 1999@starccm.software.vt.edu`

 - `-licpath 1999@flex.cd-adapco.com`

The first is the license server hosted by the VT Software Service Center (used in this example). The second is a license server external to VT that we sometimes see people reference when they have StarCCM+ POD license keys.

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
