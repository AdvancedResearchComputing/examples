#! /bin/bash
#
#SBATCH --job-name pytorch_cpu
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=normal_q
#SBATCH --account=personal
#

#Load modules
module reset
module load Miniconda3
source activate pytorch_cpu

#Run beginner tutorial
echo "PyTorch: Normal beginning of execution."
python cifar10.py >> cifar10.out
echo "PyTorch: Normal end of execution."
