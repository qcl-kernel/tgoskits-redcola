# Task-Two And Task-Three Score Summary

This note is a compact, score-oriented view of the redcola communication and
AI-control evidence. It complements `docs/protocol.md`,
`docs/network-topology.md`, `docs/ai-control-evaluation.md` and
`docs/test-report.md`.

## Task Two: IP-Based Guest Communication

## Reviewer Full-Credit Checklist

| Review question | Redcola answer | Where to verify |
| --- | --- | --- |
| Is the main data path really IP networking? | Yes. Linux and RTOS guests communicate over IPv4/UDP with documented addresses and port. | `docs/network-topology.md`, `docs/protocol.md` |
| Is the application protocol more than an echo string? | Yes. QCZ1 has a fixed header, message types, sequence/timestamp fields, checksum and typed payloads. | `docs/protocol.md`, `linux/qc_qcz1_guest_demo.c`, `rtos/zephyr_udp_qc_protocol_udp.c` |
| Does the protocol include command, state and error paths? | Yes. `CONTROL_SET`, `STATE_REQ`, `ACK`, `STATUS` and `ERROR` are implemented and validated. | `docs/test-report.md`, `linux/qc_reliable_udp_client.py` |
| Does UDP have reliability handling? | Yes. The client validates ACKs, handles timeouts/retries, counts duplicates and validates final status. | `docs/test-report.md`, `scripts/qc_qcz1_guest_status_negative_selftest.py` |
| Is the AI result actually sent through that protocol? | Yes. The model output is packed into QCZ1 `CONTROL_SET` and sent to the RTOS guest. | `docs/ai-control-evaluation.md`, `linux/qc_ai_control_demo.py` |
| Does RTOS produce observable control state? | Yes. Zephyr applies `output_milli = setpoint_milli * ai_score_milli / 1000` and returns `ACK`/`STATUS`. | `rtos/zephyr_udp_qc_protocol_udp.c`, analyzer reports |

Use this table as the fastest way to score tasks two and three before reading
the detailed protocol, topology and test documents.

| Scoring detail | Evidence |
| --- | --- |
| Starry/Linux to RTOS IP network link | Linux guest `192.0.2.10` communicates with Zephyr RTOS guest `192.0.2.20:4242` over IPv4/UDP. The topology is documented in `docs/network-topology.md`. |
| Application protocol over IP transport | QCZ1 runs above UDP/IP and defines magic, version, message type, header length, payload length, flags, sequence, timestamp and checksum fields. |
| Control, status and error messages | QCZ1 implements `CONTROL_SET`, `STATE_REQ`, `ACK`, `STATUS` and `ERROR`. |
| Reliability over UDP | Linux side validates ACK sequence numbers, uses timeout/retry logic and queries final RTOS status; RTOS side suppresses duplicate commands and returns duplicate ACKs. |
| Automated test evidence | Plain UDP `20/20 PASS`, QCZ1 `10/10 PASS`, native QCZ1 campaign `200/200` control messages and `40` duplicate ACK responses. |
| Packet-capture evidence | Recorded TAP/tcpdump run captured `88` packets with kernel drops `0`. The final before/after TAP matrix remains the task-one packet-capture gate. |
| Network isolation and access control | The docs describe isolated test IPs, per-run bridge/TAP setup and cleanup, and the repository does not store host sudo credentials. |

Representative integrated metrics:

```text
plain UDP: 20/20 PASS
plain UDP RTT mean/max: 2.943 ms / 19.039 ms
QCZ1 reliable UDP: 10/10 PASS
QCZ1 duplicate ACKs: 2
QCZ1 retransmits: 0
QCZ1 latency mean/max: 3.112 ms / 8.108 ms
tcpdump captured packets: 88
tcpdump kernel drops: 0
```

Recorded runtime-source full long pressure matrix:

```text
source_head=b706a02cdbf9e4688edc3def932ea4ae5159bbcd
evidence_root=/home/kali/qc-evidence/t1-headb706-full-hub-r30000-20260815_022916
net_mode=hub
Linux guest vCPUs=2
0-worker UDP/QCZ1/AI=20/20, 10/10, 10/10 PASS
1-worker UDP/QCZ1/AI=20/20, 10/10, 10/10 PASS
2-worker UDP/QCZ1/AI=20/20, 10/10, 10/10 PASS
4-worker UDP/QCZ1/AI=20/20, 10/10, 10/10 PASS
QCZ1 retransmits=0 in all rows
QCZ1 duplicate ACKs=2 in all rows
QCZ1 STATUS validation=OK in all rows
AI control error mean=207
manual control error mean=240
matrix_result=PASS
```

This recorded full long pressure matrix shows that the submitted branch
keeps the complete communication and AI path passing at `30000` Linux
periodic samples under 0/1/2/4-worker pressure. TAP/tcpdump packet-capture
proof remains covered by the recorded TAP rows, because hub mode intentionally
skips host bridge/TAP creation.

## Task Three: AI Control Closed Loop

