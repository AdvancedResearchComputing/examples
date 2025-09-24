#! /bin/bash
#
#SBATCH --job-name pytorch_gpu
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres gpu:1
#SBATCH --partition=a100_normal_q
#SBATCH --qos=tc_a100_normal_base #Use qos command to specify scheduling priority
#SBATCH --account=personal
#

#Load modules
module reset
module load Miniconda3
source activate pytorch

nvidia-smi --query-gpu=timestamp,name,pci.bus_id,temperature.gpu,utilization.gpu,utilization.memory,memory.used --format=csv -lms 1000 > gpu_tc.txt &

#Run beginner tutorial
echo "PyTorch: Normal beginning of execution."
python cifar10_gpu.py >> cifar10_gpu.out
echo "PyTorch: Normal end of execution."
