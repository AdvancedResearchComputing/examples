#! /bin/bash
#
#SBATCH --job-name tensorflow_ex
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=normal_q
#SBATCH --mem=2GB
#SBATCH --account=personal
#

#Load modules
module reset
module load TensorFlow

#Run beginner tutorial
echo "TENSORFLOW: Normal beginning of execution."
python beginner.py >> beginner.out
echo "TENSORFLOW: Normal end of execution."
