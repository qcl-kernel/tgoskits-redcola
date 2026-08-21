# Task-Two And Task-Three 50-Point Reviewer Checklist

This page maps the communication and AI-control scoring items directly to the
redcola evidence set. Task two is worth 25 points and task three is worth 25
points, so together they are the main proof that the prototype is more than a
boot demo.

## Reviewer Snapshot

This is the compact scoring path for the 50 points across task two and task
three. The evidence is intentionally framed as a single closed loop, because
the contest asks for communication and AI-control linkage rather than two
unrelated demos.

| Gate | Review status | Fast proof |
| --- | --- | --- |
| Main transport is IP networking | Ready | Linux `192.0.2.10` and Zephyr RTOS `192.0.2.20:4242` communicate over IPv4/UDP; TAP rows add tcpdump `88/0` packet proof. |
| Application protocol has required fields | Ready | QCZ1 defines version, message type, payload length, sequence, timestamp, checksum and typed payloads over UDP/IP. |
| Command/status/error messages work | Ready | `CONTROL_SET`, `STATE_REQ`, `ACK`, `STATUS` and `ERROR` are implemented, with status validation checking `last_seq`, `status == OK` and `error_count == 0`. |
| Reliability over UDP is tested | Ready | Client ACK validation, timeout/retry, duplicate ACK accounting, duplicate-command suppression and status negative selftest are documented. |
| AI output uses the same protocol | Ready | Neural-network output is packed into QCZ1 `CONTROL_SET` and sent through the task-two network path rather than a side channel. |
| RTOS closes the loop | Ready | Zephyr applies the control output, returns ACK/STATUS and exposes the applied state to the analyzer and video markers. |
| Quantitative comparison is present | Ready | AI/manual control error, AI inference time, end-to-end latency and pressure behavior are recorded in the task-three summaries. |

Boundary: StarryOS PR `#2` is a bonus/parity path. The main 50-point proof
remains the Linux/RTOS AxVisor path with TAP/hub evidence, while StarryOS
strengthens the non-RT guest story without being overstated as a full
replacement for every main-line run.

## Task Two: IP-Based Guest Communication, 25 Points

| Official scoring detail | Points | Current coverage | Evidence to inspect | Conservative boundary |
| --- | ---:| --- | --- | --- |
| Starry/Linux and RTOS IP network link | `4` | Linux guest `192.0.2.10` communicates with Zephyr RTOS guest `192.0.2.20:4242` over IPv4/UDP. TAP mode records packet-capture counters; hub mode is used only for controlled QEMU rehearsal and long-sample trend runs. | `docs/network-topology.md`, `docs/test-report.md`, TAP summaries | The main scoring path is Linux/RTOS. StarryOS is separate bonus evidence and is not overstated as the full task-two replacement. |
| Application protocol fields over TCP/UDP/IP | `5` | QCZ1 runs above UDP/IP and defines magic, version, message type, header length, payload length, flags, sequence, timestamp, checksum and typed payloads. | `docs/protocol.md`, `linux/qc_qcz1_guest_demo.c`, `rtos/zephyr_udp_qc_protocol_udp.c` | Plain UDP echo remains as a sanity path; QCZ1 is the scored application protocol. |
| Control instruction, status return and error notification | `5` | `CONTROL_SET`, `STATE_REQ`, `ACK`, `STATUS` and `ERROR` are defined and validated. Status validation checks `last_seq`, `status == OK` and `error_count == 0`. | `docs/protocol.md`, `docs/task-two-three-score-summary.md`, `linux/qc_reliable_udp_client.py` | Error handling is protocol-level and test-level; it is not presented as a production safety-certified fault model. |
| Reliability, timeout, retry and abnormal recovery | `4` | Linux validates ACK sequence numbers, retries on timeout, counts duplicate ACKs and queries final RTOS status. RTOS suppresses duplicate commands and returns duplicate ACKs without reapplying control. | `linux/qc_reliable_udp_client.py`, `scripts/qc_qcz1_guest_status_negative_selftest.py`, `docs/test-report.md` | The current transport is UDP with application-layer reliability, not TCP or a full broker protocol. |
| Automated protocol test data | `4` | Integrated runs report plain UDP `20/20 PASS`, QCZ1 `10/10 PASS`, native QCZ1 `200/200` control messages and `40` duplicate ACK responses. | `docs/test-report.md`, `docs/task-two-three-score-summary.md`, analyzer summaries | Large raw logs stay outside git; committed docs contain small summaries and reproducible commands. |
| Network isolation and access control | `3` | Topology uses documentation-reserved addresses, per-run TAP/bridge setup and cleanup, no NAT to external networks and no repository-stored sudo password. TAP captures report `88` packets and `0` kernel drops in the recorded matrix rows. | `docs/network-topology.md`, `docs/final-submission-checklist.md`, TAP summary CSV/Markdown | The isolation proof is for the QEMU contest environment, not for a deployed plant network. |

