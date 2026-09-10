#!/bin/bash
#
#SBATCH --job-name=pytorch_ddp
#SBATCH --time=00:15:00
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:a100:1
#SBATCH --partition=a100_normal_q
#SBATCH --qos=tc_a100_normal_base
#SBATCH --account=personal
#

# Load modules
module reset
module load Miniconda3

# Activate the Conda environment created in the README
source activate pytorch-ddp

# First node coordinates the distributed job
export MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export MASTER_PORT=29500

# Optional: useful NCCL diagnostics
export NCCL_DEBUG=INFO

echo "Allocated nodes:"
scontrol show hostnames "$SLURM_JOB_NODELIST"

echo "MASTER_ADDR=$MASTER_ADDR"
echo "MASTER_PORT=$MASTER_PORT"

# Launch one torchrun process on each node
srun bash -c '
    echo "Starting on $(hostname)"

    torchrun \
        --nnodes=$SLURM_NNODES \
        --nproc-per-node=1 \
        --node-rank=$SLURM_NODEID \
        --master-addr='"$MASTER_ADDR"' \
        --master-port='"$MASTER_PORT"' \
        multinode.py \
        5 \
        2 \
        --batch-size 32
'