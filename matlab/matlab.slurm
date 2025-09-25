#!/bin/bash

#SBATCH --job-name=matlab_cpu    # name of slurm job
#SBATCH --partition=normal_q         # partition
#SBATCH --nodes=1                         # node count
#SBATCH --ntasks-per-node=1               # number of tasks per node
#SBATCH --cpus-per-task=1                 # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --time=00:15:00                   # total run time limit (HH:MM:SS)
#SBATCH --mem=5GB
#SBATCH --account=personal                # your account allocation

## Load modules, if any.
module reset
module load MATLAB/R2024b

## Get the core number for job and other job details.
echo " ------------"
echo "Set of cores job running on: "
echo " "
scontrol show job -d  $SLURM_JOB_ID
echo " "
echo " "

## Invocation.  Matlab syntax in double-quotes.
# -nodisplay -nosplash options suppress the GUI. The -nodesktop option speeds up starting the job
matlab -nodisplay -nosplash -nodesktop -r matlab_job, exit


