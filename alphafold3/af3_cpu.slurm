#!/bin/bash

#SBATCH --job-name=af3_cpu
#SBATCH --account=<your Slurm account>
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=0-4%5  
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=4:00:00
#SBATCH --output=af3_cpu_%A_%a.out
#SBATCH --error=af3_cpu_%A_%a.err

set -u -o pipefail

module reset
module load AlphaFold/3.0.4

# ----- READ THIS TO UNDERSTAND HOW ALPHAFOLD RUNS ON ARC CLUSTERS -----
# On ARC clusters, AlphaFold3 is not installed as a plain Python package. It is
# provided as a containerized application through Apptainer. Loading the
# AlphaFold module gives access to ARC's tested AlphaFold3 software stack and
# the ARC-hosted model/database files.
#
# The traditional ARC example (run_tinkercliffs_A100.sh) uses the helper command `alphafold3`, which mounts
# ~/AlphaFold3/af_input and ~/AlphaFold3/af_output into the container. This
# two-stage example calls the ARC-provided AlphaFold3 container directly so the
# CPU data pipeline and GPU inference can be submitted as separate Slurm jobs:
#
#   af3_cpu.slurm : data pipeline only  (--norun_inference)      [CPU only]
#   af3_gpui_batched.slurm : inference only      (--norun_data_pipeline)  [1 GPU]
#
# Separating the stages avoids reserving a GPU while AlphaFold3 is performing
# CPU-only database/MSA/template work.
#
# For multiple FASTA inputs, create a text file (af3_fasta_list.txt) containing 
# ONE FASTA path per line and submit this script as a Slurm array. Each array 
# element handles one FASTA input. The GPU array should use the same array indices 
# and can be linked to this CPU array with Slurm's dependency.
#
# This CPU stage uses fasta2json.py to convert each FASTA file to the AlphaFold3
# JSON input format before running the data pipeline.
#
# Learn more about Apptainer on ARC clusters:
# https://www.docs.arc.vt.edu/software/apptainer.html

# ============================================================
# USER SETTINGS
# ============================================================

# Manifest containing ONE FASTA path per line. Absolute paths are recommended.
# Do not include blank lines.
MANIFEST="${MANIFEST:-${SLURM_SUBMIT_DIR:-$PWD}/af3_fasta_list.txt}"

# FASTA -> AlphaFold3 JSON converter used by the ARC example.
FAST2JSON_SCRIPT="${FAST2JSON_SCRIPT:-${SLURM_SUBMIT_DIR:-$PWD}/fasta2json.py}"

# Persistent root for CPU-stage outputs.
AF3_ROOT="${AF3_ROOT:-$HOME/AlphaFold3}"
CPU_OUT_ROOT="${CPU_OUT_ROOT:-$AF3_ROOT/af_output_cpu}"
WORK_ROOT="${WORK_ROOT:-$AF3_ROOT/work_cpu}"

# ARC AlphaFold3 paths.
ALPHAFOLD_VERSION="3.0.4"
ALPHAFOLD_SIF="/apps/common/software/AlphaFold/${ALPHAFOLD_VERSION}/alphafold3-${ALPHAFOLD_VERSION}.sif"
MODEL_DIR="/common/data/alphafold/3/model"
DB_DIR="/common/data/alphafold/3/public_databases"

# ============================================================
# SELECT THIS ARRAY TASK'S FASTA INPUT
# ============================================================

TASK_ID="${SLURM_ARRAY_TASK_ID:-0}"
CPU_ARRAY_JOB_ID="${SLURM_ARRAY_JOB_ID:-${SLURM_JOB_ID:-manual}}"

if [[ ! -f "$MANIFEST" ]]; then
    echo "[ERROR] Manifest not found: $MANIFEST"
    exit 1
fi

FASTA_INPUT=$(sed -n "$((TASK_ID + 1))p" "$MANIFEST")
FASTA_INPUT="${FASTA_INPUT%$'\r'}"

if [[ -z "$FASTA_INPUT" ]]; then
    echo "[ERROR] No FASTA entry found for array task $TASK_ID."
    exit 1
fi

