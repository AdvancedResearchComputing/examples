#!/bin/bash
#SBATCH --time=1:00:00                        #1 hour job
#SBATCH --nodes=1                            #Number of nodes
#SBATCH --ntasks-per-node=4                  #Number of tasks per node
#SBATCH --partition=normal_q                 #Partition
#SBATCH --account=<slurm_account_name>      #Account name for compute allocation

module reset
module load STAR-CCM+/18.02.008

scontrol show hostnames $SLURM_JOB_NODELIST > machinefile.$SLURM_JOB_ID

starccm+ -power -licpath 1999@starccm.software.vt.edu -batch run_sim.java -np $SLURM_NTASKS -machinefile machinefile.$SLURM_JOB_ID simple_airfoil_flow.sim

