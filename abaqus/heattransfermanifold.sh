#!/bin/bash
#SBATCH --nodes=1
#SBATCH --partition=normal_q
#SBATCH --constraint=amd
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
## Replace "personal" with the name of your slurm account
#SBATCH --account=personal
## This job is intended for CPU nodes on either the Tinkercliffs or Owl clusters
## normal_q has multiple types of CPU nodes with differing features like "amd", "intel", or "avx512".
## We specify which node types to select with the "--constraint=" option as above

module reset
module load ABAQUS/2024

# /scratch/<username> is preferred place for staging and running jobs
cd $SLURM_SUBMIT_DIR
echo "working in `pwd`"

#echo "Current license availability is:"
#abaqus licensing lmdiag -n

echo "Unsetting SLURM_GTIDS=$SLURM_GTIDS to prevent <IBM Platform MPI> error"
unset SLURM_GTIDS

# Input files are provided as part of the ABAQUS installation. Documentation on the example is available here:
# https://docs.software.vt.edu/abaqusv2024/English/?show=SIMACAEEXARefMap/simaexa-c-heattransmanifold.htm
echo "Fetching job files from Abaqus installation"
abaqus fetch job=heattransfermanifold*

echo "Running with cpus=$SLURM_NTASKS"
abaqus analysis job=heattransfermanifold cpus=$SLURM_NTASKS interactive
abaqus analysis job=heattransfermanifold_cavity cpus=$SLURM_NTASKS interactive
abaqus analysis job=heattransfermanifold_cavity_parallel cpus=$SLURM_NTASKS interactive