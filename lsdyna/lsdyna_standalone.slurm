#!/bin/bash
#SBATCH --job-name=lsdyna_standalone
#SBATCH --account=your_allocation    # CHANGE THIS
#SBATCH --partition=normal_q
#SBATCH --time=12:00:00
#SBATCH --output=lsdyna_%j.out
#SBATCH --error=lsdyna_%j.err
#SBATCH --mail-user=<pid>@vt.edu
#SBATCH --mail-type=begin,end,fail

# =======================================================================
#  1. RESOURCE CONFIGURATION
#  Adjust these numbers based on the limits of the node you select below.
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
#  3. LICENSE & ENVIRONMENT
# =======================================================================
export LSTC_LICENSE="network"
export LSTC_LICENSE_SERVER="network_license_ip@port" # CHANGE THIS

module reset
module load LS-DYNA/16.0.0-openmpi-4.1.6

# =======================================================================
#  4. AUTOMATIC EXECUTABLE SELECTION (AVX2 vs AVX512)
# =======================================================================
# 1. Define executable names
EXE_AVX512="ls-dyna_mpp_d_R16_0_0_x64_centos79_ifort190_avx512_openmpi405"
EXE_AVX2="ls-dyna_mpp_d_R16_0_0_x64_centos79_ifort190_avx2_openmpi405"

# 2. Check CPU flags on the allocated node
if grep -q "avx512f" /proc/cpuinfo; then
    echo "Hardware: AVX-512 supported (Genoa or Intel)."
    LSDYNA_EXE=$EXE_AVX512
else
    echo "Hardware: AVX-512 NOT supported. Using AVX2 (Rome or Milan)."
    LSDYNA_EXE=$EXE_AVX2
fi

# Note: If you need Single Precision, change '_d_' to '_s_' in definitions above.

# =======================================================================
#  5. RUN COMMAND
# =======================================================================
INPUT_FILE="main.k"

echo "Running on host: $(hostname)"
echo "CPU Model: $(grep 'model name' /proc/cpuinfo | head -1)"
echo "Selected Solver: $LSDYNA_EXE"

mpirun -np $SLURM_NTASKS $LSDYNA_BIN/$LSDYNA_EXE i=$INPUT_FILE 

echo "Job Complete"