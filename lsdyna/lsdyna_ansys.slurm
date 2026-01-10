#!/bin/bash
#SBATCH --job-name=ansys_lsdyna
#SBATCH --account=your_allocation    # CHANGE THIS
#SBATCH --partition=normal_q
#SBATCH --time=12:00:00
#SBATCH --output=ansys_lsdyna_%j.out
#SBATCH --error=ansys_lsdyna_%j.err
#SBATCH --mail-user=<pid>@vt.edu
#SBATCH --mail-type=begin,end,fail

# =======================================================================
#  1. RESOURCE CONFIGURATION
#  Adjust these numbers based on the limits of the node you expect to use.
# =======================================================================
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32      # Adjust logic: Rome(128), Genoa(96), Milan(64/128)
#SBATCH --cpus-per-task=4         # Adjust based on OpenMP threads needed

# =======================================================================
#  2. HARDWARE SELECTION (OPTIONAL)
#  Uncomment ONE option below to force a specific node type.
#  If left commented, the scheduler will pick any available node in the partition.
# =======================================================================

# --- OPTION A: TINKERCLIFFS (AMD ROME) ---
# Node Max: 128 Cores
# #SBATCH --constraint=amd

# --- OPTION B: OWL (AMD GENOA) ---
# Node Max: 96 Cores
# #SBATCH --constraint=genoa

# --- OPTION C: OWL (AMD MILAN) ---
# Node Max: 64 Cores (Standard) or 128 Cores (Large/Huge Mem)
# #SBATCH --constraint=milan

# =======================================================================
#  3. MODULE LOAD
# =======================================================================
module reset
# Load the latest available Ansys module (Ensure version matches your license availability)
module load ANSYS/2024R1

# =======================================================================
#  4. SOLVER CONFIGURATION
# =======================================================================
# Select the wrapper command:
# "lsdyna"    = Standard (often auto-selects DP in recent versions)
# "lsdyna_dp" = Explicit Double Precision (Recommended for accuracy)
# "lsdyna_sp" = Explicit Single Precision (Faster, less accurate)

SOLVER_CMD="lsdyna"

INPUT_FILE="main.k"

# =======================================================================
#  5. RUN COMMAND
# =======================================================================
echo "Running Ansys LS-DYNA on $(hostname)"
echo "Solver: $SOLVER_CMD"

# -dis: Distributed memory (MPI)
# -np: Number of processors
# i=: Input file

$SOLVER_CMD -dis -np $SLURM_NTASKS i=$INPUT_FILE

echo "Job Complete"