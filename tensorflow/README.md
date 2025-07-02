# TensorFlow
TensorFlow is an open-source software package that provides tools for users to develop and run machine learning algorithms. TensorFlow can be depolyed on various
platforms like CPUs and GPUs.

## Contents
There are three files in this example
1. `tensorflow_a100gpu.slurm` is an example slurm batch submit script for using GPUs on tinkercliffs.
2. `tensorflow_cpu.slurm` is an example slurm batch submit scrip for using only CPUs. 
3. `beginner.py` is a python job script that runs a tensorflow example from tensorflow's [github](https://github.com/tensorflow/docs/blob/master/site/en/tutorials/quickstart/beginner.ipynb).

## How to run
The following are steps to run our TensorFlow example. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 

``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples
cd tensorflow
sbatch tensorflow_cpu.slurm #for cpu only calculation
sbatch tensorflow_a100gpu.slurm #for gpu calculation
```
### Notes
You then should be able to check the status of the job submission by typing `squeue`. 
Both slurm submit scripts write the output of the TensorFlow calculation to a `beginner.out` file. 
For more information and various other tutorials on TensorFlow, the user is directed to their [website](https://www.tensorflow.org/).

