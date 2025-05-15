#!/bin/bash
######################## start of slurm options #########################################
########################################
# Job Identification & Runtime         #
########################################
#SBATCH --job-name=miniconda-example        # Job name
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

# Description: SLURM job script to create conda env, install numpy, and run Python code
# Usage: sbatch example.slurm

#########################################################################################
# Resets module system (recommended)
module reset

# Load Miniconda
module load Miniconda3

# Define environment name
ENV_NAME="numpy_env"

# Create environment if not already present
if ! conda env list | grep -q "$ENV_NAME"; then
    echo "Creating conda environment: $ENV_NAME"
    conda create -y -n "$ENV_NAME" python=3.10
fi

# Activate environment
source activate "$ENV_NAME"

# Check if conda environment is loaded correctly
echo "You are using python of this conda environment:"
which python

# Install required package
pip install --upgrade pip
pip install numpy

# Run Python script
python numpy_compute.py
