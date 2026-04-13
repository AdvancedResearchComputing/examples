# I Have a Dockerfile

You have a `Dockerfile` and want to run it on ARC.
You have two options:

- **Option A** — Build with Docker on your local computer → push to Docker Hub → pull on ARC
- **Option B** — Convert the Dockerfile to an Apptainer definition file (`app.def`) and build directly on ARC

---

## Option A — Build locally and pull image on ARC

**On your local computer** (requires Docker):

```bash
docker build -t <your_dockerhub_user>/my_image:v1 .
docker push <your_dockerhub_user>/my_image:v1
```

> **Apple Silicon Mac?** Add `--platform linux/amd64` to the build command
> so the image runs on ARC's x86 nodes:
> `docker build --platform linux/amd64 -t <your_dockerhub_user>/my_image:v1 .`

Once pushed, follow the **[01_pull_and_run](../01_pull_and_run/README.md)**
workflow to pull and run the image on ARC.

---

## Option B — Convert Dockerfile and build

No Docker needed. Convert your Dockerfile to an Apptainer definition
file on local system and build it directly on ARC.

### Step 1 — Convert your Dockerfile

Install `spython` on your local system

```bash
pip install spython
```

Run the conversion on your local system:

```bash
spython recipe Dockerfile app.def
```

`spython` reads your `Dockerfile` and writes the equivalent `app.def`
automatically.

> **Review the output before building.**
> See [CONVERSION_GUIDE.md](./CONVERSION_GUIDE.md) to verify what you
> got and compare against the sample `Dockerfile` and `app.def` in this
> folder.

### Step 2 — Get a compute node

```bash
interact -A <your_account> --partition normal_q --time 4:00:00 --cpus-per-task 8
```

### Step 3 — Load Apptainer and set cache

```bash
module load apptainer

export APPTAINER_CACHEDIR=/scratch/$USER/apptainer_cache
export APPTAINER_TMPDIR=/tmp
mkdir -p $APPTAINER_CACHEDIR
```

<!-- > Add both `export` lines to your `~/.bashrc` so they are always set. -->

### Step 4 — Build the image

```bash
apptainer build /projects/<your_project>/containers/my_image.sif app.def
```

Build time for a PyTorch + CUDA image is typically 10–20 minutes.

> **Always build into `/projects/`** — `.sif` files are several GB and
> will fill your home directory quota.

### Step 5 — Run it

**Open a shell inside the container:**

```bash
apptainer shell /projects/<your_project>/containers/my_image.sif
```

**GPU — add `--nv`:**

```bash
apptainer shell --nv /projects/<your_project>/containers/my_image.sif
```

**Verify everything installed correctly:**

```bash
Apptainer> python3 -c "import torch, transformers, pandas, scipy, matplotlib; print('all good')"
Apptainer> python3 -c "import torch; print(torch.cuda.is_available())"
```

**Run a script:**

```bash
apptainer exec --nv \
    --bind /projects/<your_project>:/data \
    /projects/<your_project>/containers/my_image.sif \
    python3 /data/my_script.py
```