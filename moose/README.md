# MOOSE
The Multiphysics Object-Oriented Simulation Environment (MOOSE) is a finite-element, multiphysics framework primarily developed by Idaho National Laboratory. It provides a high-level interface to some of the most sophisticated nonlinear solver technology on the planet. MOOSE presents a straightforward API that aligns well with the real-world problems scientists and engineers need to tackle. Every detail about how an engineer interacts with MOOSE has been thought through, from the installation process through running your simulation on state of the art supercomputers, the MOOSE system will accelerate your research.

## Contents
These are the files/directories included for this example
1. `moose.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `ex01.i` is the MOOSE input file
3. `mug.e` is the mesh data file

## How to run
The following are steps to run our MOOSE example. This example uses MOOSE from within a conda virtual environment, so first you must build the conda environment.

### CPU-only Conda Steps
```
module load Miniforge3
conda config --add channels https://conda.software.inl.gov/public
conda config --add channels conda-forge
conda create -n moose moose
```

### Run the code
The following are steps to run our MOOSE example. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/moose
sbatch moose.slurm 
```

### Cluster and Partition Info
This example uses MOOSE from inside a conda virtual environment.
If you are running on a GPU node, make sure your MOOSE install was make to be GPU-enabled.
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
This cpu example was built from [https://mooseframework.inl.gov/getting_started/examples_and_tutorials/examples/ex01_inputfile.html](https://mooseframework.inl.gov/getting_started/examples_and_tutorials/examples/ex01_inputfile.html).
There are additional examples and tutorials on their [website](https://mooseframework.inl.gov/getting_started/examples_and_tutorials/index.html).
The MOOSE documentation can be found [here](https://mooseframework.inl.gov/index.html/).
The open-source code can be found [here](https://github.com/idaholab/moose).

