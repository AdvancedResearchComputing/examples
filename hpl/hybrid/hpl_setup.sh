#!/bin/bash
#Bash script to customize the HPL input file (HPL.dat) for a given number of cores and amount of memory.
#See https://github.com/krometis/HPLSetup

defgbpercore=4 #default memory/core
defpctmem=85   #default percent memory
defnb=160      #default block size

original_args="$@";
unset hplnp
unset hplnb
unset hpln
unset hplp
unset hplq
unset hplgbpercore
unset hplpctmem

function usage {
    echo "Script to set N, NB, P, and Q in HPL.dat given a number of cores and target percent memory"
    echo "usage: `basename $0` [-np procs] [-pm % memory to use] [-m gb/core] [-nb blocksize] [-n hpl n parameter] [-p hpl p parameter] [-q hpl q parameter]"
    echo "  -np     number of processors (default: use SLURM_NTASKS or PBS_NP)"
    echo "  -pm     percent memory to use (default: $defpctmem, roughly maximum performance)"
    echo "  -m      system memory per core in GB (default: $defgbpercore)"
    echo "  -nb     HPL block size (NB parameter) (default: $defnb)"
    echo "  -n      HPL problem size (N parameter) (default: compute to fit target percent memory)"
    echo "  -p      HPL P parameter (PxQ = number of processes) (default: compute from number of processes np)"
    echo "  -q      HPL Q parameter (PxQ = number of processes) (default: np/p)"
    exit 1
}

while (( $# )); do
  case "$1" in
    -u )
      usage;
      exit 0
    ;;
    -np )
      hplnp="$2";
      shift 2
    ;;
    -nb )
      hplnb="$2";
      shift 2
    ;;
    -n )
      hpln="$2";
      shift 2
    ;;
    -p )
      hplp="$2";
      shift 2
    ;;
    -q )
      hplq="$2";
      shift 2
    ;;
    -m )
      hplgbpercore="$2";
      shift 2
    ;;
    -pm )
      hplpctmem="$2";
      shift 2
    ;;
    * ) break ;;
  esac
done


# NUMBER OF PROCESSES #
# If the number of processes is not provided, default to the number of Slurm or PBS processes
if [[ -z "$hplnp" ]]; then
  if [[ ! -z $SLURM_NTASKS ]]; then 
    hplnp=$SLURM_NTASKS
    echo "Number of MPI processes (-np) not specified. Using $hplnp from SLURM_NTASKS."
  elif [[ ! -z $PBS_NP ]]; then 
    hplnp=$PBS_NP
    echo "Number of MPI processes (-np) not specified. Using $hplnp from PBS_NP."
  
  # If we still don't have a number of processes, error out
  else
    echo "Error: Number of MPI processes (-np) not specified and SLURM_NTASKS and PBS_NP are empty. Exiting..."
    exit 1
  fi
fi


# BLOCK SIZE (NB) #
## Define some HPL parameters if they're not defined already (will be inserted into HPL.dat)
#if hplnb is not defined, use a default
[[ -z "$hplnb" ]] && hplnb=$defnb && echo "Block size (-nb) not provided. Using default value of $hplnb."


# MATRIX SIZE (N) #
#if hpln is not defined, try to pick a good one
if [[ -z "$hpln" ]]; then
  #memory in GB per core (used to set problem size)
  [[ -z "$hplgbpercore" ]] && hplgbpercore=$defgbpercore && echo "Memory per core (-m) not specified. Assuming $hplgbpercore GB/core."  
  #percent of memory we want HPL to use
  [[ -z "$hplpctmem" ]] && hplpctmem=$defpctmem && echo "Percent memory (-pm) not specified. Assuming 85% for (roughly) maximum performance. However, the run may take quite some time to complete." 

  #formula is: sqrt(bytes of memory available across all nodes * some percentage) but a multiple of $hplnb
  hpln=$( echo "sqrt( $hplnp * $hplgbpercore * $hplpctmem * 0.01 * 0.125 )*32*1024 / $hplnb * $hplnb" | bc )
  echo "HPL problem size (-n) not specified. Using calculated value of $hpln ($hplgbpercore gb/core, hplpctmem=$hplpctmem)."
fi


# PROCESS LAYOUT (P,Q) #
#if hplp is not defined, calculate the best one
if [[ -z "$hplp" ]]; then
  hplp=$( echo "sqrt( $hplnp )" | bc )
  while [ $(( $hplp * $(( $hplnp / $hplp )) )) -ne $hplnp ]; do 
    hplp=$[hplp-1]
  done
  echo "P parameter (-p) not specified. Using calculated value of $hplp."
fi
#if hplq is not defined, calculate from hplp and number of processes
[[ -z "$hplq" ]] && hplq=$(( $hplnp / $hplp )) && echo "Q parameter (-q) not specified. Using calculated value of $hplq."


# MAKE CHANGES TO HPL.dat #
echo "Making the following changes to HPL.dat:"
echo " N = $hpln"
echo "NB = $hplnb"
echo " P = $hplp"
echo " Q = $hplq"
sed -i "6s/.*/$hpln        Ns/" HPL.dat
sed -i "8s/.*/$hplnb           NBs/" HPL.dat
sed -i "11s/.*/$hplp            Ps/" HPL.dat
sed -i "12s/.*/$hplq            Qs/" HPL.dat

echo "HPL setup complete."
