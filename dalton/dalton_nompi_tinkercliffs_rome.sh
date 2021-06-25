#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time=00:30:00

#load modules
module reset
module load Dalton/2020-iomkl-2019b-nompi

# Setting the variables:
daltoninp=cc2dc_energy.dal
daltonmol=cc2dc_energy.mol

#Use local scratch for temporary directory
export DALTON_TMPDIR=$TMPDIR

echo "$(date): Starting run"

echo "Running the example: INPUT=${daltoninp} - Molecule=${daltonmol}"

dalton -omp ${SLURM_NTASKS}  -dal ${daltoninp}  -mol ${daltonmol}

echo "$(date): Program finished with exit code $?"
