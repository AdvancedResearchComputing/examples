#! /bin/bash
#SBATCH --job-name=namd
#SBATCH --account=<slurm_account_name>
#SBATCH --partition=v100_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gpus=1
#SBATCH --cpus-per-task=8
#SBATCH -t 1:00:00


# Reset modules and load NAMD
module reset
module load NAMD/3.0.3-foss-2025a-CUDA-12.8.0-multicore

echo "NAMD: Normal beginning of execution."

# Per NAMD 3.0.3 release notes: For best performance use the new +auto-provision option,
# which will automatically run one thread per processor:
namd3 +setcpuaffinity tiny.namd

#To run with multiple GPUS:
#Example: 2 GPUS, with 8 PEs per non-PME device, +p is set to 15 = 1*8 + 7 (total number of cores)
#namd3 +p16 +pmepes 8 +setcpuaffinity tiny.namd

#Example:4 GPUs, with 8 PEs per non-PME device, +p is set to 29 = 3*8 + 5
#namd3 +p29 +pmepes 5 +setcpuaffinity tiny.namd


if [ $? -ne 0 ]; then
  echo "NAMD: Run error."
  exit 1
fi

echo "NAMD: Normal end of execution."
exit 0

