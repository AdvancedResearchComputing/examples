#! /bin/bash
#
#SBATCH --job-name tensorflow_ex
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres gpu:1
#SBATCH --partition=a100_normal_q
#SBATCH --account=personal
#

#Load modules
module reset
module load CUDA
module load TensorFlow

#Run beginner tutorial
echo "TENSORFLOW_A100: Normal beginning of execution."
python beginner.py >> beginner.out
echo "TENSORFLOW_A100: Normal end of execution."
