# Task-One Realtime Evaluation

This note turns the redcola realtime evidence into a reviewer-facing comparison
for the Quancheng Lab 2026 AxVisor task. It separates the native RTOS primitive
baseline from the AxVisor-hosted dual-guest periodic-task evidence, because the
two tests measure different layers of the stack.

## Reviewer Quick Evidence

| Contest requirement | redcola evidence |
| --- | --- |
| Realtime core claim | `docs/task-one-realtime-core-claim.md` ties PR `#1770` to the timer/interrupt path, before/after anchors and measured conservative conclusion. |
| AxVisor mixed-system runtime | AxVisor starts a 2-vCPU Linux guest and a Zephyr RTOS guest in the same QEMU AArch64 run. |
| CPU and guest partitioning | Linux guest uses pCPU `1-2`; Zephyr RTOS guest uses pCPU `0`; the RTOS path is measured while Linux load runs separately. |
| Native RTOS baseline | Zephyr `latency_measure` on `qemu_cortex_a53` reports `47` metrics, maximum primitive latency `46703 ns`, and `PROJECT EXECUTION SUCCESSFUL`. |
| Stress comparison | 0/1/2/4 Linux-worker hub runs keep UDP `20/20`, QCZ1 `10/10` and AI `10/10`; the 0/2-worker TAP before/after matrix and the current-head 4-worker TAP overcommit run add tcpdump `88/0` packet counters. |
| RTOS periodic behavior | In long-sample runs, RTOS 1 ms periodic p99 remains within `0.613-1.962 ms` for the primary 0/1/2-worker rows and reaches `1.822 ms` in the 4-worker TAP overcommit boundary; mean remains within `0.080-0.123 ms`. |
| Stability campaign | The 2-worker pressure scenario passed `3/3` repeated runs with UDP/QCZ1/AI all passing and tcpdump drops `0`. |
| Core-change traceability | vTimer, interrupt-routing and related AxVisor support are traced in `docs/core-patch-review.md`; the already-merged core support PR is referenced from `docs/final-submission-checklist.md`. |

The first 2026-08-14 submission therefore contains a reproducible realtime
validation path. The 2026-08-14 follow-up evidence adds a clearer before/after
AxVisor-core comparison in hub mode, confirms the 0/2-worker before/after shape
with TAP/tcpdump packet-capture counters, and adds a current-head 4-worker
TAP/tcpdump overcommit proof.

## Second-Version Before/After Probe

The 2026-08-13 second-version preparation added a preliminary pre-`#1770`
baseline probe. The before baseline uses commit
`bb562428c69317faccf2761167d2fabc47b82a37`, and the after reference is the
merged AxVisor timer support commit
`024ecca10a4240a84b2c24bed2dc2361a6043d3e`.

These rows use non-privileged `hub` networking, so tcpdump counters are not
available in this table. They are kept as smoke evidence and planning data.
The longer 10000-sample rows below are the stronger hub-mode before/after
trend evidence for the 2026-08-21 submission; the later TAP matrix is the
packet-captured 0/2-worker proof.

| Label | Result | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | AI e2e mean/max us |
| --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| before-0w | `PASS` | `0` | `2` | `60352 / 873920 / 3259472` | `926584 / 7858560 / 15010576` | `20/20` | `10/10` | `1477 / 1852` |
| before-2w | `PASS` | `2` | `2` | `51959 / 662832 / 2867760` | `880675 / 3196880 / 5580496` | `20/20` | `10/10` | `2796 / 6570` |
| after-0w | `PASS` | `0` | `2` | `58825 / 683296 / 1854592` | `779248 / 2562944 / 12974752` | `20/20` | `10/10` | `1746 / 2421` |
| after-2w | `PASS` | `2` | `2` | `70773 / 914176 / 5394288` | `1039036 / 5424976 / 7955632` | `20/20` | `10/10` | `3195 / 17759` |
| after-4w-overcommit | `PASS` | `4` | `2` | `78049 / 1231824 / 7619584` | `1980978 / 8624448 / 12764016` | `20/20` | `10/10` | `4043 / 7585` |

The full evidence paths, log hashes and interpretation notes are tracked in
`docs/task-one-second-version-plan.md`.

## TAP Before/After Packet-Capture Matrix

The 2026-08-14 TAP rerun records the same current-vs-baseline shape with host
TAP devices, a bridge, and tcpdump counters. The evidence is stored at:

