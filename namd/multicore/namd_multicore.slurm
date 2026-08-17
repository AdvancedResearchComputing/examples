#! /bin/bash
#SBATCH --job-name=namd
#SBATCH --account=<slurm_account_name>
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH -t 1:00:00


# Reset modules and load NAMD
module reset
module load NAMD/3.0.3-foss-2025b-multicore

echo "NAMD: Normal beginning of execution."

# Per NAMD 3.0.3 release notes: For best performance use the new +auto-provision option,
# which will automatically run one thread per processor:
namd3 +auto-provision tiny.namd

# OR you can manually set N to be the number of total cores
#namd3 +pN tiny.namd

if [ $? -ne 0 ]; then
  echo "NAMD: Run error."
  exit 1
fi

echo "NAMD: Normal end of execution."
exit 0

