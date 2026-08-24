# Final Demo Recording Runbook

This runbook is the operational checklist for recording the final redcola
Quancheng Lab 2026 AxVisor contest video. The narrative script is in
`docs/demo-video-script.md`; the short Chinese cue card is
`docs/final-video-cue-card-cn.md`. This file keeps the recording gate
mechanical so the final video and package do not miss required proof.

## Recording Goal

The final video should show the complete scoring loop in about five minutes:

```text
AxVisor dual guest boot
Linux guest with 2 vCPUs
Zephyr RTOS guest with periodic control task
IPv4/UDP Linux-to-RTOS communication
QCZ1 reliable application protocol
AI inference output sent as CONTROL_SET
RTOS status/ACK returned
latency and packet-capture evidence
current-head 30000-sample long TAP proof
StarryOS bonus markers from PR #2
```

Use TAP mode for the final proof segment whenever possible because it shows
tcpdump packet counters and kernel drops. Hub mode is acceptable only as a
clearly labelled live rehearsal or fallback; it must not be presented as the
packet-captured TAP proof.

After recording, check the video against
`docs/final-demo-acceptance-checklist.md` before rebuilding the final package.

## Screen Layout

Use one screen with two terminals:

| Terminal | Purpose |
| --- | --- |
| Left | Run the AxVisor dual-guest command and analyzer. |
| Right | Show `docs/evidence-index.md`, `docs/scorecard-traceability.md`, result summaries and StarryOS bonus evidence. |

Before recording, close or hide windows that may show passwords, tokens,
private keys, personal chats or unrelated files.

## Narration Guardrails

Keep the final video confident but conservative:

```text
Say: 4-worker is an overcommit boundary and stability proof.
Do not say: 4-worker is the primary realtime-improvement row.

Say: StarryOS bonus is submitted separately as non-RT guest evidence.
Do not say: StarryOS has replaced Linux for the whole main AxVisor demo.

Say: Private mirror CI red marks can be caused by organization runner/container
limits, while runtime proof is from the submitted QEMU/TAP evidence.
Do not say: CI red marks are ignored without explaining the local evidence.
```

## Pre-Recording Gate

Run this in Kali before starting the screen recording:

```bash
REPO=/home/kali/qc-tgoskits-final-sync-220af-20260820
cd "${REPO}"
git branch --show-current || true
git status --short
git rev-parse HEAD

cd os/axvisor/contest/quancheng2026
sudo -v
```

Expected:

```text
PR branch is contest/axvisor-2026; the runtime worktree may be detached
runtime source commit is printed by git rev-parse HEAD
no unexpected tracked source changes
sudo returns to the shell prompt without showing a password on screen
```

If `sudo -v` asks for the password, type it once before starting the video.
Do not record the password entry.

## Preferred TAP Recording Command

Run this in the left terminal during the live reproduction segment:

```bash
./scripts/run_final_demo_recording.sh
```

The helper runs the following explicit configuration so the command remains
auditable in the recording and documentation:

```bash
EVIDENCE_DIR=/tmp/qc_demo_final_tap_$(date +%Y%m%d_%H%M%S)

./scripts/run_axvisor_dual_guest_qcz1_ai.sh \
  --net-mode tap \
  --evidence-dir "${EVIDENCE_DIR}" \
  --timeout 180 \
  --linux-rt-samples 3000 \
  --linux-rt-period-ns 10000000 \
  --linux-stress-workers 2 \
  --linux-stress-seconds 0 \
  --linux-rt-cpu 0 \
  --linux-stress-cpu 1 \
  --linux-quiet
```

Required live markers:

```text
result=PASS
QC_DUAL_GUEST_LINUX_INIT=PASS
QC_UDP_SUCCESSES=20
QC_QCZ1_RELIABLE_SUCCESSES=10
QC_QCZ1_RETRANSMITS=0
QC_AI_SUCCESSES=10
QC_AI_CONTROL_RESULT=PASS
QC_RTOS_PERIODIC_RESULT=PASS
packets captured
0 packets dropped by kernel
```

## Post-Run Report Commands

After the live run finishes, keep recording and run:

```bash
./scripts/analyze_dual_guest_realtime.py "${EVIDENCE_DIR}" --fail-on-missing
sed -n '1,180p' "${EVIDENCE_DIR}/realtime-report.md"
cat "${EVIDENCE_DIR}/realtime-summary.json"
```

Then show the strongest already-collected task-one evidence:

```bash
sed -n '1,160p' results/task-one-before-after-tap-summary.md
column -s, -t results/task-one-before-after-tap-summary.csv | sed -n '1,8p'
sed -n '1,120p' results/task-one-current-head-long-tap-r30000-summary.md
sed -n '1,120p' results/task-one-current-head-long-tap4-r30000-summary.md
sed -n '1,140p' results/task-one-latestdev-isolated-p10ms-stability-3x-summary.md
sed -n '1,120p' results/task-one-second-version-summary.md
sed -n '1,140p' docs/task-one-score-summary.md
```

## Time-Slip Priority

If the live run takes longer than expected, keep these items on screen in this
order and skip lower-priority commentary:

