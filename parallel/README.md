# GNU/parallel
GNU/parallel is a standard linux utility for launching multiple concurrent, parameterized tasks. This is an effective tool for many workloads which involve parameter sweeps. `parallel` can be combined with SLURM's `srun` to easily launch multiple tasks across a SLURM job's resource allocation and ensure CPU and GPU binding and exclusive access. This is essential when you want to ensure that each concurrent process has access to sufficient computation power and that the several processes to not interfere with each other by attempting to use another processes CPUs or GPU.

# Contents
 - `multinode_par_gpu.sh` - Slurm batch script which launches several concurrent tasks, each with access to 1 GPU and 4 CPU cores
 - `par_gpu_driver.sh` - A driver/wrapper script which is called by `multinode_par_gpu.sh`