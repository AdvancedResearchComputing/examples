#! /bin/bash
#Example script for running WRF on ARC systems
# - Input files input_sounding and namelist.input copied from
#   test/em_tropical_cyclone in the WRF install directory
# - namelist.input edited to simulate 1 day rather than 6 to 
#   reduce runtime
#
# On Tinkercliffs this example should take around 10 mins to run and use less than 2GB of memory.
#
#SBATCH --job-name=wrf_example
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:30:00
#SBATCH --account=personal

#load modules
module reset
module load WRF

#Make a directory for this example to store all the output
mkdir wrf_example.$SLURM_JOBID

#copy the files needed to run this example into this job's directory
cp input_sounding namelist.input wrf_example.$SLURM_JOBID

#change into the working directory
cd wrf_example.$SLURM_JOBID

#symlink to required input data (mimic run_me_first.csh from example)
ln -sf "$EBROOTWRF/WRFV4.6.1/run/LANDUSE.TBL" .
ln -sf "$EBROOTWRF/WRFV4.6.1/run/RRTM_DATA" .

#run ideal.exe to generate input files
ideal.exe

#move the outputs from ideal.exe so they're not overwritten by wrf
mv rsl.error.0000 ideal_rsl.error.0000
mv rsl.out.0000 ideal_rsl.out.0000

#run WRF
mpirun -np $SLURM_NTASKS wrf.exe





