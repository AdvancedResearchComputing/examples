#!/bin/bash
######################## start of slurm options #########################################
########################################
# Job Identification & Runtime         #
########################################
#SBATCH --job-name=rclone-sync               # Job name
#SBATCH --account=personal                   # Account name
#SBATCH --time=01:00:00                      # Time limit (HH:MM:SS)
#SBATCH --partition=normal_q                 # Partition name
#SBATCH --output=job_output_%j.out           # Standard output file (%j = job ID)
#SBATCH --error=job_error_%j.err             # Standard error file
#######################################
# CPU and Node Configuration          #
#######################################
#SBATCH --nodes=1                            # Number of nodes
#SBATCH --ntasks-per-node=1                  # Number of tasks (processes) per node
#SBATCH --cpus-per-task=1                    # Number of CPUs per task (rclone is I/O bound)
#SBATCH --mem=4G                             # Memory per node
########################## end of slurm options #########################################

# Description: This SLURM job script creates a file in the source directory
# and uses rclone to sync it to the destination directory on the same server,
# setting up a local remote programmatically.

#########################################################################################
# Load rclone module
module reset
module load rclone

# Create source and destination directories
mkdir -p "$HOME/source"
mkdir -p "$HOME/dest"

# Create a test file in the source directory
echo "This is a test file created at $(date)" > "$HOME/source/testfile_$(date +%s).txt"

# Set a custom config file path (to avoid modifying user's existing config)
export RCLONE_CONFIG="$HOME/rclone_auto.conf"

# Create a minimal config file with a local remote named tinkercliffs1
cat <<EOF > "$RCLONE_CONFIG"
[tinkercliffs1]
type = local
EOF

# Define rclone source and destination paths
SRC_REMOTE="tinkercliffs1:$HOME/source"
DEST_REMOTE="tinkercliffs1:$HOME/dest"

# Sync using the generated config
rclone sync "$SRC_REMOTE" "$DEST_REMOTE" --progress --verbose --config "$RCLONE_CONFIG"

# Log completion
echo "Sync completed at $(date)"
