#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["requests"]
# ///
"""Ask a vision model one question about a whole video, via evenly sampled frames.

The video is sampled down to a fixed frame budget, the frames are inlined as
base64 data URLs in a single chat/completions request, and the model answers one
video-level question. The reply is streamed: the answer prints on stdout as it is
generated, and the model's reasoning phase goes to stderr so a long think is
visible rather than looking like a hang. Nothing is sent to the /api/v1/files/
upload endpoint, so no copy of a frame persists server-side beyond the request.

  ./video_to_llm.py clip.mp4
  ./video_to_llm.py clip.mp4 -n 90 -p "What is the mood of this scene?"
  ./video_to_llm.py https://example.com/movie.mp4 --ss 60 --duration 120

Requires ffmpeg/ffprobe on PATH and LLM_ARC_API_KEY in the environment.
"""

from __future__ import annotations

import argparse
import base64
import json
import os
import shutil
import subprocess
import sys
import time
from dataclasses import dataclass, field
from pathlib import Path

import requests

URL = "https://llm-api.arc.vt.edu/api/v1/chat/completions"

# Tried in order when the request body is over budget. Quality degrades before
# width, and both degrade before any frame is dropped: temporal coverage is the
# point of the sampling, per-frame detail is the cheap thing to spend.
LADDER: list[tuple[int, int]] = [
    (0, 4), (0, 7), (0, 12), (0, 20),          # 0 = keep the requested width
    (384, 6), (384, 12), (256, 8), (256, 16),
]
MIN_FRAMES = 8

PROMPT = (
    "The images are {n} frames sampled evenly across a {duration:.0f}-second video, "
    "in chronological order; each is labelled with its timestamp. Treat them as one "
    "video rather than as separate pictures. What happens in it?"
)


class PipelineError(RuntimeError):
    """A stage failed in a way the user needs to read, not a traceback."""


@dataclass
class Frames:
    paths: list[Path]
    timestamps: list[float]
    width: int
    quality: int
    reductions: list[str] = field(default_factory=list)


def run_ff(cmd: list[str]) -> str:
    proc = subprocess.run(cmd, capture_output=True, text=True)
    if proc.returncode != 0:
        raise PipelineError(f"{cmd[0]} failed:\n{proc.stderr.strip()[-2000:]}")
    return proc.stdout


def probe(source: str) -> tuple[float, int, int]:
    """Return (duration_seconds, width, height) for a local path or URL."""
    out = run_ff([
        "ffprobe", "-v", "error", "-select_streams", "v:0",
        "-show_entries", "stream=width,height", "-show_entries", "format=duration",
        "-of", "json", source,
    ])
    meta = json.loads(out)
    if not meta.get("streams"):
        raise PipelineError(f"no video stream in {source}")
    stream = meta["streams"][0]
    duration = float(meta["format"]["duration"])
    if duration <= 0:
        raise PipelineError(f"unusable duration ({duration}s) for {source}")
    return duration, int(stream["width"]), int(stream["height"])


def localize(source: str, work: Path, ss: float, duration: float | None) -> Path:
    """Copy the segment of interest to disk so re-encoding never refetches it.

    Stream-copied, so this is a byte-level trim: no decode, no quality loss.
    """
    local = work / "source.mp4"
    cmd = ["ffmpeg", "-y", "-hide_banner", "-loglevel", "error"]
    if ss:
        cmd += ["-ss", str(ss)]
    if duration is not None:
        cmd += ["-t", str(duration)]
    cmd += ["-i", source, "-c", "copy", "-map", "0:v:0", "-map", "0:a?", str(local)]
    run_ff(cmd)
    if not local.exists() or local.stat().st_size == 0:
        raise PipelineError(f"could not extract a segment from {source}")
    return local


def extract(video: Path, out: Path, count: int, duration: float, width: int, quality: int) -> Frames:
    """Sample `count` frames spread evenly across `duration` seconds."""
    if out.exists():
        shutil.rmtree(out)
    out.mkdir(parents=True)

    fps = count / duration
    vf = f"fps={fps:.10f}"
    if width:
        vf += f",scale={width}:-2:flags=lanczos"
    run_ff([
        "ffmpeg", "-y", "-hide_banner", "-loglevel", "error", "-i", str(video),
        "-vf", vf, "-frames:v", str(count), "-q:v", str(quality),
        str(out / "frame_%04d.jpg"),
    ])

    paths = sorted(out.glob("*.jpg"))
    if not paths:
        raise PipelineError(f"ffmpeg produced no frames from {video}")
    # The fps filter takes the frame nearest each 1/fps boundary, so nominal
    # timestamps are accurate to about half a sampling interval.
    step = duration / count
    return Frames(paths, [i * step for i in range(len(paths))], width, quality)


