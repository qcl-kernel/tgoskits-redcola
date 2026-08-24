# Final Video Proof

This note records the authoritative user-recorded and user-narrated video
included in the 2026-08-24 redcola final delivery.

## Final User-Narrated Video

| Item | Value |
| --- | --- |
| Status | `PASS - USER RECORDED AND NARRATED` |
| Package path | `video/redcola-axvisor-demo.mp4` |
| Container | `mov,mp4,m4a,3gp,3g2,mj2` |
| Duration | `385.079002` seconds |
| Duration gate | `240..420` seconds |
| Size | `32056040` bytes |
| Video | H.264, `2560x1600`, `20 fps` |
| Audio | AAC, `44100 Hz`, stereo |
| SHA256 | `20a15f735f446595ad48cb15872d39c2dec0ce2e9107c450a8f59cc2017629ba` |
| Full decode | `PASS` |
| Packaged metadata | `video/METADATA.txt` |

The team leader recorded and narrated this final video. `ffprobe` confirmed
both video and narration streams, `scripts/verify_demo_video.py` accepted the
duration and streams, and a complete `ffmpeg` decode reached the end without
an error.

## Visible Evidence

The final presentation follows the scoring flow: architecture and isolation,
merged AxVisor support, the 30000-sample task-one run, before/after and
native-RTOS comparisons, QCZ1 reliability, the AI control loop, StarryOS bonus
evidence and final delivery gates.

The dual-terminal section shows Zephyr/RTOS UDP receive and control output
alongside the two-vCPU Linux guest, UDP/QCZ1 requests, AI inference,
ACK/STATUS replies and final PASS markers. The displayed runtime data is tied
to the latest-`dev` evidence summaries included in the submission.

## Verification

```text
FINAL_VIDEO_PATH=redcola-axvisor-demo.mp4
FINAL_VIDEO_DURATION_SECONDS=385.079
FINAL_VIDEO_SIZE_BYTES=32056040
FINAL_VIDEO_CODEC=h264
FINAL_VIDEO_DIMENSIONS=2560x1600
FINAL_VIDEO_FPS=20/1
FINAL_AUDIO_CODEC=aac
FINAL_AUDIO_CHANNELS=2
FINAL_VIDEO_SHA256=20a15f735f446595ad48cb15872d39c2dec0ce2e9107c450a8f59cc2017629ba
FINAL_VIDEO_VERIFY=PASS
VIDEO_FULL_DECODE=PASS
```

The video was checked against:

```text
docs/final-demo-acceptance-checklist.md
docs/demo-video-script.md
docs/final-video-cue-card-cn.md
docs/final-demo-recording-runbook.md
```

The MP4 hash above identifies the exact file in the private repository. The
whole result directory is independently covered by `SHA256SUMS.txt`.
