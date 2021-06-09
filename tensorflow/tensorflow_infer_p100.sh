#! /bin/bash
#
#SBATCH -t 00:10:00
#SBATCH -N1 --ntasks-per-node=1
#SBATCH --gres gpu:1
#SBATCH -p p100_dev_q
#

#Load modules
module reset
module load TensorFlow

#Run beginner tutorial
echo "TENSORFLOW_INFER_P100: Normal beginning of execution."
python beginner.py
echo "TENSORFLOW_INFER_P100: Normal end of execution."
