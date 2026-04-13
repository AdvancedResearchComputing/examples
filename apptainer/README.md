# Apptainer

Apptainer (formerly known as singularity) is a containerization software that works well on HPC systems. Image files can be pulled from various container repositories including docker.

## Apptainer on ARC

Apptainer is the container runtime for HPC — like Docker, but built for
shared clusters. It runs without root, works with SLURM, and lets you
bring your own software environment to any compute node.

---

## Why use Apptainer?

**1. Root access and custom installs**:

ARC's host system is shared — `sudo` and `apt-get` are not available to users. If your workflow depends on libraries or packages that require root to install, a container solves this. With `--fakeroot` you can install system libraries (`libGL`, `ffmpeg`, `libhdf5`), run installer scripts that need root, or compile software from source — anything that would normally require an admin, done inside your own container.


**2. Reproducible environment**:

A container pins every layer of your stack, OS, Python version, CUDA, cuDNN, PyTorch, and every library on top. The environment you build today runs identically the same way in months from now. No surprises from `conda update`, no "it worked yesterday." this way your
collaborators can reproduce your results years later

**3. Portability and sharing**:

Wrap your environment into one `.sif` file and ship it, anyone can run it instantly with no setup or installs on their end. Or pull a Docker image or Dockerfile from a collaborator or paper and run it directly on ARC.

**4. Isolation and complex installs**:

Each container is its own isolated environment. If you are working with conflicting libraries, different Python versions, or niche tools that are painful to install — do it once inside a container and never repeat it.

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

see more [here](https://docs.arc.vt.edu/resources/gpu.html)

</details>

---

## Avoid filling your home directory

Set these before pulling or building any image:

```bash
export APPTAINER_CACHEDIR=/scratch/$USER/apptainer_cache
export APPTAINER_TMPDIR=/tmp
mkdir -p $APPTAINER_CACHEDIR
```

- `APPTAINER_CACHEDIR` → `/scratch` stores downloaded image layers
- `APPTAINER_TMPDIR` → `/tmp` is used for unpacking

<!-- > Add both lines to your `~/.bashrc` so they are always set. -->

---

## Choose your use case

| # | I want to... | Folder |
|---|---|---|
| 1 | Pull and run any image from Docker Hub, NGC, or GHCR | [01_pull_and_run](./01_pull_and_run_image/) |
| 2 | Use a Dockerfile I already have | [02_have_dockerfile](./02_have_dockerfile/) |
| 3 | Customize a container interactively (sandbox + fakeroot) | [03_customize_container](./03_customize_container/) |
| 4 | Build a container from a definition file | [04_build_from_definition_file](./04_build_from_definition_file/) |

---

## Basic usage

**1. Interactive shell** — open a shell inside the container:

```bash
apptainer shell my_image.sif          # CPU
apptainer shell --nv my_image.sif     # GPU
```

Your prompt changes to `Apptainer>`. Type `exit` to leave.

**2. Run a script** — run a command without an interactive shell:

```bash
apptainer exec my_image.sif python3 my_script.py
apptainer exec --nv my_image.sif python3 my_script.py     # GPU
```

**3. Bind your data** — mount your project and scratch directories:

```bash
apptainer exec --nv \
    --bind /projects/<your_project>:/data \
    --bind /scratch/$USER:/scratch \
    my_image.sif \
    python3 /data/my_script.py
```

---

## Further reading

- Full ARC Apptainer documentation: https://www.docs.arc.vt.edu/software/apptainer.html
- Official Apptainer documentation: https://apptainer.org/docs/user/latest/