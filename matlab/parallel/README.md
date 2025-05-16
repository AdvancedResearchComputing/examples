# Julia Parallel Code

Version of Matlab:  module load MATLAB/R2024b

## Codes


------------------------------------------
------------------------------------------
### code01

This is a gpu-based code.

Comes from:  /projects/kuhlman-project-storage/system-maint/y2025/2025-05/test-matlab/tc/a100+dgx/test02

Cluster:  Tinkercliffs.

Partition:  a100_normal_q

Compute node:  tc-gpu004


----------------------
To set up to run.

For interactive jobs, need:
module load  module load MATLAB/R2024b


----------------------
To run code.


Tested on TC cluster, compute node tc-gpu004, on A100 + DGX.

Launch with slurm:  sbatch sbatch.02.slurm

Launch on compute node:  sh run.02

No output; too big.

But there are performance data gathered to ensure gpu is running.

Various tests done with a version of this code to ensure correctness.



----------------------------
Background.

There is a lot of stuff in the sbatch script.
It is worth wading through this, for a user, because it is close to a
"real" sbatch slurm script.


------------------------------------------
------------------------------------------
### code02

This is a gpu-based code.

Comes from:  /projects/kuhlman-project-storage/system-maint/y2025/2025-05/test-matlab/tc/dell-h200/test04

Cluster:  Tinkercliffs.

Partition:  h200_normal_q

Compute node:  tc-xe004


----------------------
To set up to run.

For interactive jobs, need:
module load  module load MATLAB/R2024b


----------------------
To run code.


Tested on TC cluster, compute node tc-gpu004, on A100 + DGX.


Launch with slurm:  sbatch sbatch.04.slurm

Launch on compute node:  sh run.04

No output; too big.

But there are performance data gathered to ensure gpu is running.



------------------------------------------
------------------------------------------
### code03



