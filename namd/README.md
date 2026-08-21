# NAMD
NAMD is a parallel molecular dynamics code designed for high-performance simulation of large biomolecular systems.

## Contents
These are the files/directories included for this example
1. `gpu`
    - `namd_gpu.slurm` is the slurm batch script.
    - `par_all22_prot.inp` is the force-field parameter file (CHARMM22 protein)
    - `tiny.namd` NAMD configuration file
    - `tiny.pdb` is the PDB protein data bank coordinate file
    - `tiny.psf` is the PSF protein structure file
2. `mpi`
    - `namd.slurm` is the slurm batch script.
    - `par_all22_prot.inp` is the force-field parameter file (CHARMM22 protein)
    - `tiny.namd` NAMD configuration file
    - `tiny.pdb` is the PDB protein data bank coordinate file
    - `tiny.psf` is the PSF protein structure file
3. `multicore`
    - `namd_multicore.slurm` is the slurm batch script.
    - `par_all22_prot.inp` is the force-field parameter file (CHARMM22 protein)
    - `tiny.namd` NAMD configuration file
    - `tiny.pdb` is the PDB protein data bank coordinate file
    - `tiny.psf` is the PSF protein structure file

All of these examples are the same, just run in different ways with different versions of NAMD 3.0.3.

### MPI Notes
This version enables MPI for NAMD 3.0.3. With this version, you can run multiple MPI tasks across multiple nodes, but no multithreading
(i.e. you can only run with `--cpus-per-task=1`).

### Multicore Notes
This multicore version enables multithreading (i.e. you can run with multiple cpus per task `--cpus-per-task=N` where N>1).
This version can only be run on a single node! 

### GPU version Notes
If you would like the GPU-resident version of NAMD 3.0.3, you must turn on GPU-resident in the NAMD config file. 
GPU-resident mode allows almost all calculations during dynamics simulations to be performed on the GPU. 
Performance for single GPU simulation can give 2x or more speedup versus GPU-offload.

Using too many CPU cores per GPU might slow down performance, due to some extra overhead introduced for managing each core. 
The number of CPU cores to use per device depends on the size of the system, where the use of more cores for larger systems might improve performance.

If you do not turn on GPU-resident, it will run in the GPU-offload mode.

GPU support for NAMD is only currently supported for a single node, similar to the multicore CPU version!
See notes in slurm batch for how to run with multiple GPUs.

## How to run
The following are steps to run our NAMD example with the multicore version. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples
cd namd/multicore
sbatch namd_multicore.slurm 
```

### Cluster and Partition Info
NAMD is available on all clusters.
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### General Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
The NAMD documentation can be found [here](https://www.ks.uiuc.edu/Research/namd/3.0.2/notes.html).

