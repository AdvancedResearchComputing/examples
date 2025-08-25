#!/bin/bash
#SBATCH --account=personal
#SBATCH --partition=l40s_normal_q
#SBATCH --time=1-0:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --gres gpu:l40s:2
#SBATCH --output=Qwen3-32B.log

module load vLLM

vllm serve /common/data/models/qwen--Qwen3-32B \
--served-model-name Qwen3-32B \
--tensor-parallel-size 2 \
--max-model-len 32768 \
--max-seq-len-to-capture 32768 \
--swap-space 16 \
--port 8000 \
--api-key a3b91d38-6c74-4e56-b89f-3b2cfd728d1a
