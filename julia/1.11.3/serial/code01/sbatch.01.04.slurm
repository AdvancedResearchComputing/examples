#!/bin/bash

#SBATCH -J juliaserial


## Wall time.
#SBATCH --time=0-00:10:00 

## Account to "charge" to/run against.
#SBATCH --account=arcadm

## Partition/queue.
## #SBATCH --partition=normal_q
#SBATCH --partition=dev_q
## #SBATCH --partition=largemem_q
## #SBATCH --partition=l40s_normal_q

### This requests 1 node, 1 core. 1 gpu.
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1 
## #SBATCH --gres=gpu:1


## Reservation.
#SBATCH --reservation=HPCMaintTesting 

## Use the compute node only for this job, and use all memory on this node.
## #SBATCH --exclusive
## #SBATCH --mem=500G

## Slurm output and error files.
#SBATCH -o slurm.julia.01.serial.%j.out
#SBATCH -e slurm.julia.01.serial.%j.err


## Load modules, if any.
module reset
module load Julia/1.11.3-linux-x86_64

## Load virtual environments, if any.
## source activate ~/env/falcon/l40s_normal_q/py312_osu_gpu_timing

# Set up 

## Get the core number for job and other job details.
echo " ------------"
echo "Set of cores job running on: "
echo " "
scontrol show job -d  $SLURM_JOB_ID
echo " "
echo " "

## Monitor the GPU, if any.
echo " "
echo " "
## echo "Start file and monitoring of GPU."
## nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv -l 3 > $SLURM_JOBID.gpu.log &
echo " " 
echo " " 

echo " " 
echo " ------------"
echo "Running IOSTAT"

iostat 2 >iostat-stdout.txt 2>iostat-stderr.txt &

echo " ------------"
echo "Running MPSTAT"

mpstat -P ALL 2 >mpstat-stdout.txt 2>mpstat-stderr.txt &

echo " ------------"
echo "Running VMSTAT"

vmstat 2 >vmstat-stdout.txt 2>vmstat-stderr.txt &

echo " ------------"
echo "Running executable"

# Code to execute.
sh ./run.01.04

echo " ------------"
echo "Executable done"

echo " ------------"
echo "Killing IOSTAT"
kill %1

echo " ------------"
echo "Killing MPSTAT"
kill %2

echo " ------------"
echo "Killing VMSTAT"
kill %3