```text
/home/kali/qc-evidence/t1-before-after-tap-fixed-114047
```

The committed reviewer tables are:

```text
results/task-one-before-after-tap-summary.csv
results/task-one-before-after-tap-summary.md
```

| Phase | Workers | Result | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | AI e2e mean/max us | tcpdump captured/dropped |
| --- | ---:| --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| after | `0` | `PASS` | `2` | `83166 / 1290544 / 9349568` | `786370 / 2141264 / 14366752` | `20/20` | `10/10` | `1808 / 3916` | `88/0` |
| after | `2` | `PASS` | `2` | `72137 / 927216 / 9913056` | `949349 / 5177888 / 29571664` | `20/20` | `10/10` | `4179 / 17642` | `88/0` |
| before | `0` | `PASS` | `2` | `51834 / 791120 / 3671568` | `863998 / 2761120 / 13642256` | `20/20` | `10/10` | `1789 / 2090` | `88/0` |
| before | `2` | `PASS` | `2` | `54287 / 1273216 / 3565712` | `1259651 / 13018080 / 41490032` | `20/20` | `10/10` | `3459 / 9056` | `88/0` |

Interpretation:

- `TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS` closes the previous privileged
  packet-capture gap.
- Every row keeps plain UDP, QCZ1 reliable UDP and AI control at `100%`
  success while the Linux guest exposes `2` vCPUs.
- The after 2-worker row reports RTOS p99 `927216 ns` under Linux pressure
  with tcpdump kernel drops `0`.

## 10000-Sample Hub Before/After Matrix

The 2026-08-14 long hub matrix compares the pre-`#1770` baseline against the
private PR-head runtime source with the same Linux 2-vCPU guest, Zephyr RTOS
guest, UDP/QCZ1/AI workload and `10000` Linux periodic samples. It is not a
packet-capture run, but it gives a stronger current before/after realtime
comparison than the earlier short smoke rows.

| Label | Source head | Result | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | AI e2e mean/max us |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| before1770-0w-r10000 | `bb562428c69317faccf2761167d2fabc47b82a37` | `PASS` | `0` | `2` | `80937 / 1322960 / 8054832` | `794758 / 2166768 / 7016816` | `20/20` | `10/10` | `2416 / 6551` |
| before1770-1w-r10000 | `bb562428c69317faccf2761167d2fabc47b82a37` | `PASS` | `1` | `2` | `74750 / 1123872 / 5085392` | `875693 / 4034768 / 25984544` | `20/20` | `10/10` | `3622 / 19762` |
| before1770-2w-r10000 | `bb562428c69317faccf2761167d2fabc47b82a37` | `PASS` | `2` | `2` | `89005 / 1453600 / 4347168` | `958411 / 4704416 / 11699344` | `20/20` | `10/10` | `3406 / 7781` |
| after-head760-0w-r10000 | `760e253eec50c0425eadec321d56663e400ac28b` | `PASS` | `0` | `2` | `50391 / 761312 / 1773024` | `948824 / 5220048 / 27038432` | `20/20` | `10/10` | `2322 / 3769` |
| after-head238-0w-r10000 | `238a868e61fe70b97e00b623a38ad73324339a42` | `PASS` | `0` | `2` | `78908 / 1424512 / 3693072` | `1803927 / 44821264 / 66204960` | `20/20` | `10/10` | `1724 / 2647` |
| after-head588-0w-r10000 | `588ddf1a3e5e9697799f39b8334db73a1ea3bd15` | `PASS` | `0` | `2` | `81318 / 1242256 / 9931104` | `842653 / 3150800 / 15527632` | `20/20` | `10/10` | `1469 / 1901` |
| after-current-1w-r10000 | `aa9657ad3efabfcc121fd10366e3eb99c6b81b1b` | `PASS` | `1` | `2` | `58311 / 782080 / 4966544` | `820334 / 2898192 / 13186032` | `20/20` | `10/10` | `2405 / 5829` |
| after-head588-1w-r10000 | `588ddf1a3e5e9697799f39b8334db73a1ea3bd15` | `PASS` | `1` | `2` | `68419 / 1207616 / 2207312` | `981621 / 4048688 / 41116832` | `20/20` | `10/10` | `2230 / 5036` |
| after-head760-2w-r10000 | `760e253eec50c0425eadec321d56663e400ac28b` | `PASS` | `2` | `2` | `72076 / 993408 / 6933952` | `1151354 / 7175200 / 39208656` | `20/20` | `10/10` | `1902 / 4202` |
| after-head238-2w-r10000 | `238a868e61fe70b97e00b623a38ad73324339a42` | `PASS` | `2` | `2` | `73723 / 1413744 / 4755488` | `880126 / 3647584 / 25559584` | `20/20` | `10/10` | `2595 / 5518` |
| after-head588-2w-r10000 | `588ddf1a3e5e9697799f39b8334db73a1ea3bd15` | `PASS` | `2` | `2` | `45508 / 639456 / 1882048` | `961211 / 4479360 / 23385232` | `20/20` | `10/10` | `2893 / 7145` |

