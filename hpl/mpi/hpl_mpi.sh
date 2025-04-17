#!/bin/bash
#Run HPL with 1 Slurm task per core
#Examples run with one MPI process per core
#Commented section at the bottom shows how to run MPI+OpenMPI in this setup
#although the examples in the hybrid directory show how to better do this in Slurm

#Adjust runtime and number of nodes as needed
#Doubling nodes increases runtime by ~sqrt(2)
#SBATCH -t 2:00:00
#SBATCH -N 1

#SBATCH --ntasks-per-node=128
#SBATCH -p normal_q

#setup run directory so that jobs running at the same time don't collide
rundir=runs/$SLURM_JOBID
mkdir -p $rundir
cp HPL.dat hpl_setup.sh $rundir/
cd $rundir

#print some key variables
env | egrep "SLURM_NNODES|SLURM_NTASKS|SLURM_CPUS_PER_TASK"
echo "job is running on:"
scontrol show hostnames $SLURM_NODELIST

#variables
[[ ! -z $SLURM_NTASKS ]] && hplnp=$SLURM_NTASKS || hplnp=128
hplnb=244    #block size
pctmem=80    #% of memory (max performance but long runtime for ~85)
gbpercore=2  #gb ram per core


#### MPI-ONLY (1 mpi process per core) ####

#setup HPL.dat
./hpl_setup.sh -np $hplnp -nb $hplnb -pm $pctmem -m $gbpercore

#1 thread per MPI process
export OMP_NUM_THREADS=1

#intel
module reset; module load hpl/2.3-intel-2024a
# echo "LOG: intel | mpi-only | launch with mpirun"
# mpirun -np $hplnp xhpl
echo "LOG: intel | mpi-only | launch with mpirun (map & bind to core)"
mpirun -np $hplnp -genv I_MPI_PIN_PROCESSOR_LIST=0-127 xhpl
# echo "LOG: intel | mpi-only | launch with srun"
# srun -n $hplnp xhpl
echo "LOG: intel | mpi-only | launch with srun (bind to cores)"
srun -n $hplnp --cpu-bind=cores xhpl

#gcc
module reset; module load hpl/2.3-foss-2024a
# echo "LOG: gcc   | mpi-only | launch with mpirun"
# mpirun -np $hplnp -x OMP_NUM_THREADS=1 xhpl
# echo "LOG: gcc   | mpi-only | launch with mpirun (bind to core)"
# mpirun -np $hplnp --bind-to core -x OMP_NUM_THREADS=1 xhpl
echo "LOG: gcc   | mpi-only | launch with mpirun (map & bind to core)"
mpirun -np $hplnp --map-by core --bind-to core -x OMP_NUM_THREADS=1 xhpl
# echo "LOG: gcc   | mpi-only | launch with srun"
# srun -n $hplnp xhpl
echo "LOG: gcc   | mpi-only | launch with srun (bind to cores)"
srun -n $hplnp --cpu-bind=cores xhpl


# #### HYBRID (MPI+OPENMP, 1 mpi process/l3 cache) ####
# 
# #setup HPL.dat
# export OMP_NUM_THREADS=4
# np=$(( $hplnp / $OMP_NUM_THREADS )) #e.g., 128/4=32
# ./hpl_setup.sh -np $np -nb $hplnb -pm $pctmem -m $(( $OMP_NUM_THREADS*$gbpercore ))
# 
# #get cpu mask for groups of 4 cores
# mask=""; imask="0xF"
# for i in $( seq 32 ); do 
#   mask="${mask}${imask},"
#   imask="${imask}0"
# done
# mask=$( echo $mask | sed 's/,$//' )
# echo "cpu mask is: $mask"
# 
# #intel
# module reset; module unload gcc; module load HPL/2.3-intel-2019b
# export OMP_PROC_BIND=TRUE
# export OMP_PLACES=cores
# echo "LOG: intel | mpi+omp  | launch with mpirun"
# #the -ppn and -hosts flags can be omitted if job is started with --ntasks-per-node=32 --cpus-per-task=4
# hosts=$( scontrol show hostnames $SLURM_NODELIST | paste -s -d, )
# mpirun -n $np -ppn 32 -hosts=$hosts -genv I_MPI_PIN_DOMAIN=omp -genv I_MPI_PIN_PROCESSOR_LIST="$( seq -s , 0 4 127 )" -genv OMP_NUM_THREADS=4 -genv OMP_PROC_BIND=TRUE -genv OMP_PLACES=cores xhpl
# echo "LOG: intel | mpi+omp  | launch with srun"
# srun -n $np --cpu-bind=mask_cpu=$mask xhpl
# 
# #gcc
# module reset; module unload gcc; module load HPL/2.3-foss-2020a
# #these break openblas for some reason - make sure they're unset
# unset OMP_PROC_BIND; unset OMP_PLACES
# echo "LOG: gcc   | mpi+omp  | launch with mpirun"
# mpirun -np $np --map-by ppr:1:L3cache --bind-to l3cache -x OMP_NUM_THREADS=4 xhpl
# echo "LOG: gcc   | mpi+omp  | launch with srun"
# srun -n $np --cpu-bind=mask_cpu=$mask xhpl

