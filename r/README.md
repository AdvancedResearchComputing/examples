# R
R is a free software environment for statistical computing and graphics. R provides a wide variety of statistical (linear and nonlinear modelling, classical statistical tests, time-series analysis, classification, clustering, …) and graphical techniques, and is highly extensible.

## Contents
These are the files/directories included for this example
1. `r_serial.slurm` is the slurm batch submit script to run R in serial. User may have to change the account name based on what resources are available to them. 
2. `r_parallel.slurm` is the slurm batch submit script to run R in parallel. User may have to change the account name based on what resources are available to them. 
3. `r_script_example.R` is the sample R script.
4. `archived_examples` is a folder that holds old scripts and additional examples. 

## How to run
The following are steps to run our R example in serial. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/r
sbatch r_serial.slurm 
```

If you would like to run the parallel version, replace `r_serial.slurm` with `r_parallel.slurm`.
Please note that the sample R script **IS NOT** written to take advantage of parallel computing. It is simply just used to show how a parallel R code can be run on our clusters.
You will need to tailor your specific R script to take advantage of multi-threading/multi-processing or else it will be a waste of ARC resources. 

### Cluster and Partition Info
R is available on all ARC clusters.
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
This R example script generates an output file titled: `output.SLURM_JOB_ID.txt`.
More information about R can be found on in their documentation [here](https://www.r-project.org/).

