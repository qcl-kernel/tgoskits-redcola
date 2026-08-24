# Final Demo Acceptance Checklist

This checklist is the pass/fail gate for the final redcola demo video. Use it
after recording and before rebuilding the 2026-08-24 final package. The goal is
to make sure the video proves the same items that the code, documents and
tests already submit.

## Hard Gates

The final video is not ready if any hard gate is missing:

| Gate | Required screen evidence |
| --- | --- |
| Repository identity | Private repository `qcl-kernel/tgoskits-redcola`, main PR `#1`, StarryOS PR `#2`, and the main branch or source head are visible. |
| Mixed-system boot | AxVisor dual-guest run reaches Linux guest and Zephyr RTOS guest markers. |
| Linux multi-vCPU | Linux guest reports `2` vCPUs, either in the live run or the submitted analyzer summary. |
| IP network channel | Linux/RTOS communication is shown as IPv4/UDP with Linux `192.0.2.10`, RTOS `192.0.2.20` and UDP port `4242`. |
| Plain UDP smoke | Plain UDP reports `20/20 PASS`. |
| QCZ1 reliable UDP | QCZ1 reports `10/10 PASS`, retransmits `0` or status validation `OK`. |
| AI closed loop | AI control reports `10/10 PASS` or `QC_AI_CONTROL_RESULT=PASS`. |
| RTOS state return | The video shows `ACK`, `STATUS`, RTOS periodic result, or analyzer output proving RTOS-side response. |
| Realtime evidence | The video shows p99/max latency or the submitted task-one summary for RTOS and Linux periodic probes, including the latest-`dev` CPU0 probe/CPU1 pressure stability evidence. |
| Packet capture | TAP/tcpdump evidence shows captured packets and kernel drops `0`; recorded TAP proof `88/0` is acceptable if live TAP falls back to hub mode. |
| StarryOS bonus | StarryOS PR `#2` material shows `REDCOLA_STARRY_QCZ1_PARITY_PASS`, `REDCOLA_STARRY_AI_CONTROL_PASS` and `REDCOLA_STARRY_AI_DONE`. |
| Final package | The generated final package or checklist shows `FINAL_PACKAGE_VERIFY=PASS`. |

## Reviewer Snapshot Gates

The video should pause long enough for reviewers to read these five snapshots:

| Snapshot | Minimum visible evidence | Why it matters |
| --- | --- | --- |
| Submission boundary | Private repo, PR `#1`, PR `#2`, branch or source head | Proves the submitted code location. |
| Network/protocol | `192.0.2.10`, `192.0.2.20`, UDP `4242`, QCZ1 header fields | Proves task-two uses IP networking and an application protocol. |
| Closed loop | UDP `20/20`, QCZ1 `10/10`, AI `10/10`, `result=PASS` | Proves tasks two and three run as one path. |
| Realtime evidence | RTOS/Linux p99/max, before/after rows, long TAP `88/0`, latest-`dev` three-run `3/3 PASS` | Proves task-one data rather than only boot success. |
| Bonus/package | StarryOS PASS markers and package verify PASS | Proves bonus evidence and final engineering completeness. |

## Recommended Timeline

| Time | Segment | Must show |
| --- | --- | --- |
| `0:00-0:30` | Opening | Team, contest task, private PR links, branch/source head. |
| `0:30-1:10` | Architecture | Linux/RTOS roles, IP topology, QCZ1 protocol fields and isolation boundary. |
| `1:10-2:45` | Live run | Dual guest command, UDP/QCZ1/AI PASS markers and final `result=PASS`. |
| `2:45-3:45` | Metrics | Analyzer report, realtime p99/max values, 30000-sample TAP or hub/TAP rows, and latest-`dev` three-run stability summary. |
| `3:45-4:25` | Task-one comparison | Native Zephyr baseline, before/after rows, 0/1/2-worker pressure and 4-worker overcommit boundary. |
| `4:25-4:45` | StarryOS bonus | StarryOS validation markers and conservative bonus boundary. |
| `4:45-5:00` | Closing | Reproducibility docs, final package, SHA256 sidecar and final deadline note. |

## Conservative Wording

Use these exact boundaries during narration:

```text
The 4-worker rows are overcommit and stability evidence, not the primary
latency-improvement row.

StarryOS is submitted as a separate non-RT guest bonus proof. The full
Linux/RTOS network closed loop remains the main AxVisor scoring anchor.

If live TAP is unavailable, the live hub run is only a rehearsal/fallback. The
packet-captured proof is the submitted TAP/tcpdump summary shown on screen.

The final uploaded ZIP identity is the generated package README plus the
sibling external .zip.sha256 file.
```

## No-Go Cases

Re-record the video if any of these happen:

| Issue | Why it matters |
| --- | --- |
| Password, token, private key or SSH key path is visibly exposed. | Security and submission hygiene. |
| The live run fails and no recorded PASS summary is shown afterward. | Breaks the closed-loop proof. |
| TAP fails and hub mode is presented as tcpdump proof. | Confuses task-two packet-capture evidence. |
| StarryOS is described as a full replacement for the main Linux guest path. | Overclaims the bonus scope. |
| Task one only shows a smoke boot and no p99/max, before/after or baseline data. | Leaves the largest scoring item under-supported. |
| The final package verification is omitted. | Weakens engineering completeness and reproducibility. |
| The video only shows the old checkpoint slides and no live terminal run. | Does not demonstrate the requested dual-terminal interaction strongly enough. |

## Final Reviewer Shortcut

After the video is accepted, the final package should point reviewers to:

```text
docs/final-defense-brief-cn.md
docs/final-demo-acceptance-checklist.md
docs/scorecard-traceability.md
docs/task-one-score-summary.md
docs/task-two-three-score-summary.md
docs/starryos-bonus-scorecard.md
video/redcola-axvisor-demo.mp4
```
