# Task-One Score Summary

This note is a compact, score-oriented view of the redcola task-one realtime
evidence for the 2026-08-21 second-version checkpoint. It complements the raw
CSV tables in `results/task-one-before-after-hub-summary.csv` and
`results/task-one-before-after-tap-summary.csv`, and avoids making the reviewer
calculate the before/after deltas by hand.

## What This Proves

- The same mixed-system workload runs before and after the landed AxVisor timer
  support anchor.
- Every compared row keeps the Linux guest at `2` vCPUs.
- Every compared row keeps plain UDP `20/20`, QCZ1 `10/10` and AI `10/10`.
- The 0/1/2-worker rows give the main latency comparison.
- The 4-worker row is kept as an overcommit boundary and stability note, not
  as a latency-improvement claim.
- The TAP before/after matrix now adds privileged packet-capture counters to
  the same 0-worker and 2-worker workload shape.
- The current-head long-pressure proof extends the `30000` Linux periodic
  sample window across the 2-worker hub/TAP rows and 4-worker hub/TAP
  overcommit rows.
- The exact submitted head `746042293` adds a 3-run repeatability proof for the
  2-worker, `30000`-sample hub pressure row.
- Recorded head `a9ceb7dc` adds a refreshed 2-worker, `30000`-sample hub proof
  that is included in the current upload package manifest.

## Before/After Delta Table

| Workers | Main observation | RTOS p99 delta | RTOS max delta | Notes |
| ---:| --- | ---:| ---:| --- |
| `0` | Best no-pressure realtime improvement row. | `1.323 ms -> 0.761 ms` (`42.5%` lower) | `8.055 ms -> 1.773 ms` (`78.0%` lower) | UDP/QCZ1/AI all stay `100%`. |
| `1` | Best middle-pressure improvement row. | `1.124 ms -> 0.782 ms` (`30.4%` lower) | `5.085 ms -> 4.967 ms` (`2.3%` lower) | Linux p99/max also improve by `28.2%` / `49.3%`. |
| `2` | Linux-pressure row with RTOS p99 improvement. | `1.454 ms -> 0.993 ms` (`31.7%` lower) | `4.347 ms -> 6.934 ms` (`59.5%` higher outlier) | Keep the outlier visible; do not overclaim. |
| `4` | 2-vCPU Linux overcommit boundary. | not claimed | not claimed | Used only as heavy-pressure completion evidence. |

## TAP Before/After Packet-Capture Matrix

The privileged TAP rerun completed on 2026-08-14 and is recorded under:

```text
/home/kali/qc-evidence/t1-before-after-tap-fixed-114047
```

It generated the committed summary table:

```text
results/task-one-before-after-tap-summary.csv
results/task-one-before-after-tap-summary.md
```

| Phase | Workers | Result | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | AI | tcpdump captured/dropped |
| --- | ---:| --- | ---:| ---:| ---:| ---:| ---:| ---:|
| after | `0` | `PASS` | `83166 / 1290544 / 9349568` | `786370 / 2141264 / 14366752` | `20/20` | `10/10` | `10/10` | `88/0` |
| after | `2` | `PASS` | `72137 / 927216 / 9913056` | `949349 / 5177888 / 29571664` | `20/20` | `10/10` | `10/10` | `88/0` |
| before | `0` | `PASS` | `51834 / 791120 / 3671568` | `863998 / 2761120 / 13642256` | `20/20` | `10/10` | `10/10` | `88/0` |
| before | `2` | `PASS` | `54287 / 1273216 / 3565712` | `1259651 / 13018080 / 41490032` | `20/20` | `10/10` | `10/10` | `88/0` |

All four rows report `analysis_result=PASS`, no missing markers, Linux `2`
vCPUs, QCZ1 retransmits `0`, duplicate ACK coverage `2`, and tcpdump kernel
drops `0`. The after 2-worker row gives the strongest TAP RTOS p99 value in
this matrix while the complete IP/QCZ1/AI loop remains active.

## Current-Head Long-Pressure Proof

The second-version long-pressure refresh adds current-head `30000`-sample
rows:

| Net | Workers | Samples | Result | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | AI | tcpdump captured/dropped |
| --- | ---:| ---:| --- | ---:| ---:| ---:| ---:| ---:| ---:|
| hub | `2` | `30000` | `PASS` | `51404 / 685872 / 2001840` | `1258737 / 9481712 / 37442704` | `20/20` | `10/10` | `10/10` | `n/a` |
| TAP | `2` | `30000` | `PASS` | `89652 / 1961824 / 9953504` | `1251285 / 7613808 / 25035136` | `20/20` | `10/10` | `10/10` | `88/0` |
| hub | `4` | `30000` | `PASS` | `79469 / 1143440 / 5372880` | `3552003 / 56459776 / 108703104` | `20/20` | `10/10` | `10/10` | `n/a` |
| TAP | `4` | `30000` | `PASS` | `120165 / 1821568 / 31444800` | `15268450 / 124812416 / 153937328` | `20/20` | `10/10` | `10/10` | `88/0` |
| hub, recorded head `a9ce` | `2` | `30000` | `PASS` | `72094 / 1115280 / 5921456` | `1021556 / 4862240 / 31883280` | `20/20` | `10/10` | `10/10` | `n/a` |

