# Test Report

This document is the reviewer-facing test summary for the redcola Quancheng Lab
2026 AxVisor contest artifact. It points to the detailed evidence documents and
records the key PASS gates.

## Test Scope

The test set covers:

- native Zephyr RTOS baseline;
- AxVisor-hosted Zephyr e1000 IPv4/UDP;
- Linux/RTOS dual-guest IPv4/UDP communication;
- QCZ1 reliable UDP control protocol;
- AI inference to RTOS control closed loop;
- Linux and RTOS 1 ms periodic probes under 0/1/2/4 Linux-worker pressure;
- three-run stability under 2-worker Linux pressure;
- artifact reproducibility and static preflight checks.

## Startup Validation

The integrated script requires the following markers:

```text
QC_DUAL_GUEST_UDP_ECHO_RESULT=PASS
QC_RT_PERIODIC_RESULT=PASS
QC_RTOS_PERIODIC_RESULT=PASS
QC_QCZ1_RELIABLE_RESULT=PASS
QC_AI_CONTROL_RESULT=PASS
QC_QCZ1_GUEST_DEMO=PASS
QC_DUAL_GUEST_LINUX_INIT=PASS
result=PASS
```

Known integrated passing run:

```text
Linux guest vCPU count: 2
plain UDP: 20/20 PASS
QCZ1 reliable UDP: 10/10 PASS
AI control: 10/10 PASS
tcpdump kernel drops: 0
```

Latest official-`dev` compatibility run (2026-08-21):

```text
official base: 0340ed6bfa36cedd543d48f515e751ccc5a379bf
submission head: recorded in the generated final package README.txt
package SHA256: recorded beside the final ZIP and verified after transfer
evidence: /home/kali/qc-evidence/redcola-latest-dev-clean-pass-20260821
result: PASS
Linux guest: 2 vCPUs
plain UDP: 20/20 PASS, mean/max RTT 8.136 ms / 26.428 ms
QCZ1: 10/10 PASS, duplicate ACKs 2, retransmits 0
AI: 10/10 PASS, e2e mean/max 8.268 ms / 10.872 ms
AI/manual mean control error: 207 / 240
QEMU filter-dump: linux-net.pcap 93 packets, rtos-net.pcap 93 packets
archive SHA256: 302bd734a86accaf7ff8c8d6dbee6316126dd4156e255eb71e94e42865436da1
```

This run validates schema migration, PCI interrupt routing and the complete
Linux/RTOS communication and AI chain on the latest base. It is not substituted
for the long TAP/tcpdump realtime rows used in the before/after score claim.

Latest-`dev` Linux guest affinity matrix (2026-08-21):

```text
evidence: /home/kali/qc-evidence/t1-latestdev220-isolated-p10ms-20260821
archive SHA256: 17f300e8d14a445fda0d1b727dd0c5a332716576683ac61006bde5274bad1163
Linux guest: 2 vCPUs
periodic probe: guest CPU 0, 3000 samples, 10 ms period
stress workers: 0 or 2; pressure workers pinned to guest CPU 1
0 workers Linux mean/p99/max: 2.808 / 9.620 / 118.127 ms
2 workers Linux mean/p99/max: 2.166 / 4.615 / 73.587 ms
both rows: UDP 20/20, QCZ1 10/10, AI 10/10, final result=PASS
matrix: TASK_ONE_SECOND_VERSION_MATRIX=PASS
```

The 10 ms period avoids treating accumulated 1 ms TCG scheduler backlog as a
physical realtime result. This matrix validates the affinity mechanism and
load isolation on the latest source. It does not replace the existing 1 ms,
long TAP or AxVisor before/after evidence.

Latest-`dev` isolated 2-worker stability repeat:

```text
rounds: 3/3 PASS
Linux periodic samples: 9000/9000 at 10 ms
Linux mean lateness across runs: 2.150 ms
worst observed Linux P99/max: 8.753 / 127.734 ms
plain UDP: 60/60 PASS
QCZ1: 30/30 PASS, retransmits 0, expected duplicate probes 6
AI: 30/30 PASS, E2E mean of run means/max 8.826 / 49.197 ms
AI/manual mean control error: 207 / 240
```

