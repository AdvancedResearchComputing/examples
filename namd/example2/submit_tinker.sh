#! /bin/bash
#SBATCH --job-name=namd
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH -t 1:00:00


# Reset modules and load NAMD
module reset
module load NAMD

echo "NAMD_TINKERCLIFFS ROME: Normal beginning of execution."

# List files in current directory
ls -la

srun namd3 ./tiny.namd > tiny.txt
if [ $? -ne 0 ]; then
  echo "NAMD_TINKERCLIFFS ROME: Run error."
  exit 1
fi

echo "NAMD_TINKERCLIFFS ROME: Normal end of execution."
exit 0

