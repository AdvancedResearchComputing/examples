#!/bin/bash

## Translation from PBS to SLURM can be found at
## https://slurm.schedmd.com/rosetta.pdf
#SBATCH --partition=normal_q          # queue
#SBATCH --nodes=2                     # number of nodes
#SBATCH --ntasks-per-node=64          # MPI ranks per node
#SBATCH --time=0-0:05:00              # walltime
#SBATCH --account=personal

echo "Starting MPI QUADRATURE job"

# Go to submission directory
export RUNDIR=$SLURM_SUBMIT_DIR
cd $RUNDIR

# Load modules
module reset
module load foss/2025b

echo "Loaded modules:"
module list

# Compile
echo "Compiling quadrature.c"
mpicc mpi_quad.c -o mpi_quad.x -lm

# Log node list
echo $SLURM_JOB_NODELIST | uniq > node_list.log

# Start time
echo "Job begin: $(date)"

# Run MPI job
mpirun -np $SLURM_NTASKS ./mpi_quad.x

# End time
echo "Job end: $(date)"