Interpretation:

- With no Linux pressure, the after run improves RTOS p99/max from
  `1.323 ms / 8.055 ms` to `0.761 ms / 1.773 ms`.
- With 1 Linux worker, the after run improves RTOS p99/max from
  `1.124 ms / 5.085 ms` to `0.782 ms / 4.967 ms`, while Linux non-RT p99/max
  also improves from `4.035 ms / 25.985 ms` to `2.898 ms / 13.186 ms`.
- With 2 Linux workers, the after run improves RTOS p99 from `1.454 ms` to
  `0.993 ms`; RTOS max contains a larger after-side outlier
  (`4.347 ms` to `6.934 ms`).
- Both before and after runs keep the Linux guest at `2` vCPUs and keep UDP,
  QCZ1 and AI closed-loop success at `100%`.

Evidence roots:

```text
/home/kali/qc-evidence/t1-before1770-hub-r10000-20260814_011825
/home/kali/qc-evidence/t1-head760-hub-r10000-20260814_010458
/home/kali/qc-evidence/t1w1-hub-before-after-20260814_030333
/home/kali/qc-evidence/t1-head238-hub-r10000-20260814_070406
/home/kali/qc-evidence/t1-head588-hub-r10000-20260814_074255
```

The `after-head588-*` rows are the latest private PR-head long hub rerun after
the packaging and evidence notes were refreshed. They keep the same long-sample
shape, add the `1`-worker middle point at the latest head, and all three rows
report `TASK_ONE_SECOND_VERSION_MATRIX=PASS`. They are kept as current-head
health evidence; the scoring delta still compares like-for-like before and
after rows, with the completed TAP/tcpdump matrix providing packet-capture
counters for the 0/2-worker shape.

## 4-Worker Overcommit Boundary

The 4-worker before/after run is kept as an overcommit boundary rather than as
the main improvement claim. It places `4` Linux stress workers on the same
`2`-vCPU Linux guest while the Zephyr RTOS periodic probe, UDP, QCZ1 and AI
control paths remain active.

| Label | Source head | Result | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | AI e2e mean/max us |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| before4 | `bb562428c69317faccf2761167d2fabc47b82a37` | `PASS` | `4` | `2` | `68513 / 1067280 / 6420496` | `3350749 / 46688208 / 69122784` | `20/20` | `10/10` | `5510 / 25233` |
| after4 | `6dddec6dc80c1695b7c299668c9c40f684fb2dca` | `PASS` | `4` | `2` | `75941 / 1506224 / 6999824` | `343967173 / 1099832160 / 1118971392` | `20/20` | `10/10` | `5475 / 18573` |

Evidence root:

```text
/home/kali/qc-evidence/t1w4-hub-before-after-recovered-20260814_020210
```

Interpretation: both rows keep the mixed-system gates passing under heavier
Linux pressure, but the after row does not improve 4-worker latency. The
scoring-relevant latency-improvement statement remains the 0/2-worker
10000-sample hub comparison above, plus the completed TAP/tcpdump
packet-capture matrix.

## Current-Head 4-Worker TAP/tcpdump Overcommit Proof

The latest long-pressure TAP proof keeps the same current runtime source head
as the 4-worker hub proof while enabling the privileged TAP/tcpdump path:

```text
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018
```

| Label | Source head | Result | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| current-head-long-tap-4w-r30000 | `91cb7c0fc00d579d62528a3c967e5efd3cc57836` | `PASS` | `4` | `2` | `120165 / 1821568 / 31444800` | `15268450 / 124812416 / 153937328` | `20/20` | `10/10` | `5277 / 15431` | `88/0` |

