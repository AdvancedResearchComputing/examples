# R Serial Code

Version of R:  module load R/4.4.2-gfbf-2024a

## Codes


------------------------------------------
------------------------------------------
### code01

This is a serial code.

Comes from:  /projects/kuhlman-project-storage/system-maint/y2025/2025-05/test-r/owl/standard/test01

Cluster:  Owl.

Partition:  dev_q

Compute node:  owl083


----------------------
To set up to run.

For interactive jobs, need:
module load  module load R/4.4.2-gfbf-2024a


----------------------
To run code.


Tested on Owl cluster, compute node owl083, on standard CPU nodes.

Launch with slurm:  sbatch sbatch.02.slurm

Diff output:  diff output.owl.dev_q.<JOB_ID>.txt   output.owl.dev_q.txt.valid 



----------------------------
Background.

There is a lot of stuff in the sbatch script.
It is worth wading through this, for a user, because it is close to a
"real" sbatch slurm script.


