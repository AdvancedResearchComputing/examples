#! /bin/bash
#Example script for running WRF on ARC systems
# - Input files input_sounding and namelist.input copied from
#   test/em_tropical_cyclone in the WRF install directory
# - namelist.input edited to simulate 1 day rather than 6 to 
#   reduce runtime
#
#SBATCH -t 00:30:00
#SBATCH -N1 --ntasks-per-node=4
#SBATCH -p dev_q
#

#load modules
module reset
module load WRF/4.2.2-foss-2020b-dmpar

#symlink to required input data (mimic run_me_first.csh from example)
ln -sf "$EBROOTWRF/WRF-4.2.2/run/LANDUSE.TBL" .
ln -sf "$EBROOTWRF/WRF-4.2.2/run/RRTM_DATA" .

#run ideal.exe to generate input files
ideal.exe

#move the outputs from ideal.exe so they're not overwritten by wrf
mv rsl.error.0000 ideal_rsl.error.0000
mv rsl.out.0000 ideal_rsl.out.0000

#run WRF
mpirun -np $SLURM_NTASKS wrf.exe
