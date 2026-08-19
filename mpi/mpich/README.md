# MPI:  Two Processes Sending Messages Back and Forth

This example uses two MPI processes.
The send a user-specified number of messages back and forth.

### Files

_main02.C_:  This is the MPI C++ code.
_makefile.02.mpich.mpi:  The makefile used to build the executable from source.
  This uses the MPICH MPI compiler and MPI library.
_sbatch.mpi.mpich.02.tc.amd.slurm_:  The sbatch slurm script used once the code is compiled.
  This uses the MPICH MPI library.

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
2. module load module load MPICH/4.3.0-GCC-14.2.0
3. make -f makefile.02.mpich.mpi

This should produce an executable file named mpi.simple02.mpich.

##### To Run Code

sbatch sbatch.mpi.mpich.02.tc.amd.slurm
