#!/bin/bash
######################## start of slurm options #########################################
########################################
# Job Identification & Runtime         #
########################################
#SBATCH --job-name=gurobi                   # Job name
#SBATCH --account=arcadm                    # Account name
#SBATCH --time=01:00:00                     # Time limit (HH:MM:SS)
#SBATCH --partition=normal_q                # Partition name
#SBATCH --output=gurobi.%j.out              # Standard output file (%j = job ID)
#SBATCH --error=gurobi.%j.err               # Standard error file
#######################################
# CPU and Node Configuration          #
#######################################
#SBATCH --nodes=1                           # Number of nodes
#SBATCH --ntasks-per-node=1                 # Number of tasks (processes) per node
#SBATCH --cpus-per-task=1                   # Number of CPUs per task (threading)
## #SBATCH --mem=64G                           # Memory per node
########################## end of slurm options #########################################

#########################################################################################
# Reset module system.
module reset

# Load Gurobi.
module load Gurobi/12.0.1-GCCcore-13.3.0

# Run gurobi script
sh run.01




