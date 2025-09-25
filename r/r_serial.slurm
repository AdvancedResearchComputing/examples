#!/bin/bash
#SBATCH --job-name=R_serial             # name of slurm job
#SBATCH --partition=normal_q            # partition
#SBATCH --nodes=1                       # node count
#SBATCH --ntasks-per-node=2             # number of tasks per node
#SBATCH --cpus-per-task=1               # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --time=00:15:00                 # total run time limit (HH:MM:SS)
#SBATCH --account=personal              # your account allocation

## Load all required modules.
module reset
module load R/4.4.2-gfbf-2024a

echo -e "\nChecking job details for CPU_IDs..."
## The switch "--details" gives the IDs of the cores of a compute node that are assigned to this job. 
scontrol show job --details $SLURM_JOB_ID

param4="normal_q"
param5=${SLURM_JOB_ID}

## Invocation of the R code.
Rscript r_script_example.R param1 param2 param3 ${param4}  ${param5}