The repeated campaign uses QEMU hub networking to remove privileged host TAP
setup from the repeated-boot loop. TAP/tcpdump evidence remains available in
the separate long TAP proof. See
`results/task-one-latestdev-isolated-p10ms-stability-3x-summary.md`.

Latest short final-demo rehearsal archive:

```text
archive SHA256: 064e37dca1aec17cc6e7e3169aa80ebb4987a3920978073e5e9cf825b0618eb7
plain UDP: 20/20 PASS, mean/max RTT 3.705 ms / 31.001 ms
QCZ1 reliable UDP: 10/10 PASS, duplicate ACKs 2, retransmits 0
AI control: 10/10 PASS, end-to-end mean/max 1.563 ms / 1.754 ms
Linux periodic: 2000 samples, p99 1.823 ms, max 2.873 ms
RTOS periodic: 1000 samples, p99 1.427 ms, max 7.008 ms
tcpdump captured packets: 88
tcpdump kernel drops: 0
```

## Communication Reliability

Native Zephyr reliable UDP campaign:

```text
rounds: 10/10 PASS
control messages: 200/200
duplicate ACK checks: 40
ACK p95: 2.059 ms
```

Integrated dual-guest run:

```text
plain UDP: 20/20 PASS
plain UDP RTT mean/max: 2.943 ms / 19.039 ms
QCZ1 reliable UDP: 10/10 PASS
duplicate ACKs: 2
retransmits: 0
QCZ1 latency mean/max: 3.112 ms / 8.108 ms
tcpdump captured packets: 88
tcpdump kernel drops: 0
```

Task-two scoring snapshot:

| Requirement detail | Evidence |
| --- | --- |
| IP network link | Linux `192.0.2.10` to RTOS `192.0.2.20:4242` over IPv4/UDP |
| Protocol fields | QCZ1 magic, version, type, header length, payload length, flags, sequence, timestamp, checksum |
| Business messages | `CONTROL_SET`, `STATE_REQ`, `ACK`, `STATUS`, `ERROR` |
| Reliability and recovery | ACK validation, timeout/retry path, duplicate command suppression, duplicate ACK accounting |
| Success and errors | Plain UDP `20/20`, QCZ1 `10/10`, retransmits `0`, RTOS final `STATUS` error count `0` |
| Packet evidence | tcpdump captured `88` packets, kernel drops `0` |
| Conservative useful throughput | plain UDP about `339` request/response transactions/s; QCZ1 about `321` control transactions/s, estimated from success count divided by summed observed representative latencies |

The analyzer also records application errors, timeout/recovery counters,
latency distributions and effective application throughput. See
`docs/protocol.md`, `docs/network-topology.md` and
`docs/task-two-three-score-summary.md`.

## Realtime Baseline and AxVisor Runs

Native Zephyr baseline:

```text
board: qemu_cortex_a53
benchmark: tests/benchmarks/latency_measure
reported metrics: 47
preemptive k_yield context switch: 2400 ns
ISR return to interrupted thread: 1071 ns
maximum reported primitive latency: 46703 ns
result marker: PROJECT EXECUTION SUCCESSFUL
```

AxVisor long-sample comparison:

```text
0 workers: Linux p99 2.789 ms, RTOS p99 0.613 ms, AI 10/10
1 worker : Linux p99 2.559 ms, RTOS p99 1.228 ms, AI 10/10
2 workers: Linux p99 4.347 ms, RTOS p99 0.727 ms, AI 10/10
4 workers: Linux p99 41.868 ms, RTOS p99 1.256 ms, AI 10/10
```

The 4-worker run intentionally overcommits the 2-vCPU Linux guest. It raises
Linux-side latency but keeps RTOS periodic, UDP, QCZ1 and AI-control gates
passing.

See `docs/realtime-evaluation.md` and `results/realtime-comparison.csv`.
For the compact before/after delta table, see
`docs/task-one-score-summary.md`.

Second-version task-one before/after preparation:

```text
before anchor: bb562428c69317faccf2761167d2fabc47b82a37
after anchor : 024ecca10a4240a84b2c24bed2dc2361a6043d3e
current branch: contest/axvisor-2026
```

