#!/bin/bash
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --output=output.log
#SBATCH --time=0-00:30:00


module load OpenFOAM/v2406-foss-2023a

# source provided bash script to find executables
# FOAM_BASH is defined upon loading module
. $FOAM_BASH

# Copy example from official tutorial
# Reference: https://southernmethodistuniversity.github.io/hpc_docs/examples/openfoam/index.html
my_example="pitzDaily"
# Remove if already exists
[[ -d $my_example ]] && rm -Rf $my_example
# Example subdirectory (e.g. incompressible simple example)
my_tutorial="tutorials/incompressible/simpleFoam/$my_example"
# Copy to working directory
cp -r $EBROOTOPENFOAM/OpenFOAM-v2406/$my_tutorial .
# Copy dictionaries for parallel execution
# Reference: https://develop.openfoam.com/Development/openfoam/-/blob/master/tutorials/incompressible/simpleFoam/pitzDaily/system/blockMeshDict
# Reference: https://openfoamwiki.net/index.php/DecomposePar
cp /home/$USER/MyTests/OpenFOAM-v2406/blockMeshDict $my_example/system/blockMeshDict
cp /home/$USER/MyTests/OpenFOAM-v2406/decomposeParDict $my_example/system/decomposeParDict

cd $my_example

# run the example
blockMesh
decomposePar
mpirun -np 4 simpleFoam -parallel 
reconstructPar -verbose