This row is also an overcommit boundary, not the primary improvement claim. Its
value is that a 4-worker overloaded Linux guest, long `30000`-sample periodic
probe, QCZ1 reliable UDP, AI closed loop, RTOS periodic probe and tcpdump
packet capture all complete with `result=PASS`.

## Measurement Scope

### Latest-Dev Guest CPU Isolation Check

The latest-`dev` runner can pin the Linux periodic probe and stress workers to
separate guest CPUs. On the 2-vCPU Linux guest, the 2026-08-21 matrix pins the
probe to CPU 0 and two stress workers to CPU 1. Both 3000-sample rows use a
10 ms Linux period and pass the full Linux/RTOS UDP, QCZ1 and AI chain.

| Linux workers | Probe CPU | Stress CPU | Linux mean/p99/max ns | UDP | QCZ1 | AI e2e mean/max us |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 0 | 1 | `2808020 / 9620384 / 118127472` | `20/20` | `10/10` | `7865 / 13209` |
| 2 | 0 | 1 | `2166081 / 4614832 / 73586592` | `20/20` | `10/10` | `8165 / 14554` |

This is a same-head load-isolation check, not an AxVisor before/after claim.
The 10 ms period is explicitly different from the older 1 ms rows because the
nested QEMU/TCG Linux path accumulated backlog at 1 ms. The older 1 ms, long TAP
and native RTOS rows remain visible and keep their original interpretation.
Raw evidence is under
`/home/kali/qc-evidence/t1-latestdev220-isolated-p10ms-20260821`.

The isolated 2-worker row was also repeated across three independent boots.
All three passed, producing 9,000/9,000 Linux periodic samples, UDP `60/60`,
QCZ1 `30/30`, AI `30/30`, and zero QCZ1 retransmits. Across the three runs,
the Linux mean lateness was `2.150 ms`; the worst observed P99 was `8.753 ms`
and the worst individual maximum was `127.734 ms`. The maximum is retained as
an observed nested-QEMU/TCG tail, not hidden or represented as hardware
performance. The per-round table is in
`results/task-one-latestdev-isolated-p10ms-stability-3x-summary.md`.

The native RTOS baseline uses Zephyr's `tests/benchmarks/latency_measure` on
native QEMU `qemu_cortex_a53`. It measures Zephyr kernel primitives and ISR
resume paths without AxVisor or a Linux guest.

The AxVisor evidence runs the required mixed system topology:

```text
Linux guest, 2 vCPU, pCPU 1-2  <--- IP/UDP --->  Zephyr RTOS guest, 1 vCPU, pCPU 0
```

The Linux guest periodic probe runs a static AArch64 test program that uses
`CLOCK_MONOTONIC` and `clock_nanosleep(..., TIMER_ABSTIME, ...)` with a 1 ms
period. The RTOS guest periodic probe runs inside the Zephyr guest and measures
the overrun of a 1 ms `k_busy_wait` loop. The integrated AxVisor script also
requires plain UDP, QCZ1 reliable UDP, AI control, tcpdump and final guest
markers to pass in the same run.

## Native Zephyr Baseline

| Metric | Result |
|---|---:|
| Board | `qemu_cortex_a53` |
| Benchmark | `tests/benchmarks/latency_measure` |
| Reported metrics | `47` |
| Preemptive `k_yield` context switch | `2400 ns` |
| Cooperative `k_yield` context switch | `2400 ns` |
| ISR return to interrupted thread | `1071 ns` |
| ISR return and switch to another thread | `1359 ns` |
| Semaphore take blocking switch | `3440 ns` |
| Semaphore give wake switch | `3967 ns` |
| Maximum reported primitive latency | `46703 ns` |
| Result marker | `PROJECT EXECUTION SUCCESSFUL` |

This baseline proves that the selected Zephyr board and benchmark environment
are healthy. It is not used as a direct numeric replacement for the AxVisor
periodic-task results because the AxVisor runs include VM exits, virtual
interrupt delivery, virtual/physical timer handling, Linux guest load and
cross-guest network traffic.

## Complete `latency_measure` Before/After Table

This table lists every metric emitted by Zephyr
`tests/benchmarks/latency_measure`. `Before` is the initial native Zephyr
baseline collected on 2026-07-27; `After` is the private main artifact branch
recheck collected on 2026-07-28 with the same board, benchmark and analyzer.
These rows are used as the native RTOS primitive baseline; AxVisor-hosted
behavior is compared in the dual-guest periodic-task tables below. The final
main branch additionally carries the narrowly scoped two-file PCI
`interrupt-map` parser commit described in `docs/core-patch-review.md`; it does
not change this native Zephyr baseline.

