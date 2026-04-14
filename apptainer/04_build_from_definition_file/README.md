# Build from a Definition File

A definition file (`.def`) is a plain text recipe for building a container.
It is the Apptainer equivalent of a Dockerfile — reproducible,
version-controlled, and easy to share.

Use this when you want to write your own build recipe from scratch,
rather than converting an existing Dockerfile.

The `example.def` in this folder is a ready-to-use starting point.

---

## Definition file structure

A `.def` file has a header and a set of sections. Here is what each one does:

```singularity
# Header — the base image to start from (required)
Bootstrap: docker
From: pytorch/pytorch:2.2.2-cuda12.1-cudnn8-runtime

# %post — commands that run during the build (equivalent to RUN in a Dockerfile)
%post
    apt-get update && apt-get install -y git wget build-essential \
     && apt-get clean && rm -rf /var/lib/apt/lists/*
    pip install numpy scipy pandas matplotlib

# %environment — variables set every time the container runs (equivalent to ENV)
%environment
    export PYTHONDONTWRITEBYTECODE=1
    export PYTHONUNBUFFERED=1

# %labels — metadata about the image
%labels
    Author xxx
    Version 1.0

# %help — shown when you run: apptainer run-help my_image.sif
%help
    Usage: apptainer exec --nv my_image.sif python3 your_script.py
```

---

## Build and run

The build and run steps are the same as in
**[02_have_dockerfile — Option B](../02_have_dockerfile/README.md#option-b----convert-and-build-directly-on-arc)**.

Follow those steps, replacing `app.def` with `example.def`:

```bash
apptainer build /projects/<your_project>/containers/my_image.sif example.def
```

---

## Adapting example.def for your own use

Open `example.def` and make these changes:

1. **`From:`** — change to your base image
2. **`%post`** — add your `apt-get` installs and `pip install` packages
3. **`%environment`** — add any environment variables your code needs
4. **`%labels`** — update your name and a description
5. **`%help`** — write the run command for your specific image

That is all that is needed for most research workflows.