# Resolve relative entries relative to the submission directory.
if [[ "$FASTA_INPUT" != /* ]]; then
    FASTA_INPUT="${SLURM_SUBMIT_DIR:-$PWD}/$FASTA_INPUT"
fi

if [[ ! -f "$FASTA_INPUT" ]]; then
    echo "[ERROR] FASTA file not found: $FASTA_INPUT"
    exit 1
fi

if [[ ! -f "$FAST2JSON_SCRIPT" ]]; then
    echo "[ERROR] fasta2json.py not found: $FAST2JSON_SCRIPT"
    exit 1
fi

if [[ ! -f "$ALPHAFOLD_SIF" ]]; then
    echo "[ERROR] AlphaFold3 container not found: $ALPHAFOLD_SIF"
    exit 1
fi

FASTA_BASENAME=$(basename "$FASTA_INPUT")
JOB_NAME="${FASTA_BASENAME%.*}"

# ============================================================
# UNIQUE DIRECTORIES FOR THIS ARRAY ELEMENT
# ============================================================

# Keep CPU outputs grouped by the CPU array job ID and task ID. This prevents
# different array runs or inputs with the same basename from overwriting each
# other.
CPU_TASK_OUT="$CPU_OUT_ROOT/$CPU_ARRAY_JOB_ID/task_$TASK_ID"
WORK_DIR="$WORK_ROOT/$CPU_ARRAY_JOB_ID/task_$TASK_ID"
IN="$WORK_DIR/af_input"

mkdir -p "$IN" "$CPU_TASK_OUT"

# ============================================================
# JOB INFORMATION
# ============================================================

echo "============================================================"
echo "AlphaFold 3 CPU-only data pipeline"
echo "Job ID: ${SLURM_JOB_ID:-N/A}"
echo "Array job ID: $CPU_ARRAY_JOB_ID"
echo "Array task ID: $TASK_ID"
echo "Node: $(hostname)"
echo "CPUs per task: ${SLURM_CPUS_PER_TASK:-8}"
echo "FASTA input: $FASTA_INPUT"
echo "CPU output directory: $CPU_TASK_OUT"
echo "Start: $(date)"
echo "============================================================"

# ============================================================
# PREPARE INPUT
# ============================================================

echo
echo "[INFO] Copying FASTA file..."
cp -f "$FASTA_INPUT" "$IN/$FASTA_BASENAME"

# Convert FASTA -> AlphaFold3 JSON.
echo
echo "[INFO] Creating AlphaFold3 JSON with fasta2json.py..."
python "$FAST2JSON_SCRIPT" "$IN/$FASTA_BASENAME"
JSON_EXIT=$?

if [[ $JSON_EXIT -ne 0 ]]; then
    echo "[ERROR] fasta2json.py failed with exit code $JSON_EXIT."
    exit "$JSON_EXIT"
fi

GENERATED_JSON="$IN/$JOB_NAME.json"

if [[ ! -f "$GENERATED_JSON" ]]; then
    echo "[ERROR] Expected JSON was not created: $GENERATED_JSON"
    echo "[INFO] Files in $IN:"
    ls -lah "$IN"
    exit 1
fi

# Use the familiar fold_input.json name inside this task's private input folder.
cp -f "$GENERATED_JSON" "$IN/fold_input.json"

echo "[INFO] Generated fold_input.json:"
cat "$IN/fold_input.json"

# ============================================================
# RUN DATA PIPELINE ONLY -- NO GPU REQUESTED
# ============================================================

echo
echo "============================================================"
echo "Starting AlphaFold3 CPU data pipeline"
echo "Time: $(date)"
echo "============================================================"

START=$(date +%s)

apptainer exec \
    --pwd /app/alphafold \
    --bind "$IN:/root/af_input" \
    --bind "$CPU_TASK_OUT:/root/af_output" \
    --bind "$MODEL_DIR:/root/models" \
    --bind "$DB_DIR:/root/public_databases" \
    "$ALPHAFOLD_SIF" \
    python run_alphafold.py \
        --json_path=/root/af_input/fold_input.json \
        --model_dir=/root/models \
        --db_dir=/root/public_databases \
        --output_dir=/root/af_output \
        --norun_inference

EXIT_CODE=$?
END=$(date +%s)

echo
echo "============================================================"
echo "CPU data pipeline finished"
echo "Exit code: $EXIT_CODE"
echo "Runtime: $((END - START)) seconds"
echo "End: $(date)"
echo "============================================================"

if [[ $EXIT_CODE -ne 0 ]]; then
    exit "$EXIT_CODE"
fi

# The CPU-only stage should produce one processed *_data.json file for this input.
mapfile -t DATA_JSONS < <(find "$CPU_TASK_OUT" -type f -name '*_data.json' | sort)

if [[ ${#DATA_JSONS[@]} -eq 0 ]]; then
    echo "[ERROR] CPU stage finished, but no *_data.json file was found under:"
    echo "        $CPU_TASK_OUT"
    find "$CPU_TASK_OUT" -maxdepth 3 -type f 2>/dev/null || true
    exit 1
fi

if [[ ${#DATA_JSONS[@]} -gt 1 ]]; then
    echo "[ERROR] More than one *_data.json file was found for this array task:"
    printf '  %s\n' "${DATA_JSONS[@]}"
    echo "Each array element in this example is expected to represent one AlphaFold input."
    exit 1
fi

echo "[INFO] Processed JSON created successfully:"
echo "       ${DATA_JSONS[0]}"

# The working input directory is no longer needed after a successful CPU stage.
rm -rf "$WORK_DIR"

exit 0
