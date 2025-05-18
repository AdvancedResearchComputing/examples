#! /bin/bash
#SBATCH -N1 --ntasks-per-node=32
#SBATCH -t 00:30:00
#SBATCH --account=personal
#SBATCH -p normal_q


# Reset modules and load NAMD
module reset
module load NAMD/3.0

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

