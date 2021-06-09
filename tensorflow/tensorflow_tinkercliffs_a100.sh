#! /bin/bash
#
#SBATCH -t 00:10:00
#SBATCH -N1 --ntasks-per-node=1
#SBATCH --gres gpu:1
#SBATCH -p a100_dev_q
#

#Load modules
module reset
module load cuda11.2/toolkit #hopefully will be added to defaults soon
module load TensorFlow

#Run beginner tutorial
echo "TENSORFLOW_TINKERCLIFFS_A100: Normal beginning of execution."
python beginner.py
echo "TENSORFLOW_TINKERCLIFFS_A100: Normal end of execution."
