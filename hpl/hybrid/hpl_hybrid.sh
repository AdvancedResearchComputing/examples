#!/bin/bash
#Run HPL in hybrid MPI+OpenMP model

#Adjust runtime and number of nodes as needed
#Doubling nodes increases runtime by ~sqrt(2)
#SBATCH -t 2:00:00
#SBATCH -N 1

#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=4
#SBATCH -p normal_q

#variables
hplnb=244    #block size
pctmem=85    #% of memory (max performance but long runtime for ~85)
gbpercore=2  #gb ram per core

#setup run directory so that jobs running at the same time don't collide
rundir=runs/$SLURM_JOBID
mkdir -p $rundir
cp HPL.dat hpl_setup.sh $rundir/
cd $rundir

#print some key variables
env | egrep "SLURM_NNODES|SLURM_NTASKS|SLURM_CPUS_PER_TASK"
echo "job is running on:"
scontrol show hostnames $SLURM_NODELIST

#### HYBRID (MPI+OPENMP, 1 mpi process/l3 cache) ####

#setup HPL.dat
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
np=$SLURM_NTASKS
./hpl_setup.sh -np $np -nb $hplnb -pm $pctmem -m $(( $OMP_NUM_THREADS*$gbpercore ))

#get cpu mask for groups of 4 cores
mask=""; imask="0xF"
for i in $( seq 32 ); do 
  mask="${mask}${imask},"
  imask="${imask}0"
done
mask=$( echo $mask | sed 's/,$//' )
echo "cpu mask is: $mask"

#intel
module reset; module unload gcc; module load HPL/2.3-intel-2024a
echo "LOG: intel | mpi+omp  | launch with mpirun"
mpirun -n $np -genv I_MPI_PIN_PROCESSOR_LIST="$( seq -s , 0 4 127 )" -genv I_MPI_PIN_DOMAIN=omp -genv OMP_NUM_THREADS=4 -genv OMP_PROC_BIND=TRUE -genv OMP_PLACES=cores xhpl
echo "LOG: intel | mpi+omp  | launch with srun"
srun -n $np --cpu-bind=mask_cpu=$mask xhpl

#gcc
module reset; module unload gcc; module load HPL/2.3-foss-2024a
#these break openblas for some reason - make sure they're unset
unset OMP_PROC_BIND; unset OMP_PLACES
echo "LOG: gcc   | mpi+omp  | launch with mpirun"
mpirun -np $np --map-by ppr:1:L3cache --bind-to l3cache -x OMP_NUM_THREADS=4 xhpl
echo "LOG: gcc   | mpi+omp  | launch with srun"
srun -n $np --cpu-bind=mask_cpu=$mask xhpl

