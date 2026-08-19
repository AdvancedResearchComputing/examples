# MPI:  Two Processes Sending Messages Back and Forth

This example uses two MPI processes.
The processes send a user-specified number of messages back and forth.

The MPI implementation is MPICH.

### Files

1. _main02.C_:  This is the MPI C++ code.
2. _makefile.02.mpich.mpi_:  The makefile used to build the executable from source.
  This uses the MPICH MPI compiler and MPI library.
3. _sbatch.mpi.mpich.02.tc.amd.slurm_:  The sbatch slurm script used once the code is compiled.
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

Note:  You have to run the code on the same type of compute node on which the C++
code was built.

##### To Build the Executable

Get onto a compute node, set the environment, and make/build the executable.

Before starting, note the directory you are in that contains these files; call it _dir01_.

Add your account and remove `arcadm` in step 1.

1. `interact --account=arcadm --time=2:00:00 --ntasks=1  --ntasks-per-node=1 --cpus-per-task=1  --partition=normal_q  --constraint=amd`
2. You are now on the compute node.
3. Change directory on the compute node to where your code is:  `cd dir01`.
4. `module reset`
5. `module load MPICH/4.3.0-GCC-14.2.0`
6. `make -f makefile.02.mpich.mpi`
7. This should produce an executable file named `mpi.simple02.mpich`.
It should be located with the other files in this example.
8. Type `exit` to log off of the compute node.

##### To Run Code

`sbatch sbatch.mpi.mpich.02.tc.amd.slurm`
