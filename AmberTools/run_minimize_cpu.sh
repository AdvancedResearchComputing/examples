#!/bin/bash
#SBATCH --account=personal
#SBATCH --job-name=amber_cpu_test
#SBATCH --output=amber_cpu_test.out
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --time=00:10:00
#SBATCH --partition=normal_q

module reset
module load AmberTools

sander -O -i min.in -o min.out -p test.prmtop -c test.inpcrd -r min.rst
