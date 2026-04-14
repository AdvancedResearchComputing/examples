# Conversion Guide — Dockerfile to Definition File

Use this after running `spython recipe Dockerfile app.def` to verify
the output is correct before building on ARC.

The sample [`Dockerfile`](./Dockerfile) and [`app.def`](./app.def) in
this folder show the same environment side by side — use them as a
reference for what a correct conversion looks like.

---

## How Dockerfile instructions map to a definition file

| Dockerfile | Definition file | Notes |
|---|---|---|
| `FROM image:tag` | `Bootstrap: docker` + `From: image:tag` | First two lines of the `.def` |
| `RUN command` | Lines inside `%post` | All install commands go here |
| `ENV KEY=VALUE` | Lines inside `%environment` | Runtime variables |
| `COPY file /dest` | `%files` section | See note below |
| `LABEL key=value` | Lines inside `%labels` | Metadata |
| `CMD ["command"]` | `%runscript` | Default run command |
| `ENTRYPOINT [...]` | `%runscript` | Combined with CMD |

---

## What to check after conversion

**1. The header**

Should look like this:

```singularity
Bootstrap: docker
From: pytorch/pytorch:2.2.2-cuda12.1-cudnn8-runtime
```

If `Bootstrap:` or `From:` is missing or wrong, fix it manually —
this is the base image everything is built on.

**2. The `%post` section**

All your `RUN` commands should appear here. Check that:
- Nothing is missing compared to your original `Dockerfile`
- `apt-get clean` and `rm -rf /var/lib/apt/lists/*` are present if they
  were in the original — these keep the image size down

**3. The `%environment` section**

All your `ENV` variables should appear here. These are set every time
the container runs. If this section is missing, add it manually.

**4. `COPY` instructions — manual fix required**

`spython` converts `COPY` to a `%files` section:

```singularity
%files
    requirements.txt /tmp/requirements.txt
```
<!-- 
This works if the file exists in the same directory when you run
`apptainer build`. If you are building on ARC and the file is not
there, either:

- Place the file in the same directory as `app.def` before building, or
- Replace `COPY` with a `wget` inside `%post` to download the file
  from a URL -->

**5. `CMD` and `ENTRYPOINT` — optional**

Apptainer ignores `CMD` and `ENTRYPOINT` by default when you use
`apptainer exec`. The `%runscript` section only runs with
`apptainer run`. For batch jobs on ARC, this section does not matter.

---

## Side-by-side comparison

The sample files in this folder show a complete, working conversion:

**[`Dockerfile`](./Dockerfile)** — the original

<!-- ```dockerfile
FROM pytorch/pytorch:2.2.2-cuda12.1-cudnn8-runtime

RUN apt-get update && apt-get install -y \
    git wget build-essential \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    torchvision==0.17.2 \
    transformers==4.40.1 \
    numpy==1.26.4 \
    scipy==1.13.0 \
    pandas==2.2.2 \
    matplotlib==3.8.4
``` -->

**[`app.def`](./app.def)** — the converted definition file

<!-- ```singularity
Bootstrap: docker
From: pytorch/pytorch:2.2.2-cuda12.1-cudnn8-runtime

%post
    apt-get update && apt-get install -y \
        git wget build-essential \
     && apt-get clean && rm -rf /var/lib/apt/lists/*

    pip install --no-cache-dir \
        torchvision==0.17.2 \
        transformers==4.40.1 \
        numpy==1.26.4 \
        scipy==1.13.0 \
        pandas==2.2.2 \
        matplotlib==3.8.4

%environment
    export PYTHONDONTWRITEBYTECODE=1
    export PYTHONUNBUFFERED=1

%labels
    Author yourname@vt.edu
    Version 1.0

%help
    PyTorch 2.2.2 + CUDA 12.1 with torchvision, transformers,
    numpy, scipy, pandas, matplotlib.

    Usage:
        apptainer exec --nv my_image.sif python3 your_script.py
```

If your converted `app.def` looks structurally similar to the example
above, you are good to build. -->

---

## Common issues after conversion

**Missing `%environment` section**
`spython` sometimes omits this. Add it manually with any `ENV`
variables from your original Dockerfile.

**`%post` commands have wrong indentation**
Apptainer is not sensitive to indentation, but consistent indentation
makes the file easier to read. Fix with your editor.

**Multi-stage Dockerfiles**
`spython` partially supports multi-stage builds but may not handle them
perfectly. If your Dockerfile has multiple `FROM` lines, review the
output carefully and simplify if needed.