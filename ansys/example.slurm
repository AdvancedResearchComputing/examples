#!/bin/bash
######################## start of slurm options #########################################
########################################
# Job Identification & Runtime         #
########################################
#SBATCH --job-name=ansys-fluent-example     # Job name
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

# Description: SLURM job script to run ANSYS Fluent using a journal file
# Usage: sbatch example.slurm

#########################################################################################

# Reset module system and load ANSYS
module reset
module load ANSYS

# Echo job info
echo "Running ANSYS Fluent with $SLURM_CPUS_PER_TASK CPUs"

# Run Fluent in batch mode with the specified journal file
fluent 2d -g -t$SLURM_CPUS_PER_TASK -i run-injet.jou
