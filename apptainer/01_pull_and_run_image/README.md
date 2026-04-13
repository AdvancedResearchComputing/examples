# Pull and Run a Prebuilt Image

The simplest way to use Apptainer on ARC. No Dockerfile, no build step.
Pull an image directly from Docker Hub and run it on a compute node in just 4 steps.

---

## Step 1 — Get a compute node

Apptainer does not work on login nodes. Get a compute node first:

```bash
# CPU
interact -A <your_account> --partition normal_q --time 2:00:00 --cpus-per-task 4

# GPU (this example uses t4_normal_q — swap for any GPU partition you have access to)
interact -A <your_account> --partition t4_normal_q --gres gpu:1 --time 2:00:00
```

## Step 2 — Load Apptainer and set cache

```bash
module load apptainer

export APPTAINER_CACHEDIR=/scratch/$USER/apptainer_cache
export APPTAINER_TMPDIR=/scratch/$USER/apptainer_tmp
mkdir -p $APPTAINER_CACHEDIR $APPTAINER_TMPDIR
```

> Apptainer caches image layers during the pull. Pointing it at scratch prevents it from filling your home directory quota.
> Add the two `export` lines to your `~/.bashrc` so they are always set.

---

## Step 3 — Pull an image

```bash
apptainer pull docker://pytorch/pytorch:2.2.2-cuda12.1-cudnn8-runtime
```

This creates `pytorch_2.2.2-cuda12.1-cudnn8-runtime.sif` in your current directory.

> **Store `.sif` files in `/projects/` not `$HOME`** — they are several GB.

```bash
mkdir -p /projects/<your_project>/containers
mv pytorch_2.2.2-cuda12.1-cudnn8-runtime.sif /projects/<your_project>/containers/pytorch.sif
```

---

## Step 4 — Run it

**Open a shell inside the container:**

```bash
apptainer shell /projects/<your_project>/containers/pytorch.sif
```

```bash
apptainer shell --nv /projects/<your_project>/containers/pytorch.sif
```

Your prompt changes to `Apptainer>`. Your home and project directories are
still accessible. Type `exit` to leave the container.

**Run a single command:**

```bash
apptainer exec /projects/<your_project>/containers/pytorch.sif \
    python3 -c "import torch; print(torch.__version__)"
```

**GPU — add `--nv`:**

```bash
apptainer exec --nv /projects/<your_project>/containers/pytorch.sif \
    python3 -c "import torch; print(torch.cuda.is_available())"
```

**Bind your data:**

By default your `/home` and `/projects` are visible inside the container.
To explicitly bind a directory to a path inside the container:

```bash
apptainer exec --nv \
    --bind /projects/<your_project>:/data \
    /projects/<your_project>/containers/pytorch.sif \
    python3 /data/my_script.py
```

Inside the container, your project directory is now at `/data`.

---

## Other registries

The same `apptainer pull` works for any public registry:

```bash
# NVIDIA NGC — optimized GPU containers
apptainer pull docker://nvcr.io/nvidia/pytorch:24.03-py3

# GitHub Container Registry
apptainer pull docker://ghcr.io/<org>/<image>:<tag>

# Sylabs Cloud (Apptainer native format)
apptainer pull library://lolcow
```

## What images will and will not work
 
**Works on ARC — headless runtime images:**
- Python, PyTorch, TensorFlow, JAX runtimes
- R and bioinformatics tools (samtools, bwa, GATK)
- Any CLI-based application
 
**Will not work on ARC — images that need a display:**
- Desktop environments (GNOME, LXDE, KDE)
- GUI applications (browsers, IDEs with a graphical interface)
- Anything that opens a window
 
> **Need to install extra packages with root access?**
> Use the sandbox + fakeroot workflow in
> [03_customize_container](../03_customize_container/).
