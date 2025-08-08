# Rclone
Rclone is a command line program to sync files and directories to and from a variety of online storage services

## Contents
These are the files/directories included for this example
1. `rclone_example.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 

## How to run
The following are steps to run our Rclone example on our Tinkercliffs cluster. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
```
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/rclone
sbatch rclone_example.slurm 
```

### Cluster and Partition Info
Rclone is available on all ARC systems. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
The rclone software documentation can be found [here](https://www.rclone.org/).

