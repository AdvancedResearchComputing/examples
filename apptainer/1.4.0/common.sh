#!/bin/bash
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --output=output.log
#SBATCH --time=0-00:30:00

module load apptainer
CTNR=/common/containers/cp2k_latest.sif
apptainer run $CTNR cp2k -i H2O_GW100_def2-QZVP.inp
