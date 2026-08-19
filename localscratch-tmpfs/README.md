# Running a Job Using Localscratch

### Two Types of Localscratch

1. $TMPDIR uses a compute node's hard drive.
2. $TMPFS use a compute node's volatile memory.

This example uses $TMPFS, so we are using localscratch
via RAM.

There is another, analogous, example that uses $TMPDIR,
and this means the hard drive.

### Why Use Localscratch

Localscratch memory is very fast access memory;
the fastest memory access of all ARC options.
($TMPFS is faster than $TMPDIR.)

### What is the Catch

The catch is that both of these types of memory
(directory and on chip) only exist for the life of the
(slurm) job.

### What You Have To Do

Thus, AS PART OF YOUR SLURM JOB, you must move all files
that you need ONTO the localscratch
and when your computations are done, you have to copy out
the results (or move the results) BACK INTO a more
permanent storage before the job ends.
More permanent storage includes your scratch area or
a /projects directory.

Why can't I move my input files to localscratch before
the job starts?

Because you do not know the location of localscratch; it
is determined at run time.

Why can't I wait until after the job completes to move
or copy the output files to more permanent storage?

Because when the slurm job ends, the localscratch memory
is demolished, and your files get demolished with that.
So there is nothing to move when the job completes---that is
all gone.

### System Variables

Because localscratch is assigned at run time, the way to
deal with local scratch is to put into your sbatch
slurm script:

1. use $TMPDIR when using a directory for localscratch
   (which is this example).
2. use $TMPFS when using chip memory for localscratch
   (which is the other example).

These system/environment variables hold the values of
the local scratch locations.

Also, you can compare the two sets of code for these two
examples:  other than this environment variable, the
two sets of codes are identical. 

### Files

1.  _sbatch.python.02.tc.amd.slurm_:  sbatch slurm script.
This file has all of the interesting things in it, e.g.,
copying/moving data in and out of local scratch as part
of the job.
2.  _run.03_:  bash script that is called by the sbatch
slurm script and invokes the python code with the CLAs.
3.  _char_count_02.py_:  python code; does a string manipulation.
4.  _input.02.inp_:  the input file containing the string. 
 
The output file that is generated is _results.python.02.out_.
This file can be compared with provided validated file
_results.python.02.out.valid_.

### Submit Slurm Job

Enter on command line:

_sbatch sbatch.python.02.tc.amd.slurm_
