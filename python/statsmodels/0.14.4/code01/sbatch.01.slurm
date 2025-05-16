#!/bin/bash
######################## start of slurm options #########################################
########################################
# Job Identification & Runtime         #
########################################
#SBATCH --job-name=python-statsmodels       # Job name
#SBATCH --account=arcadm                  # Account name
#SBATCH --time=01:00:00                     # Time limit (HH:MM:SS)
#SBATCH --partition=normal_q                # Partition name
#SBATCH --output=statsmodels.%j.out          # Standard output file (%j = job ID)
#SBATCH --error=statsmodels.%j.err            # Standard error file
#######################################
# CPU and Node Configuration          #
#######################################
#SBATCH --nodes=1                           # Number of nodes
#SBATCH --ntasks-per-node=1                 # Number of tasks (processes) per node
#SBATCH --cpus-per-task=1                   # Number of CPUs per task (threading)
## #SBATCH --mem=64G                           # Memory per node
########################## end of slurm options #########################################

# Description: SLURM job script to create conda env, install numpy, and run Python code
# Usage: sbatch example.slurm

#########################################################################################
# Resets module system (recommended)
module reset

# Load Miniconda
module load Miniconda3

# Define environment name
ENV_NAME="statsmodels_env"

# Create environment if not already present.
# Statsmodels can only do up to python 3.10.
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
## pip install statsmodels
## pip install numpy
python -m pip install statsmodels==0.14.4
python -m pip install numpy

# Run Python script
OUT_FILE_NAME="sm.01.out"
python sm.01.py --outfile ${OUT_FILE_NAME}




