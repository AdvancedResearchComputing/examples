# Julia Serial Code

Julia version:  Julia 1.11.3

## Codes


### code01

Comes from:  /projects/kuhlman-project-storage/system-maint/y2025/2025-05/test-julia/owl/dev_q/test01

Simple print of material.

----------------------------
To set up to run interactively.

module load Julia/1.11.3-linux-x86_64


----------------------------
To run code.

Tested on owl083, the dev_q

Launch with slurm:  sbatch sbatch.01.06.slurm

Launch on compute node:  sh run.01.06

Diff output:  diff output.01.06.out output.01.06.out.valid

 
----------------------------
Background.

There is a lot of stuff in the sbatch script.
It is worth wading through this, for a user, because it is close to a
"real" sbatch slurm script.