The 2026-08-13 hub-mode smoke comparison reuses the same dual-guest
Linux/Zephyr workload before and after the landed AxVisor timer support anchor.
It is recorded as second-version preparation evidence; the final stronger gate
is the completed TAP/tcpdump matrix tracked in
`docs/second-version-submission-status.md`.

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS p99/max ns | Linux p99/max ns | UDP | QCZ1 | AI |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| before-0w | PASS | hub | 0 | 2 | `873920 / 3259472` | `7858560 / 15010576` | `20/20` | `10/10` | `10/10` |
| before-2w | PASS | hub | 2 | 2 | `662832 / 2867760` | `3196880 / 5580496` | `20/20` | `10/10` | `10/10` |
| after-0w | PASS | hub | 0 | 2 | `683296 / 1854592` | `2562944 / 12974752` | `20/20` | `10/10` | `10/10` |
| after-2w | PASS | hub | 2 | 2 | `914176 / 5394288` | `5424976 / 7955632` | `20/20` | `10/10` | `10/10` |
| after-4w-overcommit | PASS | hub | 4 | 2 | `1231824 / 7619584` | `8624448 / 12764016` | `20/20` | `10/10` | `10/10` |

The hub-mode table proves that both baseline and current branches can run the
same mixed-system workload with a 2-vCPU Linux guest, RTOS periodic probes,
QCZ1 and AI control active. TAP/tcpdump rows were then collected with
caller-authenticated `sudo -v` on the Kali host; the repository intentionally
does not store any sudo password.

Completed TAP/tcpdump before/after matrix:

```text
head: 2737d1e603b5b0d62cc4d6faf71dbdee33bd75c5
evidence: /home/kali/qc-evidence/t1-before-after-tap-fixed-114047
result: TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS
after 0 workers : PASS, Linux 2 vCPUs, RTOS p99/max 1.291 ms / 9.350 ms, UDP 20/20, QCZ1 10/10, AI 10/10, tcpdump 88/0
after 2 workers : PASS, Linux 2 vCPUs, RTOS p99/max 0.927 ms / 9.913 ms, UDP 20/20, QCZ1 10/10, AI 10/10, tcpdump 88/0
before 0 workers: PASS, Linux 2 vCPUs, RTOS p99/max 0.791 ms / 3.672 ms, UDP 20/20, QCZ1 10/10, AI 10/10, tcpdump 88/0
before 2 workers: PASS, Linux 2 vCPUs, RTOS p99/max 1.273 ms / 3.566 ms, UDP 20/20, QCZ1 10/10, AI 10/10, tcpdump 88/0
```

Private PR-head long hub matrix:

```text
head: 760e253eec50c0425eadec321d56663e400ac28b
evidence: /home/kali/qc-evidence/t1-head760-hub-r10000-20260814_010458
result: TASK_ONE_SECOND_VERSION_MATRIX=PASS
0 workers: Linux 2 vCPUs, RTOS p99/max 0.761 ms / 1.773 ms, UDP 20/20, QCZ1 10/10, AI 10/10
2 workers: Linux 2 vCPUs, RTOS p99/max 0.993 ms / 6.934 ms, UDP 20/20, QCZ1 10/10, AI 10/10
tcpdump: n/a in hub mode; see completed TAP matrix above for packet counters
```

Pre-`#1770` long hub baseline matrix:

```text
head: bb562428c69317faccf2761167d2fabc47b82a37
evidence: /home/kali/qc-evidence/t1-before1770-hub-r10000-20260814_011825
result: TASK_ONE_SECOND_VERSION_MATRIX=PASS
0 workers: Linux 2 vCPUs, RTOS p99/max 1.323 ms / 8.055 ms, UDP 20/20, QCZ1 10/10, AI 10/10
2 workers: Linux 2 vCPUs, RTOS p99/max 1.454 ms / 4.347 ms, UDP 20/20, QCZ1 10/10, AI 10/10
tcpdump: n/a in hub mode; see completed TAP matrix above for packet counters
```

Latest private PR-head long hub matrix:

```text
head: 588ddf1a3e5e9697799f39b8334db73a1ea3bd15
evidence: /home/kali/qc-evidence/t1-head588-hub-r10000-20260814_074255
result: TASK_ONE_SECOND_VERSION_MATRIX=PASS
0 workers: Linux 2 vCPUs, RTOS p99/max 1.242 ms / 9.931 ms, UDP 20/20, QCZ1 10/10, AI 10/10
1 worker : Linux 2 vCPUs, RTOS p99/max 1.208 ms / 2.207 ms, UDP 20/20, QCZ1 10/10, AI 10/10
2 workers: Linux 2 vCPUs, RTOS p99/max 0.639 ms / 1.882 ms, UDP 20/20, QCZ1 10/10, AI 10/10
tcpdump: n/a in hub mode; see completed TAP matrix above for packet counters
```

