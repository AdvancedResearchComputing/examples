# STREAM
The STREAM benchmark is a simple synthetic benchmark program that measures sustainable memory bandwidth (in MB/s) and the corresponding computation rate for simple vector kernels.

## Contents
These are the files/directories included for this example
1. `stream.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `stream.c` is the stream memory bandwidth benchmark taken from [https://www.cs.virginia.edu/stream/FTP/Code/](https://www.cs.virginia.edu/stream/FTP/Code/). 


## How to run
The following are steps to run our STREAM example on Tinkercliffs. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples
cd stream
sbatch stream.slurm 
```

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
The STREAM documentation can be found [here](https://www.cs.virginia.edu/stream/).

