#!/bin/bash
######################## start of slurm options #########################################
########################################
# Job Identification & Runtime         #
########################################
#SBATCH --job-name=seaborn-example          # Job name
#SBATCH --account=personal                  # Account name
#SBATCH --time=01:00:00                     # Time limit (HH:MM:SS)
#SBATCH --partition=normal_q                # Partition name
#SBATCH --output=job_output_%j.out          # Standard output file (%j = job ID)
#SBATCH --error=job_error_%j.err            # Standard error file
#######################################
# CPU and Node Configuration          #
#######################################
#SBATCH --nodes=1                           # Number of nodes
#SBATCH --ntasks-per-node=1                 # Number of tasks (processes) per node
#SBATCH --cpus-per-task=8                   # Number of CPUs per task (threading)
#SBATCH --mem=64G                           # Memory per node
########################## end of slurm options #########################################

# Description: This is an example slurm batch job script to run seaborn in python
# Usage: To run this script, run the command 'sbatch example.slurm'

#########################################################################################
# Resets module system (recommended)
module reset

# Load Seaborn
 module load Seaborn

# Run the Python script
python seaborn_plot.py
