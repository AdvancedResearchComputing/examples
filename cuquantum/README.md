# cuQuantum
This NVIDIA cuQuantum Applicance is a set of high-performance libraries and tools for accelerating quantum computing simulations at both the circuit and device level by orders of magnitude.
It contains NVIDIA’s cuStateVec, cuTensorNet, and cuDensityMat libraries which optimize state vector, tensor network, and analog quantum dynamics simulation, respectively. 

## Contents
These are the files included for this example
1. `cuquantum.slurm` is the slurm batch submit script for the tinkercliffs cluster with the A100 GPUs. User may have to change the account name based on what resources are available to them. 
2. `benchmark.py` is a local python script for a simple cuQuantum example

## How to run
The following are steps to run our cuQuantum example on tinkercliffs using the a100 gpus. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 

``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples
cd cuquantum
sbatch cuquantum.slurm 
```

### Cluster and Partition Info
cuQuantum Applicance container is available on tinkercliffs, owl, and falcon with and without cuda. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
This software is a highly performant multi-GPU solution for quantum circuit simulation so for best performace, it is advised to use the gpus on either tinkercliffs or falcon.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
You then should be able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
This example is running two different examples provided by Nividia as well as a local example named `benchmark.py`. 
The output to each of these examples is stored in their respective text files names as the following `<name of python example>_out.<slurm id>.txt`.
The cuQuantum documentation can be found [here](https://docs.nvidia.com/cuda/cuquantum/latest/index.html).

