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