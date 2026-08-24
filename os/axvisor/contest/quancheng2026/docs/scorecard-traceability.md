# Scorecard Traceability Matrix

This document maps the Quancheng Lab 2026 AxVisor contest requirements to the
current redcola evidence set. It is written as a reviewer-facing checklist so
the final PR, weekly report and demo can point to one compact source of truth.

## Reviewer Fast Path

For the current staged-review checkpoint, review the material in this order:

1. `docs/final-defense-brief-cn.md` for the one-page Chinese final defense
   path, safe wording and score-oriented evidence map.
2. `docs/final-demo-acceptance-checklist.md` for the final-video hard gates
   that must be visible before the 2026-08-24 upload.
3. `docs/final-video-proof.md` for the superseded draft MP4 metadata and the
   hard gate that the selected user-narrated final recording must pass.
4. `docs/first-version-submission-status.md` for repository links, PRs,
   submitted paths, representative PASS markers and known remaining work.
5. `docs/evidence-index.md` for the compact source/test/runtime evidence map.
6. `docs/second-version-reviewer-quickstart.md` for the compact
   second-version review path, exact branch heads and current scoring gates.
7. `docs/task-one-reviewer-defense-qna.md` for the short task-one defense
   path and safe wording.
8. `docs/task-one-realtime-core-claim.md` for the exact task-one AxVisor
   timer/interrupt claim and its conservative before/after interpretation.
9. `docs/task-one-30-point-checklist.md` for the task-one 30-point scoring
   coverage table.
10. `docs/physical-board-native-linux-baseline.md` for the conservative
    ATK-DLRK3588B native-Linux pressure reference and claim boundary.
11. `docs/second-version-submission-status.md` for the current task-one
    second-version status, TAP/tcpdump gate and exact matrix commands.
12. `docs/engineering-innovation-20-point-checklist.md` for engineering
    completeness and system innovation scoring.
13. `docs/design.md` for the system architecture, guest roles, isolation
    boundary and AI/control deployment.
14. `docs/test-report.md` for the startup, communication, realtime, AI and
    stability PASS gates.
15. `docs/reproduce.md` for the clean-environment build/run entry points and
    runtime artifact contract.
16. `docs/starryos-bonus.md` for the separate StarryOS AI-control bonus scope.
17. This scorecard for requirement-to-evidence mapping.

The main branch is `contest/axvisor-2026` in the private repository
`qcl-kernel/tgoskits-redcola`; use PR `#1` for the moving branch head and the
generated package `README.txt` plus sibling `.zip.sha256` file for the exact
archive identity. The StarryOS bonus branch is kept as a separate PR so that
the main AxVisor artifact remains easy to review.

## Executive Status

| Area | Status | Primary evidence |
| --- | --- | --- |
| Task One realtime | PASS, strengthening | `docs/task-one-realtime-core-claim.md`, `docs/task-one-30-point-checklist.md`, `docs/realtime-evaluation.md`, `docs/task-one-second-version-plan.md`, before/after 10000-sample hub matrix, current-head 30000-sample 2-worker hub and TAP/tcpdump rows, current-head 30000-sample 4-worker hub and TAP/tcpdump overcommit rows, recorded `a9ceb7dc` 30000-sample 2-worker hub proof, native Zephyr latency baseline and 0/1/2/4-worker dual-guest runs |
| Task Two IP communication | PASS | `docs/task-two-three-50-point-checklist.md`, `docs/protocol.md`, `docs/network-topology.md`, Linux client scripts, Zephyr e1000 RTOS path, tcpdump counters |
| Task Three AI closed loop | PASS | `docs/task-two-three-50-point-checklist.md`, `docs/ai-control-evaluation.md`, `linux/qc_ai_control_demo.py`, integrated QCZ1 AI run summaries |
| StarryOS bonus | BONUS EVIDENCE | `docs/starryos-bonus.md`, `docs/starryos-bonus-scorecard.md`, private PR `#2`, `apps/starry/qemu/redcola-ai-control/` |
| Engineering and innovation | PASS | `docs/engineering-innovation-20-point-checklist.md`, `docs/reproduce.md`, downloadable-artifact integrated runner, analyzer scripts, SHA256 evidence records and verified checkpoint package |
| Submission boundary | READY | `docs/commit-plan.md`, `docs/pr-boundary.md`, contest dry-run path check, private PR `#1`/`#2` and external package SHA256 sidecar |

