# Task-One Realtime Core Claim

This page is the short reviewer-facing claim for the task-one realtime score.
It connects the AxVisor core change, the before/after experiment anchors and
the conservative interpretation of the measured data.

## Core Change Being Claimed

The main landed AxVisor support anchor is:

```text
rcore-os/tgoskits#1770
024ecca10a4240a84b2c24bed2dc2361a6043d3e
axvisor: virtualize AArch64 physical timer state
```

The merged change affects the realtime-critical path used by the Zephyr RTOS
guest:

- virtualizes AArch64 physical timer compare/control state;
- adds guest-visible `CNTP_CVAL_EL0` and keeps `CNTP_CTL_EL0`,
  `CNTP_TVAL_EL0` and `CNTP_CVAL_EL0` in one timer state model;
- isolates virtual timer state per vCPU;
- queues virtual timer expiry to the target vCPU instead of relying on a
  legacy injection hook;
- supports cross-CPU timer cancellation and remote owner rearming;
- registers the AArch64 timer callback in the AxVisor host/device path;
- uses a hypervisor GIC EOI mode suitable for the dual-guest interrupt path;
- propagates explicit passthrough IRQ configuration into runtime VM config.

The claim is therefore not that AxVisor becomes a complete hard-RTOS kernel in
one patch. The claim is narrower and more defensible: the timer and interrupt
delivery path required by a Zephyr RTOS guest was made explicit, per-vCPU and
testable, then validated under the mixed Linux/RTOS workload required by the
contest.

## Before/After Anchors

| Role | Commit | Meaning |
| --- | --- | --- |
| Before baseline | `bb562428c69317faccf2761167d2fabc47b82a37` | Parent of the merged timer-support PR. |
| After support anchor | `024ecca10a4240a84b2c24bed2dc2361a6043d3e` | Merged AxVisor physical-timer support PR `#1770`. |
| Main submission branch | `qcl-kernel/tgoskits-redcola#1` | Contest docs, scripts, protocol code and evidence summaries. |

Runtime evidence source heads are recorded separately because the submission
branch continues to receive documentation and packaging updates after the QEMU
evidence is collected.

## Evidence That Raises The Task-One Score

| Scoring point | Evidence |
| --- | --- |
| Realtime target and key-path analysis | `docs/realtime-evaluation.md`, `docs/core-patch-review.md` and this file identify the AArch64 physical timer, virtual timer expiry, target vCPU wakeup and GIC completion path as the realtime-critical path. |
| Substantive AxVisor mechanism change | PR `#1770` changes 21 files across AxVisor config, `axvm`, `arm_vgic`, AArch64 vTimer support and GIC handling. |
| Multi-vCPU Linux guest | The dual-guest runs keep Linux at `2` vCPUs while Zephyr RTOS runs as the realtime guest. |
| Before/after data | 10000-sample hub before/after rows cover `0`, `1` and `2` Linux-worker pressure points; TAP before/after rows cover `0` and `2` workers with tcpdump counters. |
| Empty and stress scenarios | No-pressure, 1-worker, 2-worker and 4-worker overcommit rows are recorded. |
| Native RTOS baseline | Native Zephyr `latency_measure` reports `47` metrics and `PROJECT EXECUTION SUCCESSFUL`. |

## Conservative Before/After Conclusion

The strongest latency-improvement statement is the 10000-sample hub matrix:

| Linux workers | Defensible conclusion |
| ---:| --- |
| `0` | RTOS p99 improves `1.323 ms -> 0.761 ms`; RTOS max improves `8.055 ms -> 1.773 ms`; UDP/QCZ1/AI remain `100%`. |
| `1` | RTOS p99 improves `1.124 ms -> 0.782 ms`; RTOS max improves `5.085 ms -> 4.967 ms`; Linux p99/max also improve. |
| `2` | RTOS p99 improves `1.454 ms -> 0.993 ms`; the RTOS max has a larger after-side outlier and is reported openly. |
| `4` | This is an overcommit boundary on a 2-vCPU Linux guest. It proves completion under heavy pressure, not latency improvement. |

The TAP matrix adds the privileged packet-capture proof:

```text
TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS
/home/kali/qc-evidence/t1-before-after-tap-fixed-114047
```

All four TAP rows report Linux `2` vCPUs, plain UDP `20/20`, QCZ1 `10/10`,
AI `10/10`, QCZ1 retransmits `0`, no missing markers and tcpdump
captured/dropped `88/0`.

## Limits Not Hidden

- The native Zephyr baseline measures RTOS primitive latency without AxVisor or
  a Linux guest, so it is used as a platform sanity baseline rather than as a
  one-to-one replacement for virtualized periodic latency.
- The 4-worker row deliberately overcommits the 2-vCPU Linux guest and is not
  used as the main improvement claim.
- TAP and hub mode measure different host-network paths; TAP is the
  packet-capture proof, while the long hub rows give the broader 0/1/2/4
  latency trend.
- The current submission is a QEMU mixed-system prototype. It demonstrates
  determinism improvements and validation discipline, not a certified
  industrial hard-real-time guarantee.

## Reviewer Takeaway

Task one should be evaluated as a measured, scope-controlled realtime
improvement around AxVisor's timer/interrupt delivery path. The submission
keeps the communication and AI loops active during realtime measurement, uses
the same 2-vCPU Linux guest across the rows, provides a pre-`#1770` baseline,
and records both long-sample latency tables and packet-captured TAP evidence.
