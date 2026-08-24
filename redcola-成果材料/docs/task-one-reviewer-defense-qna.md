# Task-One Reviewer Defense Q&A

This page answers the review questions most likely to affect the 30-point
realtime score. It is intentionally short and conservative so it can be used
as a defense-note entry point before reading the longer task-one documents.

## One-Minute Claim

Redcola does not claim that AxVisor has been turned into a certified hard-RTOS
kernel. The task-one claim is narrower and easier to verify:

```text
The AxVisor AArch64 timer/interrupt path needed by a Zephyr RTOS guest was
made explicit, per-vCPU and testable, then measured in the required mixed
Linux/RTOS dual-guest workload with communication and AI loops still active.
```

The main upstream support anchor is:

```text
rcore-os/tgoskits#1770
024ecca10a4240a84b2c24bed2dc2361a6043d3e
axvisor: virtualize AArch64 physical timer state
21 files changed, 1328 insertions, 583 deletions
```

## Review Questions

| Question | Short answer | Evidence |
| --- | --- | --- |
| Is there a real AxVisor mechanism change, or only contest scripts? | There is a merged AxVisor core support anchor. PR `#1770` changes AArch64 physical timer virtualization, vTimer state, expiry routing, GIC handling and VM config plumbing. | `docs/task-one-realtime-core-claim.md`, `docs/core-patch-review.md`, upstream commit `024ecca10a4240a84b2c24bed2dc2361a6043d3e`. |
| Why is the main private PR mostly under `os/axvisor/contest/quancheng2026/`? | The contest PR keeps artifacts, scripts and evidence reviewable. The core support anchor is already in upstream history through PR `#1770`, so it is referenced rather than duplicated. | `docs/final-submission-checklist.md`, `docs/core-patch-review.md`. |
| What exactly is the realtime path being defended? | Guest physical timer state, virtual timer expiry, target-vCPU wakeup, GIC interrupt completion and explicit passthrough IRQ configuration for the Zephyr RTOS guest. | `docs/task-one-realtime-core-claim.md`. |
| Does the Linux guest satisfy the multi-vCPU requirement? | Yes. Integrated dual-guest runs record Linux `2` vCPUs while Zephyr RTOS runs as the realtime guest. | Runtime summaries, `docs/design.md`, `docs/network-topology.md`. |
| Are communication and AI disabled during realtime measurement? | No. The task-one rows keep plain UDP, QCZ1 reliable UDP and AI control checks active in the same run. | UDP `20/20`, QCZ1 `10/10`, AI `10/10` markers in task-one result summaries. |
| What is the strongest before/after latency claim? | The 10000-sample hub rows show RTOS p99 improvement at 0, 1 and 2 Linux-worker pressure points, while the 2-worker max outlier is kept visible. | `docs/task-one-score-summary.md`, `results/task-one-before-after-hub-summary.csv`. |
| What does TAP add? | TAP adds privileged packet-capture proof. The before/after TAP matrix passes in 0-worker and 2-worker shapes and records tcpdump captured/dropped `88/0` in every row. | `results/task-one-before-after-tap-summary.md`. |
| Why keep both hub and TAP? | Hub gives the broader long-sample trend and 0/1/2/4-worker matrix. TAP proves the real host packet-capture path with tcpdump counters. They are not treated as identical network paths. | `docs/realtime-evaluation.md`, `docs/task-one-score-summary.md`. |
| How is heavy pressure handled? | 4-worker rows are treated as a 2-vCPU Linux overcommit boundary. They prove completion and robustness under overload, not primary latency improvement. | `docs/task-one-30-point-checklist.md`, `docs/task-one-score-summary.md`. |
| Is there a native RTOS baseline? | Yes. Native Zephyr `latency_measure` reports 47 metrics and `PROJECT EXECUTION SUCCESSFUL`; it is used as a sanity baseline, not a direct replacement for AxVisor-hosted latency. | `docs/realtime-evaluation.md`. |
| Are worst-case results hidden? | No. Max latency and outliers are reported, including the 2-worker after-side max outlier and the 4-worker TAP overcommit max. | `docs/task-one-score-summary.md`, result CSV files. |

## Evidence Ladder

Use this order when defending task one:

1. Core mechanism: PR `#1770` and `docs/task-one-realtime-core-claim.md`.
2. Scoring map: `docs/task-one-30-point-checklist.md`.
3. Latency deltas: `docs/task-one-score-summary.md`.
4. Packet-captured proof: `results/task-one-before-after-tap-summary.md`.
5. Native RTOS baseline and measurement limits: `docs/realtime-evaluation.md`.
6. Reproduction contract: `docs/reproduce.md`.

## Numbers Safe To Quote

```text
0-worker hub RTOS p99: 1.323 ms -> 0.761 ms
0-worker hub RTOS max: 8.055 ms -> 1.773 ms
1-worker hub RTOS p99: 1.124 ms -> 0.782 ms
2-worker hub RTOS p99: 1.454 ms -> 0.993 ms
Exact submitted-head 2-worker hub stability repeat: 3/3 PASS
TAP before/after matrix: 4/4 PASS, tcpdump 88/0 in every row
Plain UDP: 20/20 PASS
QCZ1 reliable UDP: 10/10 PASS
AI control: 10/10 PASS
Native Zephyr baseline: 47 metrics, PROJECT EXECUTION SUCCESSFUL
```

## Safe Wording For Defense

Use this wording when talking to judges:

```text
Our task-one result focuses on AxVisor's AArch64 timer and interrupt delivery
path for the Zephyr RTOS guest. We use PR #1770 as the merged core support
anchor, then validate the mixed Linux/RTOS deployment with Linux kept at 2
vCPUs, Zephyr periodic timing, UDP/QCZ1 communication and AI control all active
in the same run. The main improvement claim is based on 0/1/2-worker
before/after p99 data; the 4-worker rows are reported as overcommit robustness
evidence rather than as a latency-improvement claim.
```

## Claims To Avoid

- Do not say this is a certified hard-real-time industrial kernel.
- Do not claim the native Zephyr baseline is numerically equivalent to the
  AxVisor-hosted mixed-system run.
- Do not use the 4-worker row as the primary latency-improvement claim.
- Do not mix hub and TAP numbers as if they were the same network path.
- Do not claim StarryOS syscall/ABI work as part of task one.
