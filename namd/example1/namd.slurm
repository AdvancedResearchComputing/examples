#! /bin/bash
#SBATCH --job-name=namd
#SBATCH --account=<slurm_account_name>
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH -t 1:00:00


# Reset modules and load NAMD
module reset
module load NAMD/3.0.3-foss-2025b-mpi

echo "NAMD: Normal beginning of execution."

#  We need the following files in this directory:
#
#    par_all27_prot_lipid.inp
#    ubq_wb.pdb
#    ubq_wb.psf
#    ubq_wb_eq.conf

# Conv-host for MPI:
#  Translates +pN-style conv-host options into
# mpirun -npN options.

charmrun namd3 +p$SLURM_NTASKS ubq_wb_eq.conf

if [ $? -ne 0 ]; then
  echo "NAMD: Run error."
  exit 1
fi

echo "NAMD: Normal end of execution."
exit 0

