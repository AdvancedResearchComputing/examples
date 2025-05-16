# Julia Parallel Code

Version of Julia:  Julia 1.11.3

## Codes


### code01

This is a gpu-based code.

Comes from:  /projects/kuhlman-project-storage/system-maint/y2025/2025-05/test-julia/falcon/l40s/test10

Simple vector addition.

This example is meant to be run on falcon and on an L40S gpu node.
If you run on some other cluster and/or some other compute node type,
then you have to make the virtual environment (instructions below) in
that (cluster, compute node) pair.
And you will have to modify the path to the resulting VE in the julia 
source code src.01.jl.


----------------------
To set up to run.

We need a virtual environment.

You need only build this virtual environment once.

The directions are in the code01 directory, in file:  README.make-env.01.falcon.l40s.tex

Execute this first.  If you put the VE (virtual environment) in a different directory,
you will need to change the directory in the src.01.jl julia source code file, at the
top.



----------------------
To run code.


Tested on fal052, the l40s_normal_q

Launch with slurm:  sbatch sbatch.01.slurm

Launch on compute node:  sh run.01

No output; too big.

But there are performance data gathered to ensure gpu is running.

Various tests done with a version of this code to ensure correctness.



----------------------------
Background.

There is a lot of stuff in the sbatch script.
It is worth wading through this, for a user, because it is close to a
"real" sbatch slurm script.


