# Customize a Container (Sandbox + Fakeroot)

Use this when you need to install software interactively inside a container
with root-like privileges — for example, when a tool requires `apt-get` or
runs an install script that needs root access.

A **sandbox** is a writable directory that behaves like a container.
**Fakeroot** lets you act as root inside it without affecting the host system.

This example walks through installing [Ollama](https://ollama.com) — an LLM
inference tool — inside a custom Ubuntu + CUDA container on ARC.

---

## Step 1 — Get a GPU compute node

```bash
interact -A <your_account> --partition t4_normal_q --gres gpu:1 --time 4:00:00
module load apptainer
```

---

## Step 2 — Build a writable sandbox

```bash
apptainer build --sandbox ubuntu24.04/ docker://nvidia/cuda:12.6.0-devel-ubuntu24.04
```

- `--sandbox` creates a writable directory instead of a read-only `.sif` file
- We start from NVIDIA's CUDA-enabled Ubuntu 24.04 image

> **Store your sandbox in `/scratch/` or `/projects/`** — it will be several GB.

---

## Step 3 — Enter the sandbox as root

```bash
apptainer shell --fakeroot --writable --bind /home ubuntu24.04/
```

- `--fakeroot` lets you act as root inside the container
- `--writable` makes changes persist in the sandbox
- `--bind /home` makes your home directory accessible inside

Verify you are inside the container:

```bash
cat /etc/os-release
# Should show: Ubuntu 24.04
```

---

## Step 4 — Install packages

Inside the sandbox:

```bash
apt-get update && apt-get upgrade -y
apt-get install -y \
    build-essential cmake git \
    wget curl zstd

mkdir -p /localscratch
exit
```

> You are installing as root inside the container only.
> Nothing on the host system is affected.

---

## Step 5 — Install your application

Some tools (like Ollama) need root for their install scripts.
Re-enter the sandbox with fakeroot and run the installer:

```bash
apptainer shell --fakeroot --writable \
    --bind /localscratch --bind /home \
    ubuntu24.04/

# Inside the sandbox:
curl -fsSL https://ollama.com/install.sh | sh
exit
```

---

## Step 6 — Run with GPU access

You no longer need `--fakeroot` or `--writable` for normal use:

```bash
apptainer shell --nv \
    --bind /localscratch \
    --bind /home \
    --bind /projects \
    ubuntu24.04/
```

Verify the GPU is visible:

```bash
nvidia-smi
```

---

## Step 7 — Start Ollama

Inside the container:

```bash
ollama serve
```

In a second terminal, SSH into the same node, re-enter the container, and run a model:

```bash
module load apptainer
apptainer shell --nv \
    --bind /localscratch --bind /home --bind /projects \
    ubuntu24.04/

ollama run gemma3:1b
```

---

## Convert the sandbox to a .sif (optional)

Once you are happy with the environment, freeze it to a portable read-only `.sif`:

```bash
apptainer build /projects/<your_project>/containers/my_custom.sif ubuntu24.04/
```

You can then use `my_custom.sif` in batch jobs like any other image.

> **Tip:** Write down every command you ran in Steps 4 and 5.
> Use them to build a `.def` file so the image is reproducible.
> See [05_build_from_definition_file](../05_build_from_definition_file/).
```