## Second-Version Scoring Strategy

For the 2026-08-21 checkpoint, the safest score increase is to strengthen the
task-one evidence while preserving the already-working task-two and task-three
paths.

| Area | Current reviewer position | Next proof that raises confidence |
| --- | --- | --- |
| Task one realtime | First-version gap has been materially reduced for the second-version checkpoint. | TAP/tcpdump before/after matrix on current branch and pre-`#1770` baseline is complete. Current-head `30000`-sample hub/TAP 2-worker long-pressure rows and hub/TAP 4-worker overcommit rows are committed in `results/`; the long TAP proofs report `TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS` and tcpdump captured/dropped `88/0`, while the 4-worker hub proof reports `TASK_ONE_CURRENT_HEAD_LONG_HUB4_PROOF=PASS`. The 4-worker TAP row adds packet-captured overcommit evidence with UDP `20/20`, QCZ1 `10/10` and AI `10/10`. Recorded head `a9ceb7dc` also has a fresh 30000-sample 2-worker hub row with RTOS p99/max `1.115 ms / 5.921 ms`. |
| Task two communication | Strong and reproducible. | Keep QCZ1 status/error/retry evidence stable, point reviewers to `docs/task-two-three-50-point-checklist.md`, and show packet-capture counters in final video. |
| Task three AI loop | Strong closed-loop evidence. | Use `docs/task-two-three-50-point-checklist.md` and the final video to show AI input, inference output, QCZ1 send, RTOS state update and returned status in one continuous run. |
| StarryOS bonus | Separate bonus PR is present. | Keep it separate, show PASS markers, point reviewers to `docs/starryos-bonus-scorecard.md`, and avoid claiming syscall/ABI work that is not part of this branch. |
| Final packaging | Build and verification scripts pass dry runs; the verified package includes video material, StarryOS bonus notes, StarryOS scorecard, task-one reviewer defense Q&A and exact-head stability summaries. | Use the generated package `README.txt` for the exact archived main head and the sibling external `.zip.sha256` file for the exact ZIP hash; regenerate once from the selected 2026-08-24 final head. |

## Task One: Realtime Modification and Validation

| Requirement | Current evidence | Reviewer note |
| --- | --- | --- |
| Improve AxVisor realtime-related paths | Core patch candidates split into VM config + vTimer, GIC EOI mode, bounded diagnostics and axbuild helper. | `docs/task-one-realtime-core-claim.md` states the precise timer/interrupt claim; `docs/core-patch-review.md` explains patch order and risk; `docs/task-one-second-version-plan.md` identifies PR `#1770` as the main landed timer/interrupt support anchor and records the 10000-sample before/after hub comparison. |
| Boot a multi-vCPU Linux guest | Integrated run reports Linux guest `2` vCPUs online. | `docs/design.md` records the guest placement and the Linux guest role. |
| Describe vCPU/physical CPU binding, memory, devices, interrupts and boot args | Guest and topology docs describe Linux `2` vCPU setup, the per-run isolated TAP/bridge network, virtio-net, Zephyr e1000, interrupt route and `noirqdebug` run. | See `docs/design.md`, `docs/network-topology.md` and `docs/realtime-evaluation.md`. |
| Measure periodic jitter, scheduling latency, interrupt responsiveness, max latency and stability | Linux 1 ms periodic probe, RTOS 1 ms periodic probe, 0/1/2/4-worker stress runs, 2-worker 3-run stability campaign, before/after 10000-sample hub matrix, current-head 30000-sample 2-worker hub and TAP/tcpdump rows, current-head 30000-sample 4-worker hub and TAP/tcpdump overcommit rows and TAP/tcpdump before/after matrix are recorded. | Main comparison tables are `results/realtime-comparison.csv`, `results/task-one-before-after-hub-summary.csv`, `results/task-one-before-after-tap-summary.csv`, `results/task-one-current-head-long-hub-r30000-summary.csv`, `results/task-one-current-head-long-hub4-r30000-summary.csv`, `results/task-one-current-head-long-tap-r30000-summary.csv` and `results/task-one-current-head-long-tap4-r30000-summary.csv`; the current-head long TAP rows record `TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS`, `88/0` tcpdump counters and AI mean/max `2501 / 5014 us` for 2 workers plus `5277 / 15431 us` for 4 workers; the 4-worker hub row records UDP `20/20`, QCZ1 `10/10`, AI `10/10`, RTOS p99/max `1143440 / 5372880 ns` and AI mean/max `3428 / 7887 us`; `docs/task-one-score-summary.md` gives the compact delta view; stability summary is `results/stability/2026-07-27-stress2-3x/stability-summary.md`; long before/after rows, the long current-head pressure rows, the 4-worker boundary and the completed TAP/tcpdump gate are tracked in `docs/task-one-second-version-plan.md` and `docs/second-version-submission-status.md`. |
| Compare against native RTOS baseline | Native Zephyr latency baseline passed with 47 metrics, including context switch `2400 ns` and max primitive latency `46703 ns`. | Platform differences and measurement limits are documented in `docs/realtime-evaluation.md`. |
| Add physical-platform pressure reference | ATK-DLRK3588B native Linux cyclictest: `900000` total cycles; idle/isolated/full-pressure maximum latency `95/76/1338 us`; zero histogram overflows. | `docs/physical-board-native-linux-baseline.md` and generated summaries. This is a host-platform reference only, not AxVisor-on-RK3588 evidence. |
| Provide reproducible branch, images, configs, commands and scripts | Reproduction commands and evidence paths are listed in `docs/reproduce.md`. | Large images and raw evidence archives stay outside the source commit and are referenced by path/SHA256. |

