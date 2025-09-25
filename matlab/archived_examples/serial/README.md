# Matlab Serial Code

Version of Matlab:  module load MATLAB/R2024b

## Codes


------------------------------------------
------------------------------------------
### code01

This is a serial code.

Comes from:  /projects/kuhlman-project-storage/system-maint/y2025/2025-05/test-matlab/tc/amd-rome/test04.

Cluster:  Tinkercliffs.

Partition:  was dev_q; now is normal_q

Compute node:  tc285


----------------------
To set up to run.

For interactive jobs, need:
module load  module load MATLAB/R2024b


----------------------
To run code.


Tested on TC cluster, compute node tc285, on standard CPU nodes.

Launch with slurm:  sbatch sbatch.04.slurm

Launch on compute node:  sh run.04

Diff output:  diff mat.out mat.out.valid

There are performance data gathered.




----------------------------
Background.

There is a lot of stuff in the sbatch script.
It is worth wading through this, for a user, because it is close to a
"real" sbatch slurm script.


------------------------------------------
------------------------------------------
### code02

This is a serial code.

Comes from:  /projects/kuhlman-project-storage/system-maint/y2025/2025-05/test-matlab/owl/interactive_q/test04

Cluster:  Owl.

Partition:  interactive_q (seems a strange name).

Compute node:  owlmln004


----------------------
To set up to run.

For interactive jobs, need:
module load  module load MATLAB/R2024b


----------------------
To run code.


Tested on Owl cluster, compute node owlmln004, CPU nodes.

Launch with slurm:  sbatch sbatch.04.slurm

Launch on compute node:  sh run.04

Diff output:  diff mat.out mat.out.valid

There are performance data gathered.




----------------------------
Background.

There is a lot of stuff in the sbatch script.
It is worth wading through this, for a user, because it is close to a
"real" sbatch slurm script.