Recorded runtime-source full long pressure proof for task two:

```text
source_head=b706a02cdbf9e4688edc3def932ea4ae5159bbcd
evidence_root=/home/kali/qc-evidence/t1-headb706-full-hub-r30000-20260815_022916
0/1/2/4-worker plain UDP=20/20 PASS
0/1/2/4-worker QCZ1 reliable UDP=10/10 PASS
QCZ1 retransmits=0 in all rows
QCZ1 duplicate ACKs=2 in all rows
QCZ1 STATUS validation=OK in all rows
matrix_result=PASS
```

This is a current-head `30000`-sample integrated full pressure matrix. The
packet-capture score evidence still comes from the TAP rows, because hub mode
deliberately omits tcpdump.

## Task Three: AI Control Closed Loop, 25 Points

| Official scoring detail | Points | Current coverage | Evidence to inspect | Conservative boundary |
| --- | ---:| --- | --- | --- |
| Neural-network inference in Starry/Linux guest | `4` | The Linux guest runs a deterministic fixed-weight neural-network controller. The StarryOS bonus PR separately runs the same policy family as a StarryOS user-mode demo. | `docs/ai-control-evaluation.md`, `linux/qc_ai_control_demo.py`, `docs/starryos-bonus.md` | The model is intentionally small and deterministic so the control loop is reproducible in QEMU. |
| Model output sent through task-two network protocol | `5` | AI output `ai_score_milli` is packed into QCZ1 `CONTROL_SET` and sent over IPv4/UDP to the RTOS guest. | `docs/protocol.md`, `docs/ai-control-evaluation.md`, `linux/qc_qcz1_guest_demo.c` | The AI path uses the same QCZ1 transport as task two; it is not a side-channel shortcut. |
| RTOS observable control action | `5` | Zephyr applies `output_milli = setpoint_milli * ai_score_milli / 1000` and reports/logs the applied state through ACK and STATUS. | `rtos/zephyr_udp_qc_protocol_udp.c`, `docs/protocol.md`, analyzer report summaries | The observable action is serial/state output in QEMU; physical LED/PWM/motor output is a future hardware extension. |
| Status return and complete closed loop | `4` | The analyzer validates request, ACK, STATUS, control output, errors, latency and final `QC_AI_CONTROL_RESULT=PASS`. | `docs/ai-control-evaluation.md`, `docs/task-two-three-score-summary.md`, `scripts/analyze_dual_guest_realtime.py` | The final video should show the loop continuously so this does not look like separate unit tests. |
| End-to-end latency measurement | `3` | Representative integrated AI e2e mean/max is `2.186 ms / 3.389 ms`; final-demo rehearsal records `1.563 ms / 1.754 ms`; recorded runtime-source `30000`-sample pressure rows keep AI `10/10 PASS` across 0/1/2/4 workers, with 0-worker mean/max `1.755 ms / 2.567 ms`, 2-worker `3.299 ms / 9.299 ms`, and 4-worker `8.600 ms / 53.677 ms`. | `docs/ai-control-evaluation.md`, `docs/test-report.md`, runtime summaries | Measurements use Linux-side request/response timing and are reported with QEMU/platform caveats. |
| Manual baseline comparison with at least two metrics | `4` | Control quality compares AI mean error against fixed manual gain, and timing compares AI inference plus end-to-end control latency. Integrated mean control error is AI `207` versus manual `240`; native smoke is AI `129.003` versus manual `204.640`. | `docs/ai-control-evaluation.md`, `docs/test-report.md`, `docs/demo-video-script.md` | The baseline is a deterministic fixed gain. It is intentionally simple so the AI-vs-manual difference is reproducible. |