1. Final `result=PASS` and UDP/QCZ1/AI counters.
2. TAP/tcpdump captured packets and kernel drops `0`, or the recorded `88/0`
   TAP proof if the live run used hub mode.
3. Task-one p99/max and before/after summary.
4. AI closed-loop latency and manual-baseline comparison.
5. StarryOS bonus PASS markers.
6. Package verification and SHA256 sidecar.

## Hub Fallback Rule

If TAP cannot be used during the live recording, do not keep retrying on video.
Run the hub fallback and label it verbally as a live rehearsal:

```bash
EVIDENCE_DIR=/tmp/qc_demo_final_hub_$(date +%Y%m%d_%H%M%S)

./scripts/run_axvisor_dual_guest_qcz1_ai.sh \
  --net-mode hub \
  --evidence-dir "${EVIDENCE_DIR}" \
  --timeout 150 \
  --linux-rt-samples 3000 \
  --linux-rt-period-ns 10000000 \
  --linux-stress-workers 2 \
  --linux-stress-seconds 0 \
  --linux-rt-cpu 0 \
  --linux-stress-cpu 1 \
  --linux-quiet
```

Then show the recorded TAP/tcpdump before/after proof from the result summary:

```bash
sed -n '1,180p' results/task-one-before-after-tap-summary.md
sed -n '1,120p' results/task-one-current-head-long-tap-r30000-summary.md
sed -n '1,120p' results/task-one-current-head-long-tap4-r30000-summary.md
sed -n '1,140p' results/task-one-latestdev-isolated-p10ms-stability-3x-summary.md
```

Say clearly:

```text
The live run is hub-mode rehearsal evidence. The packet-captured TAP proof is
the recorded before/after matrix shown in the submitted result summary.
```

## StarryOS Bonus Segment

Show the StarryOS bonus material from PR `#2`:

```bash
(git show qcl/contest/starry-redcola-ai-bonus-clean-20260731:apps/starry/qemu/redcola-ai-control/VALIDATION.md 2>/dev/null || \
 git show origin/contest/starry-redcola-ai-bonus-clean-20260731:apps/starry/qemu/redcola-ai-control/VALIDATION.md) | sed -n '1,160p'
```

Required markers:

```text
REDCOLA_STARRY_QCZ1_PARITY_PASS
REDCOLA_STARRY_AI_CONTROL_PASS
REDCOLA_STARRY_AI_DONE
```

Keep the scope statement visible or spoken: this is StarryOS non-RT guest
bonus evidence, while the full Linux/RTOS network closed loop remains in the
main AxVisor PR.

## After Recording

Save the video as:

```text
redcola-axvisor-demo.mp4
```

Build, verify, ZIP and fresh-extract the final package in one command:

```bash
cd "${REPO}/os/axvisor/contest/quancheng2026"

./scripts/finalize_final_submission.sh \
  --out /tmp/redcola-final-package-$(date +%Y%m%d_%H%M%S) \
  --evidence-dir "${EVIDENCE_DIR}" \
  --starry-dir /path/to/apps/starry/qemu/redcola-ai-control \
  --starry-latest-validation /path/to/LATESTDEV-VALIDATION.txt \
  --video /path/to/redcola-axvisor-demo.mp4 \
  --presentation /path/to/redcola-AxVisor-5分钟演示.pptx \
  --narration-script /path/to/redcola-AxVisor-5分钟配音稿.docx
```

Required final markers are `FINAL_VIDEO_VERIFY=PASS`,
`FINAL_PACKAGE_VERIFY=PASS`, `FINAL_SUBMISSION_FRESH_UNZIP_VERIFY=PASS` and
`FINAL_SUBMISSION_FINALIZE=PASS`. The video gate accepts 240 to 360 seconds and
requires both a video stream and a narration audio stream.

Record the final SHA-256 values from the generated `SHA256SUMS.txt` and the
final archive or upload package. The authoritative hash for the 2026-08-24
submission must come from the selected final head, not from an older dry run.

## Final Video Acceptance Gate

Do not submit the final video until all items below are visible or explicitly
covered:

| Gate | Required evidence |
| --- | --- |
| Deployment | AxVisor starts Linux and Zephyr RTOS guests in one run. |
| Linux multicore | Linux guest reports `2` vCPUs. |
| IP network | Linux/RTOS IPv4 addresses and UDP port are shown. |
| Plain UDP | `20/20` success marker is shown. |
| QCZ1 | `10/10`, retransmit count and status/error validation are shown. |
| AI loop | AI inference, RTOS control update and status return are shown. |
| Realtime | Linux/RTOS periodic report, before/after summary and current-head `30000`-sample 2-worker/4-worker long TAP rows are shown. |
| TAP capture | tcpdump captured packets and `0` kernel drops are shown, or a recorded TAP summary is shown separately from any hub fallback; the submitted long TAP proofs should show captured/dropped `88/0`. |
| StarryOS bonus | StarryOS QCZ1 parity and AI-control markers are shown. |
| Reproducibility | Evidence directory, analyzer output and final package verifier are shown or included. |