This recorded branch-head rerun confirms that the submitted private PR branch still
preserves the 2-vCPU Linux guest, RTOS periodic probe, QCZ1 protocol and AI
closed-loop markers after the first-version packaging/documentation updates.
The `1`-worker row also gives the recorded branch the same middle pressure point
used by the before/after scoring table.

Recorded private PR-head final-video rehearsal:

```text
head: d9f8fa3c24e92c52929f4903b80d4c08bc6cea37
evidence: /home/kali/qc-evidence/qc-demo-hub-head-d9f8fa3c2-20260814_081925
result: PASS
analysis_result: PASS
net_mode: hub
Linux guest: 2 vCPUs
Linux stress workers: 1
Linux periodic samples: 3000
RTOS p99/max: 0.632 ms / 4.649 ms
Plain UDP: 20/20 PASS
QCZ1: 10/10 PASS, retransmits 0, duplicate ACKs 2
AI: 10/10 PASS, e2e mean/max 2.013 ms / 3.263 ms
tcpdump: n/a in hub mode; completed TAP matrix records packet counters
```

This rehearsal is optimized for the final video flow: it shows the same
scoring markers in one compact run while keeping one Linux stress worker
enabled. Because it uses hub networking, it is kept as a final-video rehearsal;
the packet-capture proof is the completed TAP/tcpdump matrix above.

1-worker long hub fill-in:

```text
evidence: /home/kali/qc-evidence/t1w1-hub-before-after-20260814_030333
before1: Linux 2 vCPUs, RTOS p99/max 1.124 ms / 5.085 ms, UDP 20/20, QCZ1 10/10, AI 10/10
after1 : Linux 2 vCPUs, RTOS p99/max 0.782 ms / 4.967 ms, UDP 20/20, QCZ1 10/10, AI 10/10
tcpdump: n/a in hub mode; see completed TAP matrix above for packet counters
```

Long-hub before/after observation:

```text
0 workers: RTOS p99 improved from 1.323 ms to 0.761 ms; RTOS max improved from 8.055 ms to 1.773 ms.
1 worker : RTOS p99 improved from 1.124 ms to 0.782 ms; RTOS max improved from 5.085 ms to 4.967 ms.
2 workers: RTOS p99 improved from 1.454 ms to 0.993 ms; RTOS max saw a larger outlier, 4.347 ms to 6.934 ms.
Both before and after kept Linux 2 vCPUs, UDP 20/20, QCZ1 10/10 and AI 10/10.
```

4-worker overcommit boundary:

```text
evidence: /home/kali/qc-evidence/t1w4-hub-before-after-recovered-20260814_020210
analyzer helper: 6dddec6dc80c1695b7c299668c9c40f684fb2dca
before4: PASS, Linux 2 vCPUs, RTOS p99/max 1.067 ms / 6.420 ms, UDP 20/20, QCZ1 10/10, AI 10/10
after4 : PASS, Linux 2 vCPUs, RTOS p99/max 1.506 ms / 7.000 ms, UDP 20/20, QCZ1 10/10, AI 10/10
tcpdump: n/a in hub mode; see completed TAP matrix above for packet counters
```

The 4-worker run is treated as a stability boundary, not a main improvement
claim. It intentionally overcommits the 2-vCPU Linux guest; the important
result is that the RTOS periodic probe, QCZ1 protocol and AI closed loop still
finish under this heavier Linux pressure.

### Physical-Board Native Linux Pressure Baseline

The final test set includes a bounded physical-platform reference collected on
an ATK-DLRK3588B V1.1 RK3588 board running factory Buildroot native Linux.
Three FIFO-95 cyclictest scenarios used a 1 ms interval and 300,000 cycles each:

| Scenario | p99 (us) | p99.9 (us) | Max (us) | Result |
| --- | ---: | ---: | ---: | --- |
| Idle | 17 | 20 | 95 | PASS |
| Isolated stress | 8 | 15 | 76 | PASS |
| Full stress | 26 | 30 | 1338 | PASS |

