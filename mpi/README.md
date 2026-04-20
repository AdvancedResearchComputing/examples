# HPC Examples: MPI and MPI+CUDA

This repository contains example programs and SLURM submission scripts for running parallel applications using MPI and MPI + CUDA on HPC clusters.

These examples are intended to help users understand:

- Basic MPI programming
- Multi-node GPU-aware MPI execution
- Performance scaling across CPUs and GPUs
- Proper SLURM job configuration

## Contents
This repository includes the following example categories:
1. **MPI (CPU-only)**

- `mpihello.c` – Basic MPI hello world program

- `tc-mpihello.slurm` – SLURM script for CPU-based MPI jobs for Tinkercliffs cluster 

2. **MPI Quadrature (CPU parallel computation)**

`mpi_quad.c` – MPI program to approximate π using numerical integration

`tc-mpiquad.slurm` – SLURM script for distributed CPU computation for Tinkercliffs cluster 

3. **MPI + CUDA (Multi-node GPU)**

`mpi_cuda.cu` – Example demonstrating MPI with GPU acceleration

`fl-mpicuda.slurm` – SLURM script for GPU-based MPI jobs for Falcon cluster 

`Makefile` – Build instructions for CUDA + MPI code

## How to run
The following are steps to run our examples on Tinkercliffs and Falcon clusters. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).

``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/mpi
```
**Choose an example**
**Run MPI Hello World**
```
sbatch tc-mpihello.slurm
```
**Run MPI Quadrature**
```
sbatch tc-mpiquad.slurm
```
**Run MPI + CUDA**
```
sbatch fl-mpicuda.slurm
```
### Cluster and Partition Info
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
You then should be able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
For more information and various other tutorials on cuDSS, the user is directed to their [website](https://docs.nvidia.com/cuda/cudss/index.html).