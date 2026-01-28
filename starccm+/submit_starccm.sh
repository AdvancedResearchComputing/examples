#!/bin/bash
#SBATCH -t 0-1:00:00
#SBATCH -N 1  #Number of nodes
#SBATCH --ntasks-per-node=4
#SBATCH --partition=normal_q
#SBATCH --account=personal

module reset
module load STAR-CCM+/18.02.008


MACHINEFILE=./machilefile.$SLURM_JOBID
scontrol show hostname $SLURM_NODELIST > $MACHINEFILE
SIMFILEPATH=./simple_airfoil_flow.sim
starccm+ -power \
-podkey <your license key> \
-licpath <FlexNet license server> \
-batch run_sim.java \
-np $SLURM_NTASKS -machinefile $MACHINEFILE \
$SIMFILEPATH

