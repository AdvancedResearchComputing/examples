#!/bin/bash
######################## start of slurm options #########################################
########################################
# Job Identification & Runtime         #
########################################
#SBATCH --job-name=p7zip-example            # Job name
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

# Description: This is an example slurm batch job script to zip and unzip example text file using p7zip
# Usage: To run this script, run the command 'sbatch example.slurm'

#########################################################################################

# Load required module
module reset
module load p7zip

# Create a sample folder and file for demonstration
mkdir -p example
echo "This is a sample file." > example/sample.txt

# Compress the folder into a .7z archive
7z a example.7z example/

# Extract the archive to verify contents
7z x example.7z -oexample_unzipped/

# List contents of the unzipped directory
ls -R example_unzipped/
