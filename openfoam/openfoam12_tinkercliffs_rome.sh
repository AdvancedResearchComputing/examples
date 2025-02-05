#! /bin/bash

#SBATCH --nodes=1 
#SBATCH --ntasks=4
#SBATCH -p normal_q

#SBATCH -A personal
#SBATCH -J test_foam
#SBATCH -o ./job_outputs/slurm-%j-%x.out

module load OpenFOAM/12-foss-2023a

# source provided bash script to find executables
# FOAM_BASH is defined upon loading module
. $FOAM_BASH

# Copy example from official tutorial
# Reference: https://southernmethodistuniversity.github.io/hpc_docs/examples/openfoam/index.html
my_example="pitzDaily"
# Remove if already exists
[[ -d $my_example ]] && rm -Rf $my_example
# Example subdirectory (e.g. incompressible simple example)
my_tutorial="tutorials/incompressibleFluid/$my_example"
# Copy to working directory
cp -r $EBROOTOPENFOAM/OpenFOAM-12/$my_tutorial .
# Copy dictionaries for parallel execution
# Reference: https://develop.openfoam.com/Development/openfoam/-/blob/master/tutorials/incompressible/simpleFoam/pitzDaily/system/blockMeshDict
# Reference: https://openfoamwiki.net/index.php/DecomposePar
cp /home/$USER/MyTests/foam12/blockMeshDict $my_example/system/blockMeshDict
cp /home/$USER/MyTests/foam12/decomposeParDict $my_example/system/decomposeParDict


cd $my_example

# run the example
blockMesh
decomposePar
mpirun -np $SLURM_NTASKS foamRun -solver incompressibleFluid -parallel