## Task Two: Linux/RTOS IP Communication

| Requirement | Current evidence | Reviewer note |
| --- | --- | --- |
| Use IP protocol stack as the main data channel | The main channel is IPv4/UDP over a per-run isolated TAP/bridge network, with Linux virtio-net and Zephyr e1000. | `docs/network-topology.md` states that shared memory, HyperCall, MMIO and vsock are not the primary data path. |
| Provide bidirectional Linux/RTOS application protocol | QCZ1 supports command, state reply and error/fault style response frames. | Full frame format is in `docs/protocol.md`. |
| Include version, type, payload length, sequence/timestamp and checksum/error field | QCZ1 frame includes magic/version/type/flags/header length/payload length/sequence/timestamp/status/checksum. | This directly addresses the protocol-field checklist. |
| Reliability for UDP | Linux client supports ACK handling, timeout, retry, duplicate ACK accounting and response validation. | Integrated runs report `10/10 PASS`, duplicate ACK count and retransmit count. |
| Document topology, MAC/IP, route, port and access boundary | Linux `192.0.2.10`, Zephyr `192.0.2.20`, UDP `4242`, bridge/TAP layout and no-NAT boundary are documented. | `docs/network-topology.md` is the reviewer entry point. |
| Report success rate, errors, timeouts, recovery, latency and throughput/counters | Plain UDP `20/20`, QCZ1 `10/10`, retransmits `0`, RTOS `STATUS` error count `0`, tcpdump `0` kernel drops, RTT summaries and conservative useful-throughput estimates are recorded across clean/stress/stability runs. | Main summaries are in `README.md`, `docs/test-report.md` and `results/CURRENT_STATUS_2026-07-26.md`. |

## Task Three: AI Model and Control Linkage

| Requirement | Current evidence | Reviewer note |
| --- | --- | --- |
| Deploy neural-network inference in Linux guest | Linux-side AI control demo uses a deterministic small MLP implemented in the static guest demo/client path. | The model is intentionally lightweight and reproducible for the contest demo. |
| Send model output to RTOS over Task Two protocol | AI output `ai_score_milli` is carried in QCZ1 AI/control payloads over IPv4/UDP. | See `docs/ai-control-evaluation.md` and `docs/protocol.md`. |
| RTOS adjusts observable control parameter or strategy | RTOS applies `output_milli = setpoint_milli * ai_score_milli / 1000` and reports state back. | Current observable output is logs/state response; it can be extended to LED/PWM on hardware. |
| Demonstrate closed loop | Integrated run includes AI input, inference, QCZ1 network transfer, RTOS control output and state reply. | The downloadable-artifact runner requires `QC_AI_CONTROL_RESULT=PASS`; the current-head long TAP proof also keeps AI `10/10` while tcpdump capture is active. |
| Measure end-to-end latency | Clean run reports AI end-to-end mean `2.186 ms`, max `3.389 ms`; final-demo rehearsal reports `1.563 ms / 1.754 ms`; current-head long TAP reports AI mean/max `2.501 ms / 5.014 ms`; the latest 4-worker TAP/tcpdump overcommit boundary keeps AI `10/10` with mean/max `5.277 ms / 15.431 ms`. | Measurement method and precision notes are in `docs/ai-control-evaluation.md` and `docs/test-report.md`. |
| Compare against fixed manual baseline with at least two metrics | Manual fixed-gain baseline uses `manual_score_milli = 800`. On the same ten samples, mean absolute error is AI `207` versus manual `240`, while tolerance-band accuracy (`+/-200` milliunits) is AI `6/10` versus manual `0/10`. Inference and end-to-end latency are also reported. | Representative values and the explicit tolerance definition are in `docs/ai-control-evaluation.md` and `docs/test-report.md`. |