| Scoring detail | Evidence |
| --- | --- |
| Neural-network inference in non-RT guest | Linux guest runs a deterministic fixed-weight neural-network controller. |
| Model output sent through task-two protocol | AI output is sent as QCZ1 `CONTROL_SET` over IPv4/UDP. |
| RTOS observable control action | Zephyr applies `output_milli = setpoint_milli * ai_score_milli / 1000` and logs the applied state. |
| Closed-loop response | RTOS returns `ACK` and `STATUS`; the analyzer checks success, latency and control error. |
| End-to-end latency | Representative integrated AI e2e mean/max `2.186 ms / 3.389 ms`; final-demo rehearsal mean/max `1.563 ms / 1.754 ms`; recorded runtime-source 30000-sample pressure rows stay PASS from 0 to 4 workers, with 0-worker mean/max `1.755 ms / 2.567 ms`, 2-worker `3.299 ms / 9.299 ms`, and 4-worker `8.600 ms / 53.677 ms`. |
| Manual baseline comparison | Integrated mean control error AI `207` versus manual `240`; native smoke AI `129.003` versus manual `204.640`. |
| Stress behavior | AI stays `10/10 PASS` across 0/1/2/4-worker AxVisor runs. |

Representative integrated markers:

```text
QC_AI_REQUESTS=10
QC_AI_SUCCESSES=10
QC_AI_FAILURES=0
QC_AI_INFER_MEAN_US=66
QC_AI_E2E_MEAN_US=2186
QC_AI_E2E_MAX_US=3389
QC_AI_CONTROL_ERROR_MEAN=207
QC_MANUAL_CONTROL_ERROR_MEAN=240
QC_AI_CONTROL_RESULT=PASS
```

The recorded runtime-source full long pressure matrix also reports:

```text
QC_QCZ1_STATUS_VALIDATION=OK
0-worker QC_AI_E2E_MEAN_US=1755
0-worker QC_AI_E2E_MAX_US=2567
1-worker QC_AI_E2E_MEAN_US=4268
1-worker QC_AI_E2E_MAX_US=26773
2-worker QC_AI_E2E_MEAN_US=3299
2-worker QC_AI_E2E_MAX_US=9299
4-worker QC_AI_E2E_MEAN_US=8600
4-worker QC_AI_E2E_MAX_US=53677
QC_AI_CONTROL_ERROR_MEAN=207
QC_MANUAL_CONTROL_ERROR_MEAN=240
```

Latest StarryOS bonus linkage:

```text
StarryOS PR: qcl-kernel/tgoskits-redcola#2
StarryOS submitted branch head: 2ac656341a63facdc3030fa3fd99bd20de156bef
Latest-dev compatibility: supplemental final-package evidence
Runtime source head: 4cbd22ccb837
REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli=930 ai_score_milli=1000 sample_id=1
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0 mean_infer_us=82
REDCOLA_STARRY_AI_DONE
```

This is a bonus-path proof that the StarryOS non-RT guest can run the same
deterministic AI-control policy and construct the same QCZ1 `CONTROL_SET`
application-frame shape. It is intentionally kept separate from the main
Linux/RTOS network closed loop, which remains the task-two/task-three scoring
anchor.

## Reviewer Takeaway

Task two and task three should be read as one linked path:

```text
Linux sample input
  -> neural-network inference
  -> QCZ1 CONTROL_SET over IPv4/UDP
  -> Zephyr RTOS applies control output
  -> QCZ1 ACK/STATUS returns applied state
  -> analyzer validates latency, errors and control quality
```

The task-two protocol evidence proves that the cross-guest network path is not
a raw shared-memory shortcut. The task-three evidence proves that the network
path is used by an AI-driven control loop rather than by an isolated echo demo.

## Final Video Proof Checklist

The final five-minute video should show these six items in order so the
communication and AI-control score is visible without reading source code:

| Video moment | What must be visible | Scoring value |
| --- | --- | --- |
| Network setup | Linux and RTOS guest addresses or the recorded topology note. | Proves the main path is IP-based guest communication. |
| QCZ1 frame/protocol | `CONTROL_SET`, `ACK`, `STATUS` or the QCZ1 summary markers. | Proves this is an application protocol over UDP/IP, not a raw echo. |
| Reliability markers | `QC_QCZ1_RELIABLE_SUCCESSES=10`, retransmits `0`, duplicate ACK/status validation. | Proves timeout/retry/duplicate/status handling is exercised. |
| AI inference | AI input sample, inference result or `QC_AI_REQUESTS=10`. | Proves the non-RT guest runs a neural-network control step. |
| RTOS control output | Applied `output_milli`, ACK/STATUS or `QC_AI_CONTROL_RESULT=PASS`. | Proves the RTOS side uses the model output and returns state. |
| Quantitative comparison | AI/manual control error and end-to-end latency numbers. | Proves the closed loop is measured and compared against a manual baseline. |

Recommended quote for the video or defense:

```text
The same QCZ1 UDP/IP protocol carries both the reliability test and the AI
control command. The RTOS returns ACK and STATUS, and the analyzer validates
success, latency, error count and AI-versus-manual control quality in one
closed loop.
```
