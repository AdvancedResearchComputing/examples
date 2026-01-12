#!/bin/bash -l
#SBATCH -J pfc3d_mod
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=1G
#SBATCH --time=01:00:00
#SBATCH --output=slurm-%x-%j.out
#SBATCH --error=slurm-%x-%j.err

set -euo pipefail

# Load Itasca quietly
module -q reset 
module -q load Itasca-PFC/7.00

# Resolve absolute path to console binary (after module load)
PFC_BIN="$(command -v pfc3d700_console || true)"
[[ -z "$PFC_BIN" ]] && { echo "ERROR: pfc3d700_console not found after module load"; module list; echo "PATH=$PATH"; exit 127; }

# Inputs 
INPUT_DAT="${INPUT_DAT:-Simple_Exm.dat}"
INPUT_PRJ="${INPUT_PRJ:-Simple_Exm.prj}"


# Per-job working dir
JOBDIR="${SLURM_SUBMIT_DIR:-$PWD}"
RUNDIR="$JOBDIR/run_${SLURM_JOB_ID:-manual}"
mkdir -p "$RUNDIR/logs"
cd "$RUNDIR"
cp -f "$JOBDIR/$INPUT_DAT" .
[[ -f "$JOBDIR/$INPUT_PRJ" ]] && cp -f "$JOBDIR/$INPUT_PRJ" .

# Run directly (NO srun) so the module PATH stays in effect
LOG="logs/${INPUT_DAT%.*}_$(date +%Y%m%d-%H%M%S).log"
echo "[$(date)] Using PFC_BIN=$PFC_BIN" | tee -a "$LOG"
"$PFC_BIN" "$INPUT_DAT" >"$LOG" 2>&1
echo "Exit code: $?"