The total was 900,000 cycles with zero histogram overflows. The source archive
digest is `7af6beee3ef1ad2b041d25073a7df2a24e5ddca87d76d5e0bada46c0b5b6b974`.
This row validates physical-board pressure measurement and evidence handling;
it does not claim AxVisor or mixed guests ran on this exact board.

## AI Closed-Loop Result

Representative integrated dual-guest AI result:

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

Representative native smoke result:

```text
AI control messages: 20/20
end-to-end mean: 1.118 ms
AI mean error: 129.003
manual mean error: 204.640
```

The two reported comparison dimensions are control quality and timing. See
`docs/ai-control-evaluation.md` and `docs/task-two-three-score-summary.md`.

Task-three scoring snapshot:

| Requirement detail | Evidence |
| --- | --- |
| Neural-network inference | deterministic fixed-point MLP in the non-RT Linux guest path |
| Networked model output | AI output is sent as QCZ1 `CONTROL_SET` over IPv4/UDP |
| RTOS control action | Zephyr applies `output_milli = setpoint_milli * ai_score_milli / 1000` and reports applied state |
| Closed loop | Linux sample, AI inference, QCZ1 send, RTOS apply, ACK/STATUS return and analyzer validation |
| Timing metric | representative integrated AI e2e mean/max `2.186 ms / 3.389 ms`; final-demo rehearsal mean/max `1.563 ms / 1.754 ms` |
| Quality metric | integrated mean control error AI `207` versus manual `240`; native smoke AI `129.003` versus manual `204.640` |
| Stress behavior | AI stays `10/10 PASS` across the 0/1/2/4-worker AxVisor runs |

StarryOS bonus linkage:

```text
bonus_pr=qcl-kernel/tgoskits-redcola#2
starryos_submitted_head=2ac656341a63facdc3030fa3fd99bd20de156bef
latestdev_compatibility=supplemental_final_package_evidence
runtime_source_head=4cbd22ccb837
REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli=930 ai_score_milli=1000 sample_id=1
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0 mean_infer_us=82
REDCOLA_STARRY_AI_DONE
```

This StarryOS result is recorded as bonus evidence for the non-RT guest side.
It demonstrates the same deterministic AI-control policy and QCZ1 frame format
inside the StarryOS QEMU guest. It is not claimed as a full replacement for the
main AxVisor Linux/RTOS TAP packet-capture matrix.

## Stability

The 2-worker pressure configuration was repeated three times:

```text
rounds: 3/3 PASS
UDP: 20/20 in every round
QCZ1: 10/10 in every round
AI: 10/10 in every round
tcpdump kernel drops: 0 in every round
bad-scan logs: empty
Linux periodic p99 range: 4.301-16.140 ms
RTOS periodic p99 range: 0.864-0.985 ms
AI e2e max range: 2.230-24.792 ms
```

See `results/stability/2026-07-27-stress2-3x/stability-summary.md`.

## Reproducibility and Artifact Checks

Current contest-directory preflight:

```text
python3 -m py_compile scripts/*.py linux/*.py: PASS
bash -n scripts/*.sh linux/*.sh: PASS
QCZ1 C guest STATUS negative selftest via documented runner/preflight path: PASS
QCZ1 Python client STATUS negative selftest: PASS
artifact scan for images/logs/pyc/tarballs: 0
git diff --check: PASS
dry-run staged path count: 42
outside contest dry-run path count: 0
```

Recorded PR-head runtime proof, using the same dual-guest runner in unprivileged
QEMU hub mode:

```text
command:
  os/axvisor/contest/quancheng2026/scripts/run_axvisor_dual_guest_qcz1_ai.sh
  --repo /path/to/tgoskits
  --evidence-dir /home/kali/qc-evidence/qc_pr1703_status_selftest_runner_hub_20260731_092251
  --timeout 300
  --linux-rt-samples 2000
  --net-mode hub
QC_QCZ1_STATUS_NEGATIVE_SELFTEST=PASS
qemu_status=0
net_mode=hub
QC_RTOS_PERIODIC_RESULT=PASS
QC_RT_PERIODIC_RESULT=PASS
QC_DUAL_GUEST_UDP_ECHO_RESULT=PASS
QC_QCZ1_RELIABLE_STATUS_OK=1
QC_QCZ1_RELIABLE_RESULT=PASS
QC_AI_STATUS_OK=1
QC_AI_CONTROL_RESULT=PASS
QC_QCZ1_GUEST_DEMO=PASS
QC_DUAL_GUEST_LINUX_INIT=PASS
result=PASS
QC_UDP_SUCCESSES=20
QC_QCZ1_LATENCY_MEAN_US=4957
QC_AI_E2E_MEAN_US=3714
QC_AI_E2E_MAX_US=18067
```

