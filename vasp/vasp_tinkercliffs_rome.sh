#! /bin/bash
#
#SBATCH -t 5:00
#SBATCH -n 4
#SBATCH -p dev_q
#
module reset
module load VASP/5.4.4-intel-2019b
module list
#
echo "VASP_TINKERCLIFFS ROME: Normal beginning of execution."
#
#  Instead of the command
#
#  mpirun -np 4 vasp
#
#  we use the following command, which sets the stacksize to "unlimited":
#
#mpirun -np 4 /bin/bash -c "ulimit -s unlimited; vasp_std"
srun -n 4 /bin/bash -c "ulimit -s unlimited; vasp_std"
if [ $? -ne 0 ]; then
  echo "VASP_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
echo "VASP_TINKERCLIFFS ROME: Normal end of execution."
exit 0