def build_payload(model: str, prompt: str, frames: Frames) -> dict:
    content: list[dict] = [{"type": "text", "text": prompt}]
    for path, ts in zip(frames.paths, frames.timestamps):
        b64 = base64.b64encode(path.read_bytes()).decode("ascii")
        content.append({"type": "text", "text": f"[t={ts:.1f}s]"})
        content.append({"type": "image_url", "image_url": {"url": f"data:image/jpeg;base64,{b64}"}})
    return {
        "model": model,
        "messages": [{"role": "user", "content": content}],
        "stream": True,
        "stream_options": {"include_usage": True},
    }


def body_bytes(payload: dict) -> int:
    return len(json.dumps(payload).encode())


def fit(video: Path, out: Path, count: int, duration: float, width: int,
        model: str, prompt_tpl: str, limit: int) -> tuple[Frames, dict, str]:
    """Shrink quality, then width, then frame count until the body fits `limit`."""
    reductions: list[str] = []
    n = count

    while n >= MIN_FRAMES:
        for ladder_width, quality in LADDER:
            w = width if ladder_width == 0 else min(ladder_width, width)
            frames = extract(video, out, n, duration, w, quality)
            frames.reductions = list(reductions)
            prompt = prompt_tpl.format(n=len(frames.paths), duration=duration)
            payload = build_payload(model, prompt, frames)
            size = body_bytes(payload)
            if size <= limit:
                return frames, payload, prompt
            reductions.append(f"{len(frames.paths)} frames @ {w}px q{quality} = {size/2**20:.1f}MiB, over budget")
        n = max(MIN_FRAMES, n // 2)
        if n == MIN_FRAMES and reductions and reductions[-1].startswith(f"{MIN_FRAMES} "):
            break

    raise PipelineError(
        f"cannot fit under {limit/2**20:.0f}MiB even at {MIN_FRAMES} frames / 256px.\n"
        + "\n".join("  " + r for r in reductions[-4:])
    )


def ask(api_key: str, payload: dict, timeout: int) -> tuple[int, float, str, dict | None]:
    """Stream the completion, printing deltas as they arrive.

    Returns (status, elapsed, full_text, usage). The server sends SSE frames; a
    non-200 comes back as one ordinary JSON body instead, so that case is read
    whole and returned as the error text.

    vLLM sends `delta.reasoning` for thinking models before any `delta.content`.
    That phase can run a hundred tokens with nothing to show, so it goes to
    stderr as it arrives: stdout stays the answer alone and remains pipeable.
    """
    started = time.monotonic()
    with requests.post(
        URL,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "Accept": "text/event-stream",
        },
        data=json.dumps(payload),
        timeout=timeout,
        stream=True,
    ) as resp:
        if not resp.ok:
            body = resp.text[:4000]
            try:
                body = json.dumps(resp.json(), indent=2)[:4000]
            except ValueError:
                pass
            return resp.status_code, time.monotonic() - started, body, None

        chunks: list[str] = []
        thinking: list[str] = []
        usage: dict | None = None
        for line in resp.iter_lines(decode_unicode=True):
            if not line or not line.startswith("data:"):
                continue
            data = line[5:].strip()
            if data == "[DONE]":
                break
            try:
                event = json.loads(data)
            except ValueError:
                continue
            if event.get("usage"):
                usage = event["usage"]
            for choice in event.get("choices") or []:
                delta = choice.get("delta") or {}
                reason = delta.get("reasoning") or delta.get("reasoning_content")
                if reason:
                    if not thinking:
                        print("thinking ", end="", file=sys.stderr, flush=True)
                    thinking.append(reason)
                    print(reason, end="", file=sys.stderr, flush=True)
                piece = delta.get("content")
                if piece:
                    if thinking and not chunks:
                        print("\n", file=sys.stderr, flush=True)
                    chunks.append(piece)
                    print(piece, end="", flush=True)

    elapsed = time.monotonic() - started
    text = "".join(chunks)
    if not text:
        return resp.status_code, elapsed, "(empty stream: no content deltas received)", usage
    return resp.status_code, elapsed, text, usage


