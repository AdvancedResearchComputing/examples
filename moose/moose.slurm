#!/bin/bash
# ----------------------------------------------------------------------------------------
#
#SBATCH --job-name=moose_example
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:30:00
#SBATCH --mem=5GB  #this is memory per node, total memory requested=40GB
#SBATCH --account=personal

module reset
module load Miniforge3/25.11.0-1

source activate moose

echo which moose-opt

#run the tutorial example
mpirun -n $SLURM_NTASKS moose-opt -i ex01.i

