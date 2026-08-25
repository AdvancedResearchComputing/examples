#!/bin/bash
#SBATCH --time=1:00:00                        #1 hour job
#SBATCH --nodes=1                            #Number of nodes
#SBATCH --ntasks-per-node=2                  #Number of tasks per node
#SBATCH --partition=normal_q                 #Partition
#SBATCH --account=<slurm_account_name>      #Account name for compute allocation

module reset
module load STAR-CCM+/21.02.008-r8

scontrol show job -d $SLURM_JOB_ID

# Single node jobs:
starccm+ -licpath 1999@starccm.software.vt.edu -batch -np $SLURM_NTASKS simple_airfoil_flow.sim

# Multi-node jobs (machine file required), uncomment both lines below:
#scontrol show hostnames $SLURM_JOB_NODELIST > machinefile.$SLURM_JOB_ID
#starccm+ -licpath 1999@starccm.software.vt.edu -batch -np $SLURM_NTASKS -machinefile machinefile.$SLURM_JOB_ID simple_airfoil_flow.sim