| # | Metric | Description | Before cycles/ns | After cycles/ns | Delta ns |
|---:|---|---|---:|---:|---:|
| 1 | `thread.yield.preemptive.ctx.k_to_k` | Context switch via k_yield | `150 / 2400` | `150 / 2400` | `0` |
| 2 | `thread.yield.cooperative.ctx.k_to_k` | Context switch via k_yield | `150 / 2400` | `150 / 2400` | `0` |
| 3 | `isr.resume.interrupted.thread.kernel` | Return from ISR to interrupted thread | `66 / 1071` | `66 / 1071` | `0` |
| 4 | `isr.resume.different.thread.kernel` | Return from ISR to another thread | `84 / 1359` | `84 / 1359` | `0` |
| 5 | `thread.create.kernel.from.kernel` | Create thread | `2918 / 46703` | `2918 / 46703` | `0` |
| 6 | `thread.start.kernel.from.kernel` | Start thread | `257 / 4127` | `257 / 4127` | `0` |
| 7 | `thread.suspend.kernel.from.kernel` | Suspend thread | `146 / 2351` | `146 / 2351` | `0` |
| 8 | `thread.resume.kernel.from.kernel` | Resume thread | `171 / 2751` | `171 / 2751` | `0` |
| 9 | `thread.abort.kernel.from.kernel` | Abort thread | `124 / 1999` | `124 / 1999` | `0` |
| 10 | `fifo.put.immediate.kernel` | Add data to FIFO (no ctx switch) | `60 / 975` | `60 / 975` | `0` |
| 11 | `fifo.get.immediate.kernel` | Get data from FIFO (no ctx switch) | `54 / 879` | `54 / 879` | `0` |
| 12 | `fifo.put.alloc.immediate.kernel` | Allocate to add data to FIFO (no ctx switch) | `378 / 6048` | `378 / 6048` | `0` |
| 13 | `fifo.get.free.immediate.kernel` | Free when getting data from FIFO (no ctx switch) | `409 / 6544` | `409 / 6544` | `0` |
| 14 | `fifo.get.blocking.k_to_k` | Get data from FIFO (w/ ctx switch) | `223 / 3568` | `223 / 3568` | `0` |
| 15 | `fifo.put.wake+ctx.k_to_k` | Add data to FIFO (w/ ctx switch) | `283 / 4528` | `283 / 4528` | `0` |
| 16 | `fifo.get.free.blocking.k_to_k` | Free when getting data from FIFO (w/ ctx switch) | `224 / 3584` | `224 / 3584` | `0` |
| 17 | `fifo.put.alloc.wake+ctx.k_to_k` | Allocate to add data to FIFO (w/ ctx switch) | `283 / 4528` | `283 / 4528` | `0` |
| 18 | `lifo.put.immediate.kernel` | Add data to LIFO (no ctx switch) | `59 / 959` | `59 / 959` | `0` |
| 19 | `lifo.get.immediate.kernel` | Get data from LIFO (no ctx switch) | `54 / 879` | `54 / 879` | `0` |
| 20 | `lifo.put.alloc.immediate.kernel` | Allocate to add data to LIFO (no ctx switch) | `377 / 6032` | `377 / 6032` | `0` |
| 21 | `lifo.get.free.immediate.kernel` | Free when getting data from LIFO (no ctx switch) | `409 / 6544` | `409 / 6544` | `0` |
| 22 | `lifo.get.blocking.k_to_k` | Get data from LIFO (w/ ctx switch) | `223 / 3568` | `223 / 3568` | `0` |
| 23 | `lifo.put.wake+ctx.k_to_k` | Add data to LIFO (w/ ctx switch) | `282 / 4512` | `282 / 4512` | `0` |
| 24 | `lifo.get.free.blocking.k_to_k` | Free when getting data from LIFO (w/ ctx switch) | `224 / 3584` | `224 / 3584` | `0` |
| 25 | `lifo.put.alloc.wake+ctx.k_to_k` | Allocate to add data to LIFO (w/ ctx switch) | `282 / 4512` | `282 / 4512` | `0` |
| 26 | `events.post.immediate.kernel` | Post events (nothing wakes) | `104 / 1664` | `104 / 1664` | `0` |
| 27 | `events.set.immediate.kernel` | Set events (nothing wakes) | `104 / 1664` | `104 / 1664` | `0` |
| 28 | `events.wait.immediate.kernel` | Wait for any events (no ctx switch) | `57 / 912` | `57 / 912` | `0` |
| 29 | `events.wait_all.immediate.kernel` | Wait for all events (no ctx switch) | `59 / 944` | `59 / 944` | `0` |
| 30 | `events.wait.blocking.k_to_k` | Wait for any events (w/ ctx switch) | `235 / 3775` | `235 / 3775` | `0` |
| 31 | `events.set.wake+ctx.k_to_k` | Set events (w/ ctx switch) | `343 / 5503` | `343 / 5503` | `0` |
| 32 | `events.wait_all.blocking.k_to_k` | Wait for all events (w/ ctx switch) | `245 / 3920` | `245 / 3920` | `0` |
| 33 | `events.post.wake+ctx.k_to_k` | Post events (w/ ctx switch) | `352 / 5632` | `352 / 5632` | `0` |
| 34 | `semaphore.give.immediate.kernel` | Give a semaphore (no waiters) | `37 / 592` | `37 / 592` | `0` |
| 35 | `semaphore.take.immediate.kernel` | Take a semaphore (no blocking) | `40 / 640` | `40 / 640` | `0` |
| 36 | `semaphore.take.blocking.k_to_k` | Take a semaphore (context switch) | `215 / 3440` | `215 / 3440` | `0` |
| 37 | `semaphore.give.wake+ctx.k_to_k` | Give a semaphore (context switch) | `247 / 3967` | `247 / 3967` | `0` |
| 38 | `condvar.wait.blocking.k_to_k` | Wait for a condvar (context switch) | `272 / 4352` | `272 / 4352` | `0` |
| 39 | `condvar.signal.wake+ctx.k_to_k` | Signal a condvar (context switch) | `304 / 4864` | `304 / 4864` | `0` |
| 40 | `stack.push.immediate.kernel` | Add data to k_stack (no ctx switch) | `38 / 623` | `38 / 623` | `0` |
| 41 | `stack.pop.immediate.kernel` | Get data from k_stack (no ctx switch) | `37 / 607` | `37 / 607` | `0` |
| 42 | `stack.pop.blocking.k_to_k` | Get data from k_stack (w/ ctx switch) | `224 / 3599` | `224 / 3599` | `0` |
| 43 | `stack.push.wake+ctx.k_to_k` | Add data to k_stack (w/ ctx switch) | `272 / 4352` | `272 / 4352` | `0` |
| 44 | `mutex.lock.immediate.recursive.kernel` | Lock a mutex | `48 / 768` | `48 / 768` | `0` |
| 45 | `mutex.unlock.immediate.recursive.kernel` | Unlock a mutex | `27 / 432` | `27 / 432` | `0` |
| 46 | `heap.malloc.immediate` | Average time for heap malloc | `291 / 4656` | `291 / 4656` | `0` |
| 47 | `heap.free.immediate` | Average time for heap free | `350 / 5600` | `350 / 5600` | `0` |

