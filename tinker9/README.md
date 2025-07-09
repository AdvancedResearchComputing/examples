# Tinker9
Tinker9 is a complete rewrite and extension of the canonical Tinker software, currently Tinker8. Tinker9 is implemented as C++ code with OpenACC directives and CUDA kernels providing excellent performance on GPUs.

## Contents
There is one file for this example
1. `t9-example-falcon-a30.sh` which is the slurm batch submit script. User may have to change the account name or partition based on what resources are available/needed. 

## How to run
The following are steps to run our Tinker9 example. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 

``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples
cd tinker9
sbatch t9-example-falcon-a30.sh
```

### Notes
You then should be able to check the status of the job submission by typing `squeue`. 
This example script is set up to put the Tinker9 job output into the slurm ouput file with the job ID.
We also include a gpu monitoring out in the `job-SLURM_JOB_ID-gpu.log` text file.
The Tinker9 documentation can be found [here](https://tinker9-manual.readthedocs.io/en/latest/index.html#).
