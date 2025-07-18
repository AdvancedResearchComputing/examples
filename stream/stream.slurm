#!/bin/bash
#Run the Stream memory bandwidth benchmark (https://www.cs.virginia.edu/stream/)


#SBATCH --job-name=stream_example
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --time=0-0:05:00
#SBATCH --exclusive
##SBATCH --account=personal
#SBATCH --account=arcadm

arrsize="1500M" #array size
#arrsize="2500M" #array size

module reset
module load intel

#set some variables
exename="stream.$arrsize"
arrsizefull="$( echo $arrsize | sed 's/M/000000/' )"
icx -o $exename stream.c -DSTATIC -DNTIMES=10 -DSTREAM_ARRAY_SIZE=$arrsizefull \
  -mcmodel=large -shared-intel -Ofast -qopenmp -ffreestanding -qopt-streaming-stores always

#icc -o $exename stream.c -DSTATIC -DNTIMES=10 -DSTREAM_ARRAY_SIZE=$arrsizefull \
#  -mcmodel=large -shared-intel -Ofast -qopenmp -ffreestanding -qopt-streaming-stores always

#run
export OMP_PROC_BIND=true
#export OMP_NUM_THREADS=32 #Tinkercliffs (Cores per Node/4)
export OMP_NUM_THREADS=24 #Owl
#export OMP_NUM_THREADS=16 #Falcon
export OMP_PLACES="$( seq -s },{ 0 4 127 | sed -e 's/\(.*\)/\{\1\}/' )"
echo "running stream benchmark on host $( hostname ) with $OMP_NUM_THREADS threads..."
echo "using $arrsize array size..."
module list
./$exename

