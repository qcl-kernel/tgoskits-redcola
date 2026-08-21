# Task-One 30-Point Reviewer Checklist

This page maps the task-one realtime score items directly to redcola evidence.
It is meant to help reviewers evaluate the 30-point realtime section without
searching across every design, test and result file.

The main claim is deliberately narrow: redcola improves and validates the
AxVisor AArch64 timer/interrupt delivery path needed by a Zephyr RTOS guest in
a mixed Linux/RTOS dual-guest workload. It does not claim that the prototype is
a certified hard-real-time industrial kernel.

The final package is generated from private PR `#1`; its generated `README.txt`
records the exact selected source head. The 2026-08-22 clean-head pre-final
dry run reports `FINAL_PACKAGE_BUILD=PASS`, `FINAL_PACKAGE_VERIFY=PASS` and
`79` files with the PPTX and narration DOCX included; the presentation strict
gate also passes. The final remaining strict gate is the user-narrated video.
Historical checkpoint hashes remain in
`docs/final-package.md` and are not presented as the final archive identity.

## Reviewer Snapshot

This is the shortest task-one scoring path. It separates the points that are
ready for review from the boundaries that should not be overclaimed.

| Scoring gate | Review status | Fast proof |
| --- | --- | --- |
| Realtime target and key-path analysis | Ready | Timer/vTimer expiry, target-vCPU wakeup and GIC completion are named as the defended realtime path in `docs/task-one-realtime-core-claim.md`. |
| Substantive AxVisor mechanism change | Ready | Merged upstream anchor `rcore-os/tgoskits#1770`, commit `024ecca10a4240a84b2c24bed2dc2361a6043d3e`, records the AArch64 physical-timer support change. |
| Multi-vCPU Linux guest | Ready | The mixed workload rows keep Linux at `2` vCPUs while Zephyr RTOS, UDP/QCZ1 and AI probes remain active. |
| Before/after latency data | Ready, with visible outliers | Hub 0/1/2-worker rows show RTOS p99 improvement; the 2-worker max outlier is reported rather than hidden. TAP 0/2-worker rows add packet capture with tcpdump `88/0`. |
| Empty/stress/long-pressure coverage | Ready | Evidence covers 0/1/2-worker comparison, 4-worker overcommit boundary, `30000`-sample long hub/TAP rows and exact-head 3-run 2-worker stability. |
| Native RTOS baseline | Ready | Native Zephyr latency baseline records `47` metrics and `PROJECT EXECUTION SUCCESSFUL`, with measurement caveats documented. |

Remaining boundary: hardware-board validation and a certified hard-real-time
kernel claim are intentionally outside this checkpoint. The submission defends
a reproducible AxVisor timer/interrupt realtime-support path for the mixed
Linux/RTOS prototype.

## Scoring Coverage

| Official scoring detail | Points | Current coverage | Evidence to inspect | Conservative boundary |
| --- | ---:| --- | --- | --- |
| Realtime target and key-path analysis | `4` | The realtime-critical path is identified as AArch64 physical timer virtualization, virtual timer expiry, target vCPU wakeup and GIC completion under a mixed Linux/RTOS workload. | `docs/task-one-realtime-core-claim.md`, `docs/realtime-evaluation.md`, `docs/core-patch-review.md` | The claim focuses on timer/interrupt determinism, not a full RTOS rewrite of AxVisor. |
| Substantive AxVisor key-mechanism modification | `8` | The landed support anchor is PR `rcore-os/tgoskits#1770`, commit `024ecca10a4240a84b2c24bed2dc2361a6043d3e`, covering physical timer state virtualization, per-vCPU timer state, expiry routing and cross-CPU timer cancellation. | `docs/task-one-realtime-core-claim.md`, `docs/core-patch-review.md`, upstream PR `#1770` | Main contest PR `#1` keeps artifact code separate; core changes are tracked through the merged upstream support PR. |
| Multi-vCPU Linux guest configuration | `4` | The dual-guest runs keep Linux at `2` vCPUs and Zephyr as the RTOS guest while the network and AI loops stay active. | `docs/design.md`, `docs/network-topology.md`, `docs/task-one-score-summary.md`, runtime summaries with `QC_DUAL_GUEST_LINUX_INIT=PASS` | Physical CPU binding is documented at the QEMU/AxVisor prototype level; hardware-board binding can be refined if RK3576 validation is added later. |
| Before/after realtime data and worst-case visibility | `5` | 10000-sample hub before/after rows cover 0/1/2-worker pressure points, with p99/max values and outliers preserved. TAP before/after rows add packet-captured 0/2-worker proof. Current-head 30000-sample 2-worker hub/TAP rows and 4-worker hub/TAP overcommit rows extend the long-pressure stability evidence. Recorded 2026-08-15 checkpoint head `746042293` adds a 3-run 2-worker repeat, and recorded head `a9ceb7dc` adds an additional 30000-sample 2-worker hub proof that is included in the package manifest. | `results/task-one-before-after-hub-summary.csv`, `results/task-one-before-after-tap-summary.csv`, `results/task-one-current-head-long-hub-r30000-summary.csv`, `results/task-one-current-head-long-hub4-r30000-summary.csv`, `results/task-one-current-head-long-tap-r30000-summary.csv`, `results/task-one-current-head-long-tap4-r30000-summary.csv`, `results/task-one-head746-2w-hub-stability-r30000-summary.csv`, `results/task-one-head-a9ce-long-hub-r30000-summary.csv`, `docs/task-one-score-summary.md` | The 2-worker after-side RTOS max outlier is reported openly and is not hidden behind only p99 numbers. |
| Empty and stress-pressure scenarios | `4` | Evidence includes 0-worker no-pressure, 1-worker middle pressure, 2-worker pressure and 4-worker overcommit boundary rows, plus the recorded 2026-08-15 head `746042293` 2-worker stability repeat (`3/3 PASS`) and a 4-worker TAP/tcpdump overcommit row. | `docs/task-one-score-summary.md`, `docs/second-version-reviewer-quickstart.md`, `results/task-one-head746-2w-hub-stability-r30000-summary.md`, `results/stability/2026-07-27-stress2-3x/stability-summary.md` | The 4-worker rows are treated as 2-vCPU Linux overcommit boundary and stability/completion proof, not the primary latency-improvement claim. |
| Native RTOS baseline and reproducibility | `5` | Native Zephyr latency baseline records 47 metrics and `PROJECT EXECUTION SUCCESSFUL`; reproduction docs keep commands, scripts and artifact boundaries explicit. | `docs/realtime-evaluation.md`, `docs/reproduce.md`, `docs/test-report.md`, `scripts/run_task_one_second_version_matrix.sh`, `scripts/run_task_one_before_after_tap_matrix.sh` | Native Zephyr does not include AxVisor VM exits or Linux load, so it is used as a platform sanity baseline rather than a one-to-one virtualized latency replacement. |

