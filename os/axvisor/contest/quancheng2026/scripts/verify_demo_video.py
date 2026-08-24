#!/usr/bin/env python3
"""Verify the final user-narrated demo video with ffprobe."""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import subprocess
import sys
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("video", type=Path)
    parser.add_argument("--min-seconds", type=float, default=240.0)
    parser.add_argument("--max-seconds", type=float, default=420.0)
    parser.add_argument("--output", type=Path, help="Write the PASS metadata to this file.")
    return parser.parse_args()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def fail(message: str) -> int:
    print(message, file=sys.stderr)
    print("FINAL_VIDEO_VERIFY=FAIL")
    return 1


def main() -> int:
    args = parse_args()
    video = args.video.resolve()
    if not video.is_file() or video.stat().st_size == 0:
        return fail(f"video_missing_or_empty={video}")

    ffprobe = shutil.which("ffprobe")
    if not ffprobe:
        return fail("missing_required_tool=ffprobe")

    command = [
        ffprobe,
        "-v",
        "error",
        "-show_entries",
        "format=duration,size,format_name:stream=index,codec_type,codec_name,width,height,avg_frame_rate,sample_rate,channels",
        "-of",
        "json",
        str(video),
    ]
    try:
        metadata = json.loads(subprocess.check_output(command, text=True))
    except (subprocess.CalledProcessError, json.JSONDecodeError) as exc:
        return fail(f"ffprobe_failed={exc}")

    try:
        duration = float(metadata["format"]["duration"])
    except (KeyError, TypeError, ValueError):
        return fail("video_duration_missing")

    streams = metadata.get("streams", [])
    video_streams = [item for item in streams if item.get("codec_type") == "video"]
    audio_streams = [item for item in streams if item.get("codec_type") == "audio"]
    if not video_streams:
        return fail("video_stream_missing")
    if not audio_streams:
        return fail("audio_stream_missing_user_narration_required")
    if not args.min_seconds <= duration <= args.max_seconds:
        return fail(
            f"video_duration_out_of_range={duration:.3f};"
            f"expected={args.min_seconds:.0f}..{args.max_seconds:.0f}"
        )

    video_stream = video_streams[0]
    audio_stream = audio_streams[0]
    lines = [
        f"FINAL_VIDEO_PATH={video.name}",
        f"FINAL_VIDEO_DURATION_SECONDS={duration:.3f}",
        f"FINAL_VIDEO_SIZE_BYTES={video.stat().st_size}",
        f"FINAL_VIDEO_CODEC={video_stream.get('codec_name', 'unknown')}",
        "FINAL_VIDEO_DIMENSIONS="
        f"{video_stream.get('width', 'unknown')}x{video_stream.get('height', 'unknown')}",
        f"FINAL_VIDEO_FPS={video_stream.get('avg_frame_rate', 'unknown')}",
        f"FINAL_AUDIO_CODEC={audio_stream.get('codec_name', 'unknown')}",
        f"FINAL_AUDIO_CHANNELS={audio_stream.get('channels', 'unknown')}",
        f"FINAL_VIDEO_SHA256={sha256_file(video)}",
        "FINAL_VIDEO_VERIFY=PASS",
    ]
    output = "\n".join(lines) + "\n"
    print(output, end="")
    if args.output:
        args.output.resolve().write_text(output, encoding="utf-8", newline="\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
