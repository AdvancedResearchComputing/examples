#!/bin/bash

#SBATCH --job-name dalton_nompi
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=2
#SBATCH --mem=2GB
#SBATCH --time=00:10:00
#SBATCH --account=personal

#load modules
module reset
module load Dalton

# Setting the variables:
daltoninp=cc2dc_energy.dal
daltonmol=cc2dc_energy.mol

#Use local scratch for temporary directory
export DALTON_TMPDIR=$TMPDIR

echo "$(date): Starting run"

echo "Running the example: INPUT=${daltoninp} - Molecule=${daltonmol}"

dalton -omp ${SLURM_NTASKS}  -dal ${daltoninp}  -mol ${daltonmol}

echo "$(date): Program finished with exit code $?"
