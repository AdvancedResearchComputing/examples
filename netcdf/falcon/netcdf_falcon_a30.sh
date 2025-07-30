#! /bin/bash
#
# SLURM Job Script to Compile, Run, and Demonstrate netCDF Utilities on Falcon (A30 nodes)
#
#SBATCH -t 00:10:00
#SBATCH -N1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH -p a30_normal_q
#SBATCH -A arcadm
#SBATCH --gres=gpu:1

# Load the necessary modules
module reset                        # Reset modules to system default
module load netCDF                  # Load the netCDF module
module list                         # Print currently loaded modules (for reproducibility/debugging)

echo "NETCDF_Falcon A30: Starting execution."

#############################################
# Step 1: Print Compilation Configuration
#############################################
echo "=== nc-config output ==="
# nc-config shows compiler and linker flags required to build with NetCDF
$EBROOTNETCDF/bin/nc-config --all
echo "========================"

#############################################
# Step 2: Compile the netCDF C program
#############################################
# Compile the C source file using the NetCDF headers
gcc -c -I$EBROOTNETCDF/include netcdf_test.c
if [ $? -ne 0 ]; then
  echo "NETCDF_Falcon A30: Compilation failed!"
  exit 1
fi

# Link the object file against the NetCDF library
gcc -o netcdf_test netcdf_test.o -L$EBROOTNETCDF/lib64 -lnetcdf
if [ $? -ne 0 ]; then
  echo "NETCDF_Falcon A30: Linking failed!"
  exit 1
fi

# Remove the intermediate object file
rm netcdf_test.o

#############################################
# Step 3: Run the netCDF Test Program
#############################################
# This program creates a sample netCDF file, reads it back, and verifies correctness
./netcdf_test > netcdf_falcon_A30.txt
if [ $? -ne 0 ]; then
  echo "NETCDF_FALCON A30: Execution failed!"
  exit 1
fi

#############################################
# Step 4: Demonstrate netCDF Command-Line Tools
#############################################

# Append the output of ncdump (human-readable view of netCDF file) to the output log
echo "=== ncdump output ===" >> netcdf_falcon_A30.txt
$EBROOTNETCDF/bin/ncdump netcdf_test.nc >> netcdf_falcon_A30.txt
echo "=====================" >> netcdf_falcon_A30.txt

# Use nccopy to create a copy of the netCDF file (e.g., to compress or filter data)
$EBROOTNETCDF/bin/nccopy netcdf_test.nc netcdf_test_copy.nc
echo "Created netCDF copy: netcdf_test_copy.nc" >> netcdf_falcon_A30.txt

#############################################
# Step 5: Clean Up
#############################################
# Delete the binary executable (optional for keeping scratch directories clean)
rm netcdf_test

echo "NETCDF_Falcon A30: Finished execution successfully."
exit 0