## Evidence Strength By Requirement

| Requirement family | Strongest current proof |
| --- | --- |
| Timer/interrupt mechanism | Merged PR `#1770` plus `docs/task-one-realtime-core-claim.md`. |
| Mixed-system runtime | Dual guest run with Linux `2` vCPUs, Zephyr RTOS, UDP/QCZ1/AI all active. |
| Long-sample latency | 10000-sample hub before/after rows at 0/1/2-worker pressure. |
| Recorded long pressure proof | Recorded 2026-08-15 head `746042293` has a 3-run, 2-worker, 30000-sample hub stability repeat. Prior head `b706a02c` has a 30000-sample hub matrix at 0/1/2/4 Linux workers. Earlier 30000-sample TAP/tcpdump rows from head `91cb7c0f` provide packet capture and 4-worker TAP overcommit evidence. Recorded head `a9ceb7dc` has an additional 30000-sample 2-worker hub proof with UDP `20/20`, QCZ1 `10/10`, AI `10/10` and no missing markers. |
| Packet-captured network proof | TAP before/after matrix reports tcpdump captured/dropped `88/0` in every row. |
| Stress and stability | 1/2/4-worker pressure rows and 2-worker stability campaign. |
| RTOS baseline | Native Zephyr latency benchmark with 47 metrics. |
| Reproducibility | `docs/reproduce.md`, result CSV summaries and final package verifier. |

## Key Numbers To Quote

Use these numbers in the final video or second-version review note:

```text
0-worker hub RTOS p99: 1.323 ms -> 0.761 ms
0-worker hub RTOS max: 8.055 ms -> 1.773 ms
1-worker hub RTOS p99: 1.124 ms -> 0.782 ms
2-worker hub RTOS p99: 1.454 ms -> 0.993 ms
Recorded 30000-sample 0-worker hub RTOS p99/max: 1.372 ms / 3.525 ms
Recorded 30000-sample 1-worker hub RTOS p99/max: 1.073 ms / 10.214 ms
Recorded 30000-sample 2-worker hub RTOS p99/max: 0.820 ms / 3.564 ms
Exact submitted-head 2-worker hub stability: 3/3 PASS
Exact submitted-head 2-worker hub RTOS p99/max range: 0.883-1.040 ms / 2.044-3.081 ms
Recorded a9ceb7dc 2-worker hub RTOS p99/max: 1.115 ms / 5.921 ms
Current-head 30000-sample 2-worker TAP RTOS p99/max: 1.962 ms / 9.954 ms
Recorded 30000-sample 4-worker hub RTOS p99/max: 0.931 ms / 2.067 ms
Current-head 30000-sample 4-worker TAP RTOS p99/max: 1.822 ms / 31.445 ms
TAP matrix: 4/4 PASS, tcpdump captured/dropped 88/0 in every row
Linux guest: 2 vCPUs
Plain UDP: 20/20 PASS
QCZ1 reliable UDP: 10/10 PASS
AI control: 10/10 PASS
Native Zephyr baseline: 47 metrics, PROJECT EXECUTION SUCCESSFUL
```

## Review Path

For a fast task-one review:

1. Read `docs/task-one-reviewer-defense-qna.md` for the short defense path.
2. Read `docs/task-one-realtime-core-claim.md` for the exact core claim.
3. Read `docs/task-one-score-summary.md` for the before/after deltas.
4. Check `results/task-one-before-after-tap-summary.md` for packet-captured
   TAP rows.
5. Check `docs/realtime-evaluation.md` for the native Zephyr baseline and
   measurement caveats.
6. Use `docs/reproduce.md` for the commands and runtime artifact contract.

## What Is Not Claimed

- No password, token, rootfs image, QEMU image or raw pcap is committed to git.
- Hub and TAP measurements are not mixed as identical network paths.
- The native Zephyr baseline is not presented as equivalent to the
  AxVisor-hosted mixed-system workload.
- StarryOS bonus evidence is evaluated separately from this task-one realtime
  score.
- Hardware-board validation remains a future extension unless a later final
  submission adds RK3576 or another board evidence set.