## Submission Materials

| Required material | Current location | Status |
| --- | --- | --- |
| Design document | `docs/design.md` plus linked protocol/topology/realtime docs | READY |
| Test document | `docs/test-report.md`, `docs/physical-board-native-linux-baseline.md`, `results/realtime-comparison.csv`, physical-board summaries and stability summary | READY |
| Source code | Private contest repository `qcl-kernel/tgoskits-redcola`; main PR `#1`; StarryOS bonus PR `#2`; core vTimer/GIC/IRQ support in upstream via PR `#1770` | SUBMITTED |
| Reproduction instructions | `docs/reproduce.md` | READY |
| Demo video | `docs/demo-video-script.md`, `docs/final-video-cue-card-cn.md`, PowerPoint and narration package | FINAL RECORDING PENDING; the prior packaged MP4 is a superseded rehearsal fixture, and the selected user-narrated MP4 must pass `verify_demo_video.py` plus strict fresh-unzip package verification before upload |
| PR form | Private PR `#1`, private PR `#2`, `docs/commit-plan.md`, `docs/pr-boundary.md`, merged core PR `#1770` | SUBMITTED |

## StarryOS Bonus

| Bonus requirement | Current evidence | Reviewer note |
| --- | --- | --- |
| Use StarryOS instead of standard Linux where possible | Private PR `#2` adds `apps/starry/qemu/redcola-ai-control/`, a StarryOS QEMU AI-control demo with `REDCOLA_STARRY_QCZ1_PARITY_PASS`, `REDCOLA_STARRY_AI_CONTROL_PASS` and `REDCOLA_STARRY_AI_DONE` markers. | `docs/starryos-bonus.md` records the branch head, runtime source head, evidence path, log hash and boundary. This is bonus evidence, not a replacement for the main AxVisor Linux/RTOS TAP matrix. |
| Improve StarryOS syscall/Linux ABI support | No syscall patch is claimed in the current redcola StarryOS bonus branch. | This avoids overstating the separate syscall-completion bonus item. |

## Award-Oriented Positioning

| Scoring item | Evidence angle |
| --- | --- |
| Technical innovation 30% | Mixed Linux/RTOS AxVisor deployment, Zephyr e1000 guest networking, reliable QCZ1 protocol, AI control loop and separated core patch candidates. |
| Completeness 30% | Covers realtime, IP communication, AI linkage, reproducibility, static checks, evidence SHA256 and demo script. |
| Landing feasibility 25% | Uses a downloadable-artifact QEMU reproduction path, explicit topology, deterministic model and clear first-stage/core-patch separation. |
| Team capability 15% | Provides runnable code, measured results under stress, stability evidence, risk notes and PR-ready staging discipline. |

## Remaining Actions Before Final Submission

1. Keep the private contest repository `qcl-kernel/tgoskits-redcola` as the staged-review source of truth.
2. Use private PR `#1` for the main AxVisor artifact and private PR `#2` for the StarryOS bonus artifact.
3. Keep the current task-one long TAP/hub evidence stable, including the 4-worker TAP/tcpdump overcommit row; rerun only if code or runtime artifacts change before the 2026-08-21 second-version milestone.
4. Preserve the ATK-DLRK3588B cyclictest result as a conservative native-Linux physical-platform reference; do not present it as AxVisor-on-RK3588 evidence.
5. Record or confirm the final 5-minute demo video using `docs/demo-video-script.md` and `docs/final-video-cue-card-cn.md`.
6. Package the final platform submission with PR links, design/test/reproduce docs, evidence SHA256 values and the final demo video before 2026-08-24.
