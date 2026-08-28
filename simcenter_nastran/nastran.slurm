#!/bin/bash
# ----------------------------------------------------------------------------------------
#
#SBATCH --job-name=nastran_example
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=2
#SBATCH --time=0-0:30:00
#SBATCH --mem=10GB  #this is memory per node, total memory requested=40GB
#SBATCH --account=<slurm_account_name>

module reset
module load Simcenter_Nastran/2606

HOSTLIST=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | tr '\n' ':' | sed 's/:$//')
echo "Using hosts for DMP: $HOSTLIST"

nastran cantilever_plate.dat batch=no dmp=$SLURM_NTASKS smp=$SLURM_CPUS_PER_TASK hosts=$HOSTLIST authorize=<port@license_server>
