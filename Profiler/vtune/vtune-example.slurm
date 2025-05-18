#!/bin/bash
######################## start of slurm options #########################################
########################################
# Job Identification & Runtime         #
########################################
#SBATCH --job-name=vtune-profile              # Job name
#SBATCH --account=personal                    # Account name
#SBATCH --time=01:00:00                       # Time limit (HH:MM:SS)
#SBATCH --partition=normal_q                  # Partition name
#SBATCH --output=job_output_%j.out            # Standard output file (%j = job ID)
#SBATCH --error=job_error_%j.err              # Standard error file
#######################################
# CPU and Node Configuration          #
#######################################
#SBATCH --nodes=1                             # Number of nodes
#SBATCH --ntasks-per-node=1                   # Number of tasks per node
#SBATCH --cpus-per-task=8                     # Number of CPUs for profiling
#SBATCH --mem=8G                              # Memory per node
########################## end of slurm options #########################################

# Description: This SLURM job script profiles an application using Intel VTune Profiler CLI
# and generates a performance report.

#########################################################################################
# Load VTune module
module reset
module load VTune

# Define profiling parameters
APP_PATH="my_app"                                  # Path to the binary
RESULTS_DIR="vtune_results_${SLURM_JOB_ID}"        # Unique output directory
ANALYSIS_TYPE="hotspots"                           # Change to "memory-access", "threading", etc.

# Define paths
SRC="my_app.c"
BIN="my_app"

# Compile the C program (optional if precompiled)
gcc -O2 -o "$BIN" "$SRC"

# Create results directory
mkdir -p "$RESULTS_DIR"

# Run VTune profiling
vtune -collect $ANALYSIS_TYPE \
      -result-dir "$RESULTS_DIR" \
      "$APP_PATH" > "$RESULTS_DIR/vtune_output.log" 2>&1

# Summarize results
vtune -report summary -result-dir "$RESULTS_DIR" > "$RESULTS_DIR/summary.txt"

# Completion log
echo "VTune profiling completed at $(date)"
echo "Results saved in $RESULTS_DIR"
