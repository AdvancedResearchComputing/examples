#! /bin/bash
#
# SLURM Job Script to Compile, Run, and Demonstrate HDF5 File Operations on Tinkercliffs (AMD nodes)
#
#SBATCH -t 00:10:00                     # Maximum runtime: 10 minutes
#SBATCH -N1                             # Request 1 node
#SBATCH --ntasks-per-node=1             # One process per node
#SBATCH --cpus-per-task=4               # Four cores per process
#SBATCH -p normal_q                     # Use normal_q partition
#SBATCH -A <your_slurm_account_name>    # replace with your allocation name
#SBATCH --constraint=amd                # Select AMD nodes of normal_q

#############################################
# Step 1: Environment Setup
#############################################
module reset
module load HDF5

echo "HDF5_TINKERCLIFFS ROME: Starting execution."

#############################################
# Step 2: Compilation
#############################################
echo "Compiling hdf5_test.c with h5pcc..."
h5pcc -c hdf5_test.c
if [ $? -ne 0 ]; then
  echo "HDF5_TINKERCLIFFS ROME: Compilation failed!"
  exit 1
else
  echo "Compilation successful."
fi

echo "Linking executable..."
h5pcc -o hdf5_test hdf5_test.o
if [ $? -ne 0 ]; then
  echo "HDF5_TINKERCLIFFS ROME: Linking failed!"
  exit 1
else
  echo "Linking successful."
fi

rm hdf5_test.o

#############################################
# Step 3: Run the Test Program
#############################################
echo "Running the test program..."
./hdf5_test > hdf5_tinkercliffs_rome.txt
if [ $? -ne 0 ]; then
  echo "HDF5_TINKERCLIFFS ROME: Program execution failed!"
  exit 1
else
  echo "Program executed successfully."
fi

#############################################
# Step 4: Demonstrate HDF5 Utilities
#############################################

# 4.1 h5dump - Human-readable contents
echo "Running h5dump..."
echo "=== h5dump output ===" >> hdf5_tinkercliffs_rome.txt
$EBROOTHDF5/bin/h5dump hdf5_test.h5 >> hdf5_tinkercliffs_rome.txt
if [ $? -eq 0 ]; then
  echo "h5dump succeeded."
else
  echo "h5dump failed."
  exit 1
fi
echo "=====================" >> hdf5_tinkercliffs_rome.txt

# 4.2 h5ls - Dataset structure
echo "Running h5ls..."
echo "=== h5ls output ===" >> hdf5_tinkercliffs_rome.txt
$EBROOTHDF5/bin/h5ls -r hdf5_test.h5 >> hdf5_tinkercliffs_rome.txt
if [ $? -eq 0 ]; then
  echo "h5ls succeeded."
else
  echo "h5ls failed."
  exit 1
fi
echo "===================" >> hdf5_tinkercliffs_rome.txt

# 4.3 h5copy - Copy dataset
echo "Running h5copy..."
rm -f hdf5_test_copy.h5
$EBROOTHDF5/bin/h5copy -i hdf5_test.h5 -o hdf5_test_copy.h5 -s /array -d /array_copy
if [ $? -eq 0 ]; then
  echo "h5copy succeeded."
  echo "Copied 'array' → 'array_copy' in hdf5_test_copy.h5" >> hdf5_tinkercliffs_rome.txt
else
  echo "h5copy failed."
  exit 1
fi

# 4.4 h5diff - Compare original and copy
echo "Running h5diff..."
echo "=== h5diff output ===" >> hdf5_tinkercliffs_rome.txt
$EBROOTHDF5/bin/h5diff hdf5_test.h5 hdf5_test_copy.h5 /array /array_copy >> hdf5_tinkercliffs_rome.txt
if [ $? -eq 0 ]; then
  echo "h5diff succeeded (files match)."
else
  echo "h5diff found differences or failed."
  exit 1
fi
echo "=====================" >> hdf5_tinkercliffs_rome.txt

# 4.5 h5stat - File statistics
echo "Running h5stat..."
echo "=== h5stat output ===" >> hdf5_tinkercliffs_rome.txt
$EBROOTHDF5/bin/h5stat hdf5_test.h5 >> hdf5_tinkercliffs_rome.txt
if [ $? -eq 0 ]; then
  echo "h5stat succeeded."
else
  echo "h5stat failed."
  exit 1
fi
echo "=====================" >> hdf5_tinkercliffs_rome.txt

#############################################
# Step 5: Clean Up
#############################################
rm hdf5_test

echo "HDF5_TINKERCLIFFS ROME: Finished execution successfully."
exit 0
