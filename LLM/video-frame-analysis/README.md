# Video Frame Analysis with the ARC LLM API

This example demonstrates how to analyze a video using the ARC LLM API.

The ARC LLM API might not currently accept native `video_url` multimodal
content. Instead, this script:

1. Samples frames evenly across a video using FFmpeg.
2. Resizes and compresses the frames.
3. Encodes each frame as a base64 JPEG.
4. Sends the frames as multiple `image_url` inputs in a single
   `/chat/completions` request.
5. Asks the multimodal LLM to interpret the frames as one chronological video.

The script automatically reduces image quality, resolution, and eventually
frame count when necessary to keep the request below the configured payload
budget. (but the experiment we have tested this scripts a very good accuracy)

## Requirements

- Python 3.11+
- FFmpeg and ffprobe
- Access to `https://llm-api.arc.vt.edu`
- An ARC LLM API key

The script uses `uv` to install its Python dependency (`requests`)
automatically.

## Quick start

1. Create a `.env` file in the same directory as the script and add your ARC
   LLM API key:

```bash
touch .env
LLM_ARC_API_KEY="your-api-key"
```

2. Load the environment variables into your shell:

```bash
set -a
source .env
set +a
```

3. Run the script with a local video file:

```bash
python3 video_to_llm.py sample.mp4
```

4. Optional: extract frames and calculate request size without sending anything
   to the LLM API:

```bash
python3 video_to_llm.py sample.mp4 --dry-run
```

5. Optional: provide your own prompt:

```bash
python3 video_to_llm.py sample.mp4 \
  --prompt "Summarize the important events in this video."
```

6. Optional: limit the number of sampled frames:

```bash
python3 video_to_llm.py sample.mp4 --frames 30
```

7. Optional: analyze part of a video:

```bash
python3 video_to_llm.py sample.mp4 \
  --ss 60 \
  --duration 120
```
 8. incase of update to the model (use this)

```bash
python3 video_to_llm.py sample.mp4 \
  --model NEW_MODEL_NAME
```