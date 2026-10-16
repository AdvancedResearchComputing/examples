#!/bin/bash

#SBATCH --job-name=af3_gpu
#SBATCH --account=<slurm_account_name>
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --gres=gpu:1
#SBATCH --time=4:00:00

module reset
module load AlphaFold/3.0.4

# If INPUT_DIR not set during submission, default is set to SLURM_SUBMIT_DIR/CPU_JOB_ID
INPUT_DIR="${INPUT_DIR:-$SLURM_SUBMIT_DIR/CPU_$SLURM_JOB_DEPENDENCY}"

# This is making a GPU output directory with the SLURM_JOB_ID
GPU_DIR=$SLURM_SUBMIT_DIR/GPU_$SLURM_JOB_ID
mkdir -p $GPU_DIR
mkdir -p $GPU_DIR/tmp

# Need to flatten directories so all _data.json files are in the same directory 
# This is because AF3 automatically creates top directories for each input file
for f in $(find $INPUT_DIR -mindepth 2 -maxdepth 2 -type f -name '*_data.json'); do
    cp $f $GPU_DIR
done

# ============================================================
# RUN EACH INPUT IN THIS BATCH SEQUENTIALLY ON THE SAME GPU
# ============================================================

echo "============================================================"
echo "AlphaFold3 batched GPU-only inference"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "CPUs per task: $SLURM_CPUS_PER_TASK
echo "CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES
echo "INPUT_DIR: " $INPUT_DIR
echo "Start: $(date)"
echo "============================================================"
#
echo
echo "[INFO] Initial GPU state:"
nvidia-smi

apptainer exec \
    --pwd /app/alphafold \
    --nv \
    --bind $GPU_DIR:/root/af_input \
    --bind $GPU_DIR:/root/af_output \
    --bind /common/data/alphafold/3/model:/root/models \
    --bind /common/data/alphafold/3/public_databases:/root/public_databases \
    --bind $GPU_DIR/tmp:/root/af_tmp \
    --env TMPDIR=/root/af_tmp \
    --env TMP=/root/af_tmp \
    --env TEMP=/root/af_tmp \
    $ALPHAFOLD3_CONTAINER \
    python run_alphafold.py \
    --input_dir=$GPU_DIR \
    --model_dir=/root/models \
    --db_dir=/root/public_databases \
    --output_dir=/root/af_output \
    --norun_data_pipeline

echo
echo "============================================================"
echo "GPU inference finished"
echo "End: $(date)"
echo "============================================================"

exit 0