The TAP rows are the strongest current-head end-to-end proof because they keep the
privileged Linux/RTOS packet-capture path active while the long periodic probe,
plain UDP, QCZ1 reliable UDP and AI control loop all complete. They report
`analysis_result=PASS`, final `result=PASS`, QCZ1 retransmits `0`, duplicate
ACKs `2`, AI end-to-end mean/max `2501 / 5014 us` in the 2-worker row and
`5277 / 15431 us` in the 4-worker row, and tcpdump kernel drops `0`.

The 4-worker hub and TAP rows are intentionally framed as an
overcommit/stability boundary rather than the primary latency-improvement row:
they run `4` Linux stress workers against a `2`-vCPU Linux guest while still
completing UDP `20/20`, QCZ1 `10/10`, AI `10/10`, RTOS periodic analysis and
the final PASS markers.

Committed summary files:

```text
results/task-one-current-head-long-hub-r30000-summary.csv
results/task-one-current-head-long-hub-r30000-summary.md
results/task-one-current-head-long-hub4-r30000-summary.csv
results/task-one-current-head-long-hub4-r30000-summary.md
results/task-one-current-head-long-hub4-r30000-proof.txt
results/task-one-current-head-long-tap-r30000-summary.csv
results/task-one-current-head-long-tap-r30000-summary.md
results/task-one-current-head-long-tap4-r30000-summary.csv
results/task-one-current-head-long-tap4-r30000-summary.md
results/task-one-current-head-long-tap4-r30000-proof.txt
results/task-one-head-a9ce-long-hub-r30000-summary.csv
results/task-one-head-a9ce-long-hub-r30000-summary.md
results/task-one-head-a9ce-long-hub-r30000-proof.txt
results/task-one-head746-2w-hub-stability-r30000-summary.csv
results/task-one-head746-2w-hub-stability-r30000-summary.md
results/task-one-second-version-summary.csv
results/task-one-second-version-summary.md
```

## Scorecard Mapping

| Task-one scoring detail | Evidence now available |
| --- | --- |
| Realtime target and key-path analysis | `docs/realtime-evaluation.md`, `docs/core-patch-review.md` and this summary name timer/interrupt delivery as the target path. |
| Substantive AxVisor key-mechanism change | Merged support anchor `rcore-os/tgoskits#1770` is the landed timer/interrupt support reference. |
| Multi-vCPU Linux guest | Every before/after row records Linux `2` vCPUs. |
| Before/after realtime data | `results/task-one-before-after-hub-summary.csv` records 0/1/2/4-worker rows and `results/task-one-before-after-tap-summary.csv` records TAP 0/2-worker rows with RTOS and Linux periodic metrics. Current-head `30000`-sample hub/TAP rows and the 4-worker hub/TAP overcommit rows are recorded in the long-pressure summaries, including the `b706a02c` full hub proof and the exact submitted head `746042293` 3-run stability repeat. |
| Empty and stress scenarios | 0-worker, 1-worker, 2-worker and 4-worker pressure rows are recorded; TAP covers 0-worker and 2-worker packet-capture rows, and current-head long pressure covers both 2-worker TAP/hub proof and 4-worker hub/TAP overcommit runs with `30000` Linux periodic samples. The `b706a02c` full hub run covers 0/1/2/4-worker pressure, and the exact submitted head `746042293` repeats the 2-worker long-pressure hub row 3 times. |
| Native RTOS baseline | Zephyr native latency baseline is retained in `docs/realtime-evaluation.md`. |

## Current Runtime-Proof Refresh

The final sync also has an official-`dev` compatibility run collected on
2026-08-21. Official `upstream/dev` was
`8e39cbd586a4a34ab9f522931ca4b1e7523709c7`, runtime source head was
`17ee96b89fd2e4c441a44dd5c1893f63ee5e77db`, and the persisted evidence is:

```text
/home/kali/qc-evidence/final-demo-latestdev8e39-head17ee-20260821
```

It reports Linux `2` vCPUs, Linux periodic `3000/3000`, RTOS periodic
`1000/1000`, UDP `20/20`, QCZ1 `10/10`, AI `10/10`,
`analysis_result=PASS` and final `result=PASS`. This non-privileged hub run is
the latest-official-dev compatibility proof; the committed 30000-sample TAP
rows remain the long-pressure and packet-capture proof.

The private PR `#1` head was refreshed on 2026-08-15 to
`746042293ac61bc5cb894c6c470ae76fdc02674a`. The exact submitted head was
validated with a 3-run, 2-worker long hub-mode stability repeat:

