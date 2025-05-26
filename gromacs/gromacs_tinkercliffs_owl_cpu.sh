#! /bin/bash
#SBATCH --account=WRITE_YOUR_ACCOUNT_HERE  # Use your account name
#SBATCH -t 00:10:00                        # Time limit of the job. Adjust as needed.
#SBATCH --ntasks-per-node=96               # Recommended value: up to 96 in Owl and 128 in TinkerCliffs
#SBATCH -p normal_q                        # Use the normal CPU partition

module reset
module load GROMACS/2024.4-foss-2023b
# module load GROMACS/2024.4-foss-2023b-PLUMED-2.9.2

echo "GROMACS_TINKERCLIFFS_OWL: Normal beginning of execution."
#
#  Discard the previous output file, if any.
#
if [ -e gromacs_tinkercliffs_owl.txt ]; then
  rm gromacs_tinkercliffs_owl.txt
fi
#
#  Our primary input data is 1aki.pdb.
#  For certain commands, we must access auxilliary *.mdp files of parameters.
#  Because this is not an interactive run, occasional interactive input
#  is supplied by *input.txt files.
#  All the output goes into a single file "gromacs_tinkercliffs_owl.txt".
#
#  pdb2gmx reads the pdb file, and generates:
#  * the topology of the molecule (topol.top);
#  * a position restraint file (posre.itp);
#  * a post-processed structure file (1aki_processed.gro).
#
gmx pdb2gmx -f 1aki.pdb -o 1aki_processed.gro -water spce < pdb2gmx_input.txt &> gromacs_tinkercliffs_owl.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_TINKERCLIFFS_OWL: Run error!"
  exit 1
fi
#
#  editconf defines the box dimensions.
#  We choose centering, place the protein at least 1 nm from the box edge,
#  and use a cubic box.
#
gmx editconf -f 1aki_processed.gro -o 1aki_newbox.gro -c -d 1.0 -bt cubic &>> gromacs_tinkercliffs_owl.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_TINKERCLIFFS_OWL: Run error!"
  exit 1
fi
#
#  solvate fills the box with water.
#
gmx solvate -cp 1aki_newbox.gro -cs spc216.gro -o 1aki_solv.gro -p topol.top &>> gromacs_tinkercliffs_owl.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_TINKERCLIFFS_OWL: Run error!"
  exit 1
fi
#
#  grommp prepares for the replacement of water by ions.
#  Create a tpr file to specify how to replace water molecules with specified ions.
#  We need an additional parameter file, ion.mdp.
#
gmx grompp -maxwarn 10 -f ions.mdp -c 1aki_solv.gro -p topol.top -o ions.tpr &>> gromacs_tinkercliffs_owl.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_TINKERCLIFFS_OWL: Run error!"
  exit 1
fi
#
#  genion carries out the replacement of water by ions.
#
gmx genion -s ions.tpr -o 1aki_solv_ions.gro -p topol.top -pname NA -nname CL -nn 8 < genion_input.txt &>> gromacs_tinkercliffs_owl.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_TINKERCLIFFS_OWL: Run error!"
  exit 1
fi
#
#  grompp assembles the structure, topology and simulation parameters
#  into a binary file in preparation to relax the structure through
#  energy minimization.
#  We need an additional parameter file, minim.mdp.
#
gmx grompp -f minim.mdp -c 1aki_solv_ions.gro -p topol.top -o em.tpr &>> gromacs_tinkercliffs_owl.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_TINKERCLIFFS_OWL: Run error!"
  exit 1
fi
#
#  mdrun carries out the energy minimization.
#
gmx mdrun -v -deffnm em &>> gromacs_tinkercliffs_owl.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_TINKERCLIFFS_OWL: Run error!"
  exit 1
fi
#
#  energy analyzes the energy terms in em.edr
#
gmx energy -f em.edr -o potential.xvg < energy_input1.txt &>> gromacs_tinkercliffs_owl.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_TINKERCLIFFS_OWL: Run error!"
  exit 1
fi
#
#  grompp prepares for equilibration.
#  We need an additional parameter file, nvt.mdp.
#
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr &>> gromacs_tinkercliffs_owl.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_TINKERCLIFFS_OWL: Run error!"
  exit 1
fi
#
#  mdrun equilibrates under an NVT ensemble.
#
gmx mdrun -deffnm nvt &>> gromacs_tinkercliffs_owl.txt
#gmx mdrun -deffnm nvt -plumed plumed.dat &>> gromacs_tinkercliffs_owl.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_TINKERCLIFFS_OWL: Run error!"
  exit 1
fi
#
#  energy analyzes the temperature progression.
#
gmx energy -f nvt.edr -o temperature.xvg < energy_input2.txt &>> gromacs_tinkercliffs_owl.txt
if [ $? -ne 0 ]; then
  echo "GROMACS_TINKERCLIFFS_OWL: Run error!"
  exit 1
fi
#
#  We terminate the run at this point, because this is simple
#  a quick test program.
#
echo ""
echo "GROMACS_TINKERCLIFFS_OWL: Terminate this short demo at this point."
#
#  Terminate.
#
echo "GROMACS_TINKERCLIFFS_OWL: Normal end of execution."
exit 0
