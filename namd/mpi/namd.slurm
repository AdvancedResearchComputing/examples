#! /bin/bash
#SBATCH --job-name=namd
#SBATCH --account=<slurm_account_name>
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH -t 1:00:00


# Reset modules and load NAMD
module reset
module load NAMD/3.0.3-foss-2025b-mpi

echo "NAMD: Normal beginning of execution."

# Conv-host for MPI:
#  Translates +pN-style conv-host options into

# Can use charmrun, which submits mpirun
#charmrun namd3 +p$SLURM_NTASKS tiny.namd

# Or you can use mpirun directly
mpirun -np $SLURM_NTASKS tiny.namd

if [ $? -ne 0 ]; then
  echo "NAMD: Run error."
  exit 1
fi

echo "NAMD: Normal end of execution."
exit 0

