#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=32 --gres=gpu:1
#SBATCH -p t4_dev_q
#

#
module reset
module load CUDA/11.1.1-GCC-10.2.0
#
echo "CUDA BANDWIDTH_INFER: Normal beginning of execution."
#
#  Discard the previous output file, if any.
#
if [ -e cuda_bandwidth_infer.txt ]; then
  rm cuda_bandwidth_infer.txt
fi

#Run CUDA's bandwidth test
$EBROOTCUDA/extras/demo_suite/bandwidthTest --memory=pinned --mode=quick --dtoh | tee cuda_bandwidth_infer.txt
if [ $? -ne 0 ]; then
  echo "CUDA BANDWIDTH_INFER: Run error!"
  exit 1
fi
#
#  Terminate.
#
echo "CUDA BANDWIDTH_INFER: Normal end of execution."
exit 0
