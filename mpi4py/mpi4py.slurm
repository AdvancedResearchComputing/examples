#! /bin/bash
#
#SBATCH --job-name=mpi4py_example
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:05:00
#SBATCH --mem=1GB  #this is memory per node, total memory requested=40GB
#SBATCH --account=personal
#

#load modules
module reset
module load mpi4py

#run mpi4py hello world
mpirun -np $SLURM_NTASKS python hello_mpi.py > hello_mpi_$SLURM_JOB_ID.out
