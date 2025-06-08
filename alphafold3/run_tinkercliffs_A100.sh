#!/bin/bash
#SBATCH --account=<your Slurm account>
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00

echo "AlphaFold3 job launched on `hostname`"

module reset
module load AlphaFold/3.0.1

## Copy example input JSON file to the expected location
cp fold_input.json $HOME/AlphaFold3/af_input/fold_input.json

alphafold3

echo "Results available at $HOME/AlphaFold3/af_input"