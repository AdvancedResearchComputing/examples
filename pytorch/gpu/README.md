# PyTorch
[Pytorch](https://pytorch.org) is an open source machine learning framework that accelerates the path from research prototyping to production deployment.   

## Contents
These are the files in this example
1. `pytorch_gpu.slurm` is an example slurm batch submit script for using GPUs on tinkercliffs
2. `cifar10_gpu.py` is a python job script that runs a pytorch example with GPUs from [PyTorch docs](https://docs.pytorch.org/tutorials/beginner/blitz/cifar10_tutorial.html#sphx-glr-beginner-blitz-cifar10-tutorial-py).

## How to run
ARC provides a module on the CPU partitions PyTorch/2.1.2-foss-2023a and GPU partitions PyTorch/2.1.2-foss-2023a-CUDA-12.1.1. However, since PyTorch is continually releasing new versions, it’s recommended to be installed via pip. To install PyTorch, you should first get an interactive job on a GPU node, load Miniconda and then create the environment. We recommend installing ipykernel to let you connect your environment with Jupyter running on Open OnDemand.

The following are steps to run our PyTorch example on Tinkercliffs with one GPU.  
```
## Example on TinkerCliffs for A100 nodes:
interact --account=<your allocation> --partition=a100_normal_q -N 1 -n 12 --gres=gpu:1
module load Miniconda3
module list ## make sure cuda is loaded if you are using the GPU
nvidia-smi  ## make sure you see GPUs
conda create -n pytorch
source activate pytorch
pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu126
```

**Important**: Verify the PyTorch version installed is the CPU or GPU.
```
$ python
>> import torch
>> print(torch.__version__)
>> print(torch.version.cuda)          # None if CPU-only
>> print(torch.backends.cudnn.enabled)
>> print(torch.cuda.is_available())   # True if a compatible GPU is available and CUDA is enabled
```

Once you have created the conda environment and verified that it is configured correctly (i.e. has access to GPUs and CUDA is enabled), you can clone the GitHub examples repo. 
This will give you access to all examples in our GitHub repo.
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/pytorch/gpu
sbatch pytorch_gpu.slurm
```

Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).


### Cluster and Partition Info
PyTorch is available on all clusters and can be run with or without GPUs. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
You then should be able to check the status of the job submission by typing `squeue`. 
This examples created a `data` directory, a`cifar_net.pth` file, and the output is stored in `cifar10_gpu.out`.
Additionally, this example slurm batch script generates a `gpu_tc.txt` file that shows the GPU utilization.
You can comment or delete that line that starts with nvidia-smi if you do not want to track GPU usage.
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
For more information and various other tutorials on PyTorch, the user is directed to their [website](https://www.pytorch.org/).

```{warning}
NOTE: GPU support for AI/ML codes can offer SIGNIFICANT computational speed improvments. Simply installing the defaults as per the docs may or may not result in code utilizing the GPUs. Test your code with a small example prior to running your full dataset. You can ssh to the node your job is running on and use nvidia-smi to see that your code is running on the GPU.
```

## Interaction

You can run PyTorch code from Jupyter Notebooks or via the command line (interactive or scripts). Ideally, you will prototype your code via Jupyter which is easily accessible from [Open OnDemand](https://ood.arc.vt.edu/). If instead, you would prefer to prototype your code via the command line, first get an interactive job as above in the install notes, then load the required software, e.g. Miniconda.