```text
evidence_root=/home/kali/qc-evidence/t1-head746-2w-hub-stability-r30000-20260815_031511
source_head=746042293ac61bc5cb894c6c470ae76fdc02674a
net_mode=hub
linux_rt_samples=30000
linux_stress_workers=2
repeat_result=3/3 PASS
RTOS p99/max run1=1015776 / 3080560 ns
RTOS p99/max run2=1040304 / 2043904 ns
RTOS p99/max run3=882896 / 2598624 ns
UDP=20/20 PASS in all rows
QCZ1=10/10 PASS in all rows
AI=10/10 PASS in all rows
tcpdump=SKIPPED
```

The prior full long hub-mode pressure matrix was collected at head
`b706a02cdbf9e4688edc3def932ea4ae5159bbcd`:

```text
evidence_root=/home/kali/qc-evidence/t1-headb706-full-hub-r30000-20260815_022916
source_head=b706a02cdbf9e4688edc3def932ea4ae5159bbcd
net_mode=hub
linux_rt_samples=30000
linux_stress_workers=0,1,2,4
matrix_result=PASS
0-worker RTOS p99/max=1372496 / 3525056 ns
1-worker RTOS p99/max=1073280 / 10214304 ns
2-worker RTOS p99/max=820064 / 3563856 ns
4-worker RTOS p99/max=931056 / 2066960 ns
UDP=20/20 PASS in all rows
QCZ1=10/10 PASS in all rows, retransmits=0
AI=10/10 PASS in all rows
tcpdump=SKIPPED
```

The `b706a02c` full hub proof remains the broader 0/1/2/4-worker pressure
matrix, while the `746042293` repeat above is the exact submitted-head
2-worker stability proof. The long TAP/tcpdump rows below remain the
packet-capture evidence because they use the privileged TAP path.

The recorded long hub proof included in the current upload package manifest
was refreshed at `a9ceb7dc8e93d1d91df16036800bdad1600ea835`:

```text
evidence_root=/home/kali/qc-evidence/t1-a9ce-long-hub-20260815_064606
source_head=a9ceb7dc8e93d1d91df16036800bdad1600ea835
net_mode=hub
linux_rt_samples=30000
linux_stress_workers=2
result=PASS
RTOS p99/max=1115280 / 5921456 ns
Linux p99/max=4862240 / 31883280 ns
UDP=20/20 PASS
QCZ1=10/10 PASS, retransmits=0
AI=10/10 PASS
tcpdump=SKIPPED
```

This row is not used as the packet-capture claim; it keeps a recent
long-running 2-worker mixed Linux/RTOS/AI proof in the package manifest while
the TAP rows remain the network-capture evidence.

The latest current-head long TAP proof is recorded at:

```text
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_180823
```

It was collected from runtime source head
`91cb7c0fc00d579d62528a3c967e5efd3cc57836`. Later commits may update
scorecard text, submission messages and package manifests; runtime
measurements remain tied to their recorded source heads.

The run covers the `2` Linux-worker case with `30000` Linux periodic samples in
TAP mode. It reports `TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS`,
`TASK_ONE_SECOND_VERSION_MATRIX=PASS`, `analysis_result=PASS`, final
`result=PASS`, Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits
`0`, duplicate ACKs `2`, AI `10/10`, no missing markers and tcpdump
captured/dropped `88/0`. The paired long hub run is recorded in
`results/task-one-current-head-long-hub-r30000-summary.csv`, and the
4-worker hub overcommit proof is recorded at:

```text
/home/kali/qc-evidence/t1-current-head-hub4-r30000-20260814_204459
```

It reports `TASK_ONE_CURRENT_HEAD_LONG_HUB4_PROOF=PASS`, UDP `20/20`, QCZ1
`10/10`, AI `10/10`, QCZ1 retransmits `0`, duplicate ACKs `2`, RTOS p99/max
`1143440 / 5372880 ns` and AI end-to-end mean/max `3428 / 7887 us`.

The matching 4-worker TAP/tcpdump overcommit proof is recorded at:

```text
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018
```

It keeps the same `4` Linux stress workers on a `2`-vCPU Linux guest while
using the privileged TAP/tcpdump path. It reports
`TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS`, UDP `20/20`, QCZ1 `10/10`, AI
`10/10`, QCZ1 retransmits `0`, duplicate ACKs `2`, RTOS p99/max
`1821568 / 31444800 ns`, AI end-to-end mean/max `5277 / 15431 us`, and tcpdump
captured/dropped `88/0`.

## Second-Version Gate Status

The high-value TAP gate has now been completed in the same before/after shape:

```text
current branch, TAP, 0 workers
current branch, TAP, 2 workers
pre-#1770 baseline, TAP, 0 workers
pre-#1770 baseline, TAP, 2 workers
```

The wrapper result is `TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS`. Hub-mode data
remains useful for the 0/1/2/4-worker latency trend, while the TAP matrix is
now the packet-captured task-one proof for the second-version checkpoint.
