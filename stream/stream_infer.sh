#!/bin/bash
#Run the Stream memory bandwidth benchmark (https://www.cs.virginia.edu/stream/)

#SBATCH -t 0:05:00
#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -p t4_dev_q

arrsize="1500M" #array size

module reset
module load intel

#set some variables
exename="stream.$arrsize"
arrsizefull="$( echo $arrsize | sed 's/M/000000/' )"
icc -o $exename stream.c -DSTATIC -DNTIMES=10 -DSTREAM_ARRAY_SIZE=$arrsizefull \
  -mcmodel=large -shared-intel -Ofast -qopenmp -ffreestanding -qopt-streaming-stores always

#run
export OMP_PROC_BIND=true
export OMP_NUM_THREADS=32
#export OMP_PLACES="$( seq -s },{ 0 4 127 | sed -e 's/\(.*\)/\{\1\}/' )"
echo "running stream benchmark on host $( hostname ) with $OMP_NUM_THREADS threads..."
echo "using $arrsize array size..."
module list
./$exename

