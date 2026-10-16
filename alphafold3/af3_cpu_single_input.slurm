#!/bin/bash

#SBATCH --job-name=af3_cpu
#SBATCH --account=<slurm_account_name>
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=1:00:00

module reset
module load AlphaFold/3.0.4

# Input directory path where the input .fasta files are
# This is default set to the submit directory, but can be set at submission time
# e.g. sbatch af3_cpu_single_input.slurm $1

INPUT_FILE=$1

# ============================================================
# JOB INFORMATION
# ============================================================

echo "============================================================"
echo "AlphaFold 3 CPU-only data pipeline"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "CPUs per task: ${SLURM_CPUS_PER_TASK}"
echo "Input file:" $INPUT_FILE
echo "Start: $(date)"
echo "============================================================"

# ============================================================
# PREPARE INPUT
# ============================================================

#Convert FASTA -> AlphaFold3 JSON.
echo
echo "[INFO] Creating AlphaFold3 JSON with fasta2json.py..."
python fasta2json.py $INPUT_FILE
JSON_FILE=${INPUT_FILE%.fasta}.json
echo "JSON FILE: $JSON_FILE"

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
    --bind $SLURM_SUBMIT_DIR:/root/af_input \
    --bind $SLURM_SUBMIT_DIR:/root/af_output \
    --bind /common/data/alphafold/3/model:/root/models \
    --bind /common/data/alphafold/3/public_databases:/root/public_databases \
    $ALPHAFOLD3_CONTAINER \
    python run_alphafold.py \
        --json_path=$SLURM_SUBMIT_DIR/$JSON_FILE \
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

exit 0
