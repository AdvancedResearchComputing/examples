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
# e.g. sbatch --export=ALL,INPUT_DIR="/path/to/input/directory" af3_cpu.slurm
INPUT_DIR="${INPUT_DIR:-$SLURM_SUBMIT_DIR}"

# ============================================================
# JOB INFORMATION
# ============================================================

echo "============================================================"
echo "AlphaFold 3 CPU-only data pipeline"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "CPUs per task: ${SLURM_CPUS_PER_TASK}"
echo "Input directory:" $INPUT_DIR
echo "Start: $(date)"
echo "============================================================"

# ============================================================
# PREPARE INPUT
# ============================================================

echo
echo "[INFO] Creating JSON input directory..."
JSON_DIR=$SLURM_SUBMIT_DIR/CPU_$SLURM_JOB_ID
mkdir -p $JSON_DIR

#Convert FASTA -> AlphaFold3 JSON.
echo
echo "[INFO] Creating AlphaFold3 JSON with fasta2json.py..."
for fasta_file in $(ls $INPUT_DIR/*.fasta | sed 's/\.fasta$//'); do
    python fasta2json.py $fasta_file.fasta
    mv $fasta_file.json $JSON_DIR
done

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
    --bind $JSON_DIR:/root/af_input \
    --bind $JSON_DIR:/root/af_output \
    --bind /common/data/alphafold/3/model:/root/models \
    --bind /common/data/alphafold/3/public_databases:/root/public_databases \
    $ALPHAFOLD3_CONTAINER \
    python run_alphafold.py \
        --input_dir=$JSON_DIR \
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
