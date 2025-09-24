# PyTorch
[Pytorch](https://pytorch.org) is an open source machine learning framework that accelerates the path from research prototyping to production deployment.   

## Contents
There are two directories in this example that show you how to run PyTorch:
1. `gpu` shows how to run PyTorch using ARC GPUs
2. `cpu_only` shows how to run PyTorch through pip and for cpu-only calculations

## How to run
Please follow the included instructions for each type of example. 

### Cluster and Partition Info
You may run PyTorch with GPUs on either Tinkercliffs or Falcon clusters.
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
For more information and various other tutorials on PyTorch, the user is directed to their [website](https://www.pytorch.org/).

## Interaction
You can run PyTorch code from Jupyter Notebooks or via the command line (interactive or scripts). Ideally, you will prototype your code via Jupyter which is easily accessible from [Open OnDemand](https://ood.arc.vt.edu/). If instead, you would prefer to prototype your code via the command line, first get an interactive job as above in the install notes, then load the required software, e.g. Miniconda.

