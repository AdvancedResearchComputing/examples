# LAMMPS
LAMMPS is a classical molecular dynamics code, and an acronym for Large-scale Atomic/Molecular Massively Parallel Simulator. LAMMPS has potentials for solid-state materials (metals, semiconductors) and soft matter (biomolecules, polymers) and coarse-grained or mesoscopic systems. It can be used to
model atoms or, more generically, as a parallel particle simulator at the atomic, meso, or continuum scale. LAMMPS runs on single processors or in parallel using message-passing techniques and a spatial-decomposition of the simulation domain. The code is designed to be easy to modify or extend
with new functionality.

## Contents
These are the files/directories included for this example
1. `lammps_hybrid_parallel.slurm` is the slurm batch submit script to run in a hybrid parallel fashion. User may have to change the account name based on what resources are available to them. 
2. `lammps_parallel.slurm` is the slurm batch submit script to run in parallel. User may have to change the account name based on what resources are available to them. 
3. `input.in` is the input file for the LAMMPS example.

## How to run
The following are steps to run the LAMMPS example on either Tinkercliffs or Owl cluster. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
```
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/lammps
sbatch lammps_parallel.slurm #for basic parallel 
```
If you want to run the hybrid parallel submit the other slurm batch script:
```
sbatch lammps_hybrid_parallel.slurm #hybird parallel setting OMP threads
```

### Cluster and Partition Info
LAMMPS is available on all ARC systems. 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
For further details about LAMMPS, you can visit their documentation site [here](https://www.lammps.org).