def resp_ok(status: int) -> bool:
    return 200 <= status < 300


def main() -> int:
    # Deltas are useless if the pipe holds them: force line buffering so the
    # answer appears as it arrives even when stdout is a file or a pipe.
    sys.stdout.reconfigure(line_buffering=True)

    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("source", help="video file or URL")
    ap.add_argument("-n", "--frames", type=int, default=60, help="frame budget (default 60)")
    ap.add_argument("-p", "--prompt", help="override the default video-level question")
    ap.add_argument("-m", "--model", default="DeepSeek-V4-Flash-thinking-low",
                    help="default DeepSeek-V4-Flash-thinking-low: the plain id spends "
                         "hundreds of reasoning tokens re-reading individual frames")
    ap.add_argument("-o", "--out", type=Path, help="output dir (default <video stem>_run)")
    ap.add_argument("-w", "--width", type=int, default=512, help="max frame width (default 512)")
    ap.add_argument("--ss", type=float, default=0.0, help="start offset in seconds")
    ap.add_argument("--duration", type=float, help="seconds to use from --ss (default: to end)")
    ap.add_argument("--max-body-mib", type=float, default=8.0, help="request body budget (default 8)")
    ap.add_argument("--timeout", type=int, default=900)
    ap.add_argument("--dry-run", action="store_true", help="extract and size the body, send nothing")
    args = ap.parse_args()

    api_key = os.environ.get("LLM_ARC_API_KEY", "")
    if not api_key and not args.dry_run:
        raise SystemExit("set LLM_ARC_API_KEY (llm.arc.vt.edu > Settings > Account > API keys)")
    for tool in ("ffmpeg", "ffprobe"):
        if shutil.which(tool) is None:
            raise SystemExit(f"{tool} not found on PATH")
    if args.frames < MIN_FRAMES:
        raise SystemExit(f"--frames must be at least {MIN_FRAMES}")

    stem = Path(args.source.split("?")[0]).stem or "video"
    out = args.out or Path(f"{stem}_run")
    out.mkdir(parents=True, exist_ok=True)

    try:
        src_duration, src_w, src_h = probe(args.source)
        span = min(args.duration or src_duration, src_duration - args.ss)
        if span <= 0:
            raise PipelineError(f"--ss {args.ss}s is past the end of a {src_duration:.1f}s video")
        print(f"source   {args.source}\n         {src_w}x{src_h}, {src_duration:.1f}s; using {span:.1f}s from {args.ss:.1f}s")

        local = localize(args.source, out, args.ss, span) if (args.ss or args.duration or "://" in args.source) else Path(args.source)
        frames, payload, prompt = fit(
            local, out / "frames", args.frames, span, args.width,
            args.model, args.prompt or PROMPT, int(args.max_body_mib * 2**20),
        )
    except PipelineError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    size = body_bytes(payload)
    for note in frames.reductions:
        print(f"reduced  {note}")
    print(f"frames   {len(frames.paths)} @ {frames.width}px q{frames.quality}, "
          f"1 per {span/len(frames.paths):.2f}s -> {out/'frames'}")
    print(f"request  {size/2**20:.2f}MiB, model={args.model}")

    record = {
        "source": args.source, "model": args.model, "prompt": prompt,
        "source_duration_s": src_duration, "source_resolution": [src_w, src_h],
        "span_s": span, "start_s": args.ss,
        "frame_count": len(frames.paths), "frame_width": frames.width,
        "jpeg_quality": frames.quality, "reductions": frames.reductions,
        "timestamps_s": [round(t, 3) for t in frames.timestamps],
        "request_body_bytes": size,
    }

    if args.dry_run:
        (out / "run.json").write_text(json.dumps(record, indent=2) + "\n")
        print("dry run: nothing sent")
        return 0

    print("answer")
    status, elapsed, text, usage = ask(api_key, payload, args.timeout)
    record.update({
        "status": status, "elapsed_s": round(elapsed, 2), "answer": text,
        "usage": usage,
    })
    (out / "run.json").write_text(json.dumps(record, indent=2) + "\n")

    if not resp_ok(status):
        print(text, file=sys.stderr)
    print(f"\n\nstatus   {status}, {elapsed:.1f}s")
    print(f"[run record: {out/'run.json'}]")
    return 0 if resp_ok(status) else 1


if __name__ == "__main__":
    sys.exit(main())
