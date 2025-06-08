#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4       
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --time=00:15:00
#
module reset
module load VASP
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
mpirun -np 4 /bin/bash -c "ulimit -s unlimited; vasp_std"
if [ $? -ne 0 ]; then
  echo "VASP_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
echo "VASP_TINKERCLIFFS ROME: Normal end of execution."
exit 0
