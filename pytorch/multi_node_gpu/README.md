# Multi-node PyTorch DistributedDataParallel

This example demonstrates multi-node GPU training with PyTorch
DistributedDataParallel (DDP) on ARC.

It is adapted from PyTorch's official multi-node DDP tutorial:

https://github.com/pytorch/examples/blob/main/distributed/ddp-tutorial-series/multinode.py

ARC-specific additions include:

- Slurm-aware node and GPU reporting
- CUDA compute validation
- explicit NCCL `all_reduce` validation
- cluster-oriented success and failure diagnostics

## Files

- `multinode.py` - PyTorch DDP training example
- `pytorch_multinode.slurm` - Slurm submission script

## 1. Create the Conda environment

Before submitting the job, create a Conda environment containing a
CUDA-enabled PyTorch installation.

First request a GPU compute node:

```bash
interact \
  --account=<account> \
  --partition=a100_normal_q \
  --gres=gpu:a100:1 \
  --time=01:00:00