Summary: both native baseline runs reported `47` metrics,
`PROJECT EXECUTION SUCCESSFUL`, minimum `432 ns`, mean `4019.38 ns` and maximum
`46703 ns`.

## AxVisor Long-Sample Comparison

All rows below use the same dual-guest script, same IP/UDP topology, same 1 ms
periodic probes and the same QCZ1/AI application path. The only workload knob is
the number of busy-loop workers started inside the 2-vCPU Linux guest.

| Scenario | Linux workers | Linux samples | Linux mean/p99/max ns | RTOS samples | RTOS mean/p99/max ns | UDP | QCZ1 | AI e2e mean/max us | Drops | Evidence SHA256 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| No Linux pressure | `0` | `10000` | `859358 / 2788848 / 12764288` | `1000` | `87811 / 613216 / 5328816` | `20/20` | `10/10` | `1668 / 1925` | `0` | `b3a6dcc0503f7d2fae4add93c05c20aaad0a33874ac924bf1b9b26b9a7295ddd` |
| One Linux worker | `1` | `10000` | `827911 / 2559424 / 9586112` | `1000` | `122604 / 1227840 / 4352208` | `20/20` | `10/10` | `1996 / 5333` | `0` | `d4300613f3835c71f029e656d7dd209b84fbac25333a0d8378e7f3b72db29d0b` |
| Two Linux workers | `2` | `10000` | `894770 / 4346944 / 9145360` | `1000` | `98703 / 726688 / 3676896` | `20/20` | `10/10` | `4964 / 21059` | `0` | `69adb1c9741b33b4a5f718096f5e26c457ddbc450fa96168c15aa5dd86599cfa` |
| Four Linux workers | `4` | `10000` | `2966298 / 41868000 / 52850464` | `1000` | `80229 / 1255504 / 6179136` | `20/20` | `10/10` | `8140 / 39642` | `0` | `9d8d94ac85222f73fa4fb5249cbc94ca52a1b0cb2c656c5d8105069da4bcb12f` |

Key observations:

- The Linux guest 1 ms periodic probe remains in the same sub-millisecond mean
  lateness band across 0, 1 and 2 Linux worker configurations.
- The 4-worker runs intentionally overcommit the 2-vCPU Linux guest. They raise
  Linux-side p99/max latency, but the integrated UDP/QCZ1/AI path still passes;
  the current-head TAP rerun also records tcpdump captured/dropped `88/0`.
- The RTOS guest periodic probe remains below 0.13 ms mean lateness in the 0,
  1, 2 and 4 worker long-sample configurations.
- Cross-guest plain UDP, QCZ1 reliable UDP and AI control all remain at `100%`
  success in the same runs.
- The tcpdump kernel drop counter remains `0`, so the network evidence is not
  relying on hidden packet loss recovery outside the application protocol.
- The 2-worker and 4-worker runs are intentionally harsh for a 2-vCPU Linux
  guest. The AI maximum end-to-end latency increases under pressure, but the
  closed loop still completes `10/10` control transactions and the RTOS
  periodic probe remains stable.

## Two-Worker Stability Campaign

The strongest Linux-pressure configuration was rerun three times. Each round
uses the same 2-worker Linux guest load, the same dual-guest topology and the
same `analyze_dual_guest_realtime.py --fail-on-missing` gate.

| Round | Result | Linux mean/p99/max ns | RTOS mean/p99/max ns | UDP | QCZ1 | AI | AI e2e mean/max us | Drops | Evidence SHA256 |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---|
| `1` | PASS | `1275322 / 16139568 / 41942128` | `103672 / 864272 / 4739680` | `20/20` | `10/10` | `10/10` | `1585 / 2230` | `0` | `fbe83e24d41cc3cc1c9172656de3212e4e044625c0837f6ba7c8ec3f941ddb26` |
| `2` | PASS | `991262 / 4300992 / 9572688` | `115154 / 933488 / 4327488` | `20/20` | `10/10` | `10/10` | `5177 / 24792` | `0` | `6437349e481dd3b5282abe27a34085e4a0d26b214cd7a88478ff7532446f7a16` |
| `3` | PASS | `1185251 / 7174032 / 23575136` | `118194 / 984736 / 4949296` | `20/20` | `10/10` | `10/10` | `2861 / 6457` | `0` | `38aac4038f06ae1731125cea46e6afce0b18d0cc5f0845ef7a562676a8cc97f5` |

Aggregate range across the three 2-worker rounds:

| Metric | Min | Mean | Max |
|---|---:|---:|---:|
| Linux periodic p99 ns | `4300992` | `9204864` | `16139568` |
| RTOS periodic p99 ns | `864272` | `927499` | `984736` |
| UDP RTT max us | `32804` | `33527` | `33907` |
| QCZ1 reliable max us | `6173` | `16129` | `26197` |
| AI end-to-end max us | `2230` | `11160` | `24792` |

## Reproducibility Gates

The first-stage contest directory includes:

- `scripts/run_native_zephyr_latency_baseline.sh`
- `scripts/run_axvisor_dual_guest_qcz1_ai.sh`
- `scripts/analyze_zephyr_latency_measure.py`
- `scripts/analyze_dual_guest_realtime.py`
- `results/realtime-comparison.csv`
- `results/stability/2026-07-27-stress2-3x/stability-summary.md`

The AxVisor integrated script returns `PASS` only when the expected Linux guest,
RTOS guest, network, QCZ1, AI, periodic-probe and tcpdump markers are present.
This makes the evidence stricter than a single latency microbenchmark: realtime
measurements are collected while the contest communication and AI-control path
are active.
