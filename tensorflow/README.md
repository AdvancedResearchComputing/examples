# TensorFlow
TensorFlow is an open-source software package that provides tools for users to develop and run machine learning algorithms. TensorFlow can be depolyed on various
platforms like CPUs and GPUs.

## Contents
These are the files in this example
1. `tensorflow.slurm` is an example slurm batch submit script for using GPUs on tinkercliffs
3. `beginner.py` is a python job script that runs a tensorflow example from tensorflow's [github](https://github.com/tensorflow/docs/blob/master/site/en/tutorials/quickstart/beginner.ipynb).

## How to run
The following are steps to run our TensorFLow example on Tinkercliffs with one GPU. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).

``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/tensorflow
sbatch tensorflow.slurm 
```

### Cluster and Partition Info
TensorFlow is available on all clusters and can be run with or without GPUs. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 
### Notes
You then should be able to check the status of the job submission by typing `squeue`. 
Both slurm submit scripts write the output of the TensorFlow calculation to a `beginner.out` file. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
Tensorflow can also be run through a conda or python environment. For more details on this please refer to our documentation [here](https://www.docs.arc.vt.edu/software/tensorflow.html). Please make sure you are not running tensorflow on a login node! 
For more information and various other tutorials on TensorFlow, the user is directed to their [website](https://www.tensorflow.org/).



