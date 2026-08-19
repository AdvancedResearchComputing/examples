# MPI:  Two Processes Sending Messages Back and Forth

This example uses two MPI processes.
The processes send a user-specified number of messages back and forth.

The MPI implementation is Intel.

### Files

1. _main02.C_:  This is the MPI C++ code.
2. _makefile.02.intel.mpiicpx:  The makefile used to build the executable from source.
  This uses the Intel MPI compiler and MPI library.
3. _sbatch.mpi.intel.02.tc.amd.slurm_:  The sbatch slurm script used once the code is compiled.
  This uses the Intel MPI library.

Two valid output files.  Your results may vary only because of the
number of messages to send; the command line argument (CLA).
1. mpi_results_0.out.valid
2. mpi_results_1.out.valid

... where the 0 and 1 in the valid file names are the MPI ranks.

Two command line arguments:
1. The number of messages sent back and forth.
2. The name of the base output file (each MPI process generates an output file).


### Process

##### To Build the Executable

Set the environment and make the executable:

1. module reset
2. module load intel/2024a
3. make -f makefile.02.intel.mpiicpx

This should produce an executable file named mpi.simple02.intel.

##### To Run Code

sbatch sbatch.mpi.intel.02.tc.amd.slurm
