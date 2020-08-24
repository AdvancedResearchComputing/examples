#! /bin/bash
#
#SBATCH -N1 --ntasks-per-node=32
#SBATCH -t 00:30:00
#SBATCH -p dev_q
#

#
module reset
module load NAMD
#
echo "NAMD_TINKERCLIFFS ROME: Normal beginning of execution."
#
#  We need the following files in this directory:
#
#    par_all27_prot_lipid.inp
#    ubq_wb.pdb
#    ubq_wb.psf
#    ubq_wb_eq.conf
#
ls -la
#
#  Run the program with $SLURM_NTASKS MPI processes.
#
# charmrun runs srun -c 2 for some reason. seems like it's 
# better to just call srun directly
#charmrun namd2 +p$SLURM_NTASKS ubq_wb_eq.conf > namd_tinkercliffs_rome.txt
srun namd2 ./ubq_wb_eq.conf > namd_tinkercliffs_rome.txt
if [ $? -ne 0 ]; then
  echo "NAMD_TINKERCLIFFS ROME: Run error."
  exit 1
fi
#
echo "NAMD_TINKERCLIFFS ROME: Normal end of execution."
exit 0
