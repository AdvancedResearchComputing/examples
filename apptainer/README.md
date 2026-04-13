# Apptainer

Apptainer (formerly known as singularity) is a containerization software that works well on HPC systems. Image files can be pulled from various container repositories including docker.

## Apptainer on ARC

 — it runs without root, works with SLURM, and,lets you bring your own software environment to any compute node.

If you have spent hours fighting a `pip install` or `conda install` that broke something else, needed a tool that is not in the module system, or wanted to share
your exact working environment with a collaborator — this is for you.

---

## Why use Apptainer on ARC?

### Root access and custom installs

ARC's host system is shared — you cannot run `sudo` or `apt-get` on it.
Inside an Apptainer container with `--fakeroot` you can. Install system
libraries (`libGL`, `ffmpeg`, `libhdf5`), run installer scripts that need
root, or compile software from source. Anything that would normally require
an admin can be done inside your own container.

### A frozen, reproducible environment

A container pins every layer of your stack — OS, Python version, CUDA,
cuDNN, PyTorch, and every library on top. The environment you build today
runs identically six months from now. No surprises from `conda update`, no
silent version drift, no "it worked yesterday." For published research, a
`.def` file is a methods section for your software stack — reviewers and
collaborators can reproduce your results years later.

### Portability and sharing

Ship one `.sif` file and everyone gets the exact same environment. No more
"works on my machine." Build on ARC and run the same image on another
cluster, a cloud VM, or a collaborator's system. If a paper or lab shared
a Docker image or Dockerfile, pull it directly — no rebuilding required.

### Isolation and complex installs

Some tools need 20 installation steps, conflict with your other software,
or are simply not in the ARC module system. Each container is its own
isolated environment — different Python versions, conflicting libraries, or
niche bioinformatics tools coexist without interfering. Do the complex
install once, never repeat it.

---

## Before you start

> Apptainer does not work on ARC login nodes. Always get a compute node first.

```bash
# CPU
interact -A <your_account> --partition normal_q --time 2:00:00 --cpus-per-task 4

# GPU
interact -A <your_account> --partition t4_normal_q --gres gpu:1 --time 2:00:00
```

Then load Apptainer:

```bash
module load apptainer
```

<details>
<summary>Available GPU partitions on ARC</summary>

| GPU | Partition | Memory |
|---|---|---|
| T4 | `t4_normal_q` | 16G |
| V100 | `v100_normal_q` | 16G |
| A30 | `a30_normal_q` | 24G |
| L40S | `l40s_normal_q` | 48G |
| A100 | `a100_normal_q` | 80G |
| H200 | `h200_normal_q` | 141G |

</details>

---

## Avoid filling your home directory

Apptainer downloads and unpacks image layers during a pull or build.
Without intervention this fills your `$HOME` quota fast.

Set these before pulling or building any image:

```bash
export APPTAINER_CACHEDIR=/scratch/$USER/apptainer_cache
export APPTAINER_TMPDIR=/tmp
mkdir -p $APPTAINER_CACHEDIR
```

> Add both `export` lines to your `~/.bashrc` so they are always set.
>
> - `APPTAINER_CACHEDIR` on `/scratch` — stores downloaded image layers
> - `APPTAINER_TMPDIR` as `/tmp` — used for unpacking. The scratch
>   filesystem does not support the extended attributes Apptainer needs
>   here; local `/tmp` does.

---

## Basic usage

### Interactive shell

Open a shell inside the container — useful for testing and exploration:

```bash
apptainer shell my_image.sif
```

Your prompt changes to `Apptainer>`. Type `exit` to leave.
Add `--nv` to pass through the node's GPU:

```bash
apptainer shell --nv my_image.sif
```

### Run a script

Run a single command or script without an interactive shell:

```bash
apptainer exec my_image.sif python3 my_script.py

# With GPU
apptainer exec --nv my_image.sif python3 my_script.py
```

### Bind your data

Your `$HOME` and `/projects` directories are visible inside the container
by default. To explicitly bind a directory to a path inside the container:

```bash
apptainer exec --nv \
    --bind /projects/<your_project>:/data \
    --bind /scratch/$USER:/scratch \
    my_image.sif \
    python3 /data/my_script.py
```

Inside the container, `/data` is your project directory and `/scratch` is
your scratch space. Your script reads and writes there as normal.

---

## Choose your use case

| # | I want to... | Folder |
|---|---|---|
| 1 | Pull and run any image from Docker Hub, NGC, or GHCR | [01_pull_and_run](./01_pull_and_run/) |
| 2 | Use a Dockerfile I already have | [02_have_dockerfile](./02_have_dockerfile/) |
| 3 | Customize a container interactively (sandbox + fakeroot) | [03_customize_container](./03_customize_container/) |
| 4 | Build a container from a definition file | [04_build_from_definition_file](./04_build_from_definition_file/) |

---

## Further reading

Full ARC Apptainer documentation:
https://www.docs.arc.vt.edu/software/apptainer.html

Official Apptainer documentation:
https://apptainer.org/docs/user/latest/