#! /bin/bash
#
#SBATCH -t 00:10:00
#SBATCH -N1 --ntasks-per-node=1
#SBATCH --gres gpu:1
#SBATCH -p t4_dev_q
#

#Load modules
module reset
module load TensorFlow

#Run beginner tutorial
echo "TENSORFLOW_INFER_T4: Normal beginning of execution."
python beginner.py
echo "TENSORFLOW_INFER_T4: Normal end of execution."