Recorded runtime-source full long pressure proof for task three:

```text
source_head=b706a02cdbf9e4688edc3def932ea4ae5159bbcd
0/1/2/4-worker AI control=10/10 PASS
0-worker AI e2e mean/max=1.755 ms / 2.567 ms
1-worker AI e2e mean/max=4.268 ms / 26.773 ms
2-worker AI e2e mean/max=3.299 ms / 9.299 ms
4-worker AI e2e mean/max=8.600 ms / 53.677 ms
AI control error mean=207
manual control error mean=240
RTOS STATUS validation=OK
matrix_result=PASS
```

## One-Line End-To-End Proof

The scored task-two/task-three path is:

```text
Linux input sample
  -> neural-network inference
  -> QCZ1 CONTROL_SET over IPv4/UDP
  -> Zephyr RTOS applies output_milli
  -> QCZ1 ACK and STATUS return applied state
  -> analyzer validates success, latency, errors and control quality
```

## Key Markers To Quote

```text
QC_UDP_SUCCESSES=20
QC_QCZ1_RELIABLE_SUCCESSES=10
QC_QCZ1_RETRANSMITS=0
QC_AI_REQUESTS=10
QC_AI_SUCCESSES=10
QC_AI_FAILURES=0
QC_AI_E2E_MEAN_US=2186
QC_AI_E2E_MAX_US=3389
recorded runtime 0w QC_AI_E2E_MEAN_US=1755
recorded runtime 0w QC_AI_E2E_MAX_US=2567
recorded runtime 1w QC_AI_E2E_MEAN_US=4268
recorded runtime 1w QC_AI_E2E_MAX_US=26773
recorded runtime 2w QC_AI_E2E_MEAN_US=3299
recorded runtime 2w QC_AI_E2E_MAX_US=9299
recorded runtime 4w QC_AI_E2E_MEAN_US=8600
recorded runtime 4w QC_AI_E2E_MAX_US=53677
QC_AI_CONTROL_ERROR_MEAN=207
QC_MANUAL_CONTROL_ERROR_MEAN=240
QC_AI_CONTROL_RESULT=PASS
tcpdump captured packets=88
tcpdump kernel drops=0
```

## Fast Review Path

1. Read `docs/protocol.md` for QCZ1 frame fields and reliability.
2. Read `docs/network-topology.md` for IP/MAC/bridge/TAP isolation.
3. Read `docs/ai-control-evaluation.md` for model, payload, latency and
   manual baseline.
4. Read `docs/task-two-three-score-summary.md` for the compact integrated
   metrics.
5. Use the final video script and runbook to verify the path is shown as one
   continuous loop.

## What Is Not Claimed

- vsock, HyperCall, shared memory and bare MMIO are not used as the primary
  task-two data channel.
- StarryOS PR `#2` is a bonus/parity path, not a full replacement for the main
  Linux/RTOS TAP proof.
- The QEMU RTOS control action is a logged/stateful output, not a physical
  actuator demo unless later hardware validation is added.
- The repository does not include raw pcaps, runtime images, sudo passwords,
  private keys or GitHub tokens.
