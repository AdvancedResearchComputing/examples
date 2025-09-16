#!/bin/bash
#SBATCH -A <Slurm Account>
#SBATCH -p v100_normal_q
#SBATCH --nodes=2
#SBATCH --gres=gpu:2
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=4

echo "date: `date`"
echo "hostname: $HOSTNAME"; echo
echo -e "\nChecking job details for CPU and GPU IDs..."
scontrol show job --details $SLURM_JOB_ID

# Iterate over integer parameters from 01-20
# Parameter passed as input argument. "{}" becomes "$1" inside the par_gpu_driver.sh script
# Up to four concurrent tasks (2 nodes x 2 tasks-per-node)
# One Slurm task (srun --ntasks=1) per parameter
# Bind 1 GPU and 4 CPUs to each task exclusively
seq -w 20 | parallel -j $SLURM_NTASKS srun --ntasks=1 --nodes=1 --cpus-per-task=$SLURM_CPUS_PER_TASK --gres=gpu:1  bash par_gpu_driver.sh {} 