This current-head run uses QEMU `hubport` to avoid requiring privileged TAP
and bridge setup in the remote validation session. It validates the same
Linux/RTOS guest IP path, QCZ1 application protocol, AI control loop, guest
marker sequence, and the pre-QEMU STATUS timeout/malformed negative selftest.
TAP bridge state and tcpdump packet-capture counters are not claimed for this
unprivileged current-head run.

The latest long current-head hub proof was then rerun from private PR `#1`
runtime source head `8984bd23dbb27b091aaa120020f0ac9eff59226d` with `2`
Linux stress workers and `30000` Linux periodic samples. Evidence is stored at
`/home/kali/qc-evidence/t1-head8984-long-hub-2w-r30000-20260814_173833` and
reports `TASK_ONE_SECOND_VERSION_MATRIX=PASS`, RTOS mean/p99/max
`51404 / 685872 / 2001840 ns`, Linux mean/p99/max
`1258737 / 9481712 / 37442704 ns`, UDP `20/20`, QCZ1 `10/10`, QCZ1
retransmits `0`, AI `10/10` and no missing markers.

The matching current-head TAP/tcpdump long proof uses private PR `#1` runtime
source head `91cb7c0fc00d579d62528a3c967e5efd3cc57836`. The `2`-worker row is
stored at `/home/kali/qc-evidence/t1-current-head-long-tap-20260814_180823` and
reports `TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS`, RTOS mean/p99/max
`89652 / 1961824 / 9953504 ns`, Linux mean/p99/max
`1251285 / 7613808 / 25035136 ns`, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, and
tcpdump captured/dropped `88/0`.

The latest `4`-worker TAP/tcpdump overcommit row is stored at
`/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018`. It keeps the
Linux guest at `2` vCPUs while running `4` Linux stress workers and `30000`
Linux periodic samples. It reports `TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS`,
RTOS mean/p99/max `120165 / 1821568 / 31444800 ns`, Linux mean/p99/max
`15268450 / 124812416 / 153937328 ns`, UDP `20/20`, QCZ1 `10/10`, QCZ1
retransmits `0`, duplicate ACKs `2`, AI `10/10`, AI end-to-end mean/max
`5277 / 15431 us`, and tcpdump captured/dropped `88/0`. This is reported as an
overcommit/stability boundary, not as the primary latency-improvement claim.

The recorded 2-worker long hub proof included in the package manifest is stored at
`/home/kali/qc-evidence/t1-a9ce-long-hub-20260815_064606`. It was collected
from source head `a9ceb7dc8e93d1d91df16036800bdad1600ea835` and is included in
the current upload package manifest through
`results/task-one-head-a9ce-long-hub-r30000-*`. It reports
`TASK_ONE_A9CE_LONG_HUB_PROOF=PASS`, `TASK_ONE_SECOND_VERSION_MATRIX=PASS`,
RTOS mean/p99/max `72094 / 1115280 / 5921456 ns`, Linux mean/p99/max
`1021556 / 4862240 / 31883280 ns`, UDP `20/20`, QCZ1 `10/10`, retransmits `0`,
AI `10/10` and no missing markers. This hub proof keeps an additional long
mixed-system run in the package manifest; TAP/tcpdump rows above remain the
packet-capture evidence.

The first-stage commit boundary remains:

```text
os/axvisor/contest/quancheng2026/
```

No AxVisor core files, image files, temporary scripts or generated raw logs
belong in the first-stage contest-material commit.

## Evidence References

Main local evidence roots on the Windows host are listed in `README.md` and
`results/CURRENT_STATUS_2026-07-26.md`. The current source/documentation bundle
is generated under:

```text
contest-package/FINAL_UPLOAD_MANIFEST_2026-07-27.md
contest-package/2026-07-27-demo-rehearsal-latest-evidence/
```
