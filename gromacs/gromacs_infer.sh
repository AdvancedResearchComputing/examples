#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=32 --gres=gpu:1
#SBATCH -p t4_dev_q
#

#
module reset
module load GROMACS/2020.4-fosscuda-2020b
#
echo "GROMACS_INFER: Normal beginning of execution."
#
#  Discard the previous output file, if any.
#
if [ -e gromacs_infer.txt ]; then
  rm gromacs_infer.txt
fi
#
#  Our primary input data is 1aki.pdb.
#  For certain commands, we must access auxilliary *.mdp files of parameters.
#  Because this is not an interactive run, occasional interactive input
#  is supplied by *input.txt files.
#  All the output goes into a single file "gromacs_infer.txt".
#
#  pdb2gmx reads the pdb file, and generates:
#  * the topology of the molecule (topol.top);
#  * a position restraint file (posre.itp);
#  * a post-processed structure file (1aki_processed.gro).
#
gmx pdb2gmx -f 1aki.pdb -o 1aki_processed.gro -water spce < pdb2gmx_input.txt &> gromacs_infer.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_INFER: Run error!"
  exit 1
fi
#
#  editconf defines the box dimensions.
#  We choose centering, place the protein at least 1 nm from the box edge,
#  and use a cubic box.
#
gmx editconf -f 1aki_processed.gro -o 1aki_newbox.gro -c -d 1.0 -bt cubic &>> gromacs_infer.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_INFER: Run error!"
  exit 1
fi
#
#  solvate fills the box with water.
#
gmx solvate -cp 1aki_newbox.gro -cs spc216.gro -o 1aki_solv.gro -p topol.top &>> gromacs_infer.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_INFER: Run error!"
  exit 1
fi
#
#  grommp prepares for the replacement of water by ions.
#  Create a tpr file to specify how to replace water molecules with specified ions.
#  We need an additional parameter file, ion.mdp.
#
gmx grompp -maxwarn 10 -f ions.mdp -c 1aki_solv.gro -p topol.top -o ions.tpr &>> gromacs_infer.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_INFER: Run error!"
  exit 1
fi
#
#  genion carries out the replacement of water by ions.
#
gmx genion -s ions.tpr -o 1aki_solv_ions.gro -p topol.top -pname NA -nname CL -nn 8 < genion_input.txt &>> gromacs_infer.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_INFER: Run error!"
  exit 1
fi
#
#  grompp assembles the structure, topology and simulation parameters
#  into a binary file in preparation to relax the structure through
#  energy minimization.
#  We need an additional parameter file, minim.mdp.
#
gmx grompp -f minim.mdp -c 1aki_solv_ions.gro -p topol.top -o em.tpr &>> gromacs_infer.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_INFER: Run error!"
  exit 1
fi
#
#  mdrun carries out the energy minimization.
#
gmx mdrun -v -deffnm em &>> gromacs_infer.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_INFER: Run error!"
  exit 1
fi
#
#  energy analyzes the energy terms in em.edr
#
gmx energy -f em.edr -o potential.xvg < energy_input1.txt &>> gromacs_infer.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_INFER: Run error!"
  exit 1
fi
#
#  grompp prepares for equilibration.
#  We need an additional parameter file, nvt.mdp.
#
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr &>> gromacs_infer.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_INFER: Run error!"
  exit 1
fi
#
#  mdrun equilibrates under an NVT ensemble.
#
gmx mdrun -deffnm nvt &>> gromacs_infer.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_INFER: Run error!"
  exit 1
fi
#
#  energy analyzes the temperature progression.
#
gmx energy -f nvt.edr -o temperature.xvg < energy_input2.txt &>> gromacs_infer.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_INFER: Run error!"
  exit 1
fi
#
#  We terminate the run at this point, because this is simple
#  a quick test program.
#
echo ""
echo "GROMACS_INFER: Terminate this short demo at this point."
#
#  Terminate.
#
echo "GROMACS_INFER: Normal end of execution."
exit 0
