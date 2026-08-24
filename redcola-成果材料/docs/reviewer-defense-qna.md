# Reviewer Defense Q&A

This note is a short answer bank for the 2026 Quancheng AxVisor contest
second-version review and final defense. It is intentionally conservative: it
states what is proven by the submitted artifacts, and separates completed
evidence from bonus or future extension work.

## One-Minute Positioning

redcola submits an AxVisor mixed-system prototype that runs a Linux non-RT
guest and a Zephyr RTOS guest in the same QEMU AArch64 setup. The main data
channel is IPv4/UDP, not shared memory or HyperCall. On top of UDP, QCZ1 adds a
versioned application frame, sequence/timestamp fields, status/error fields,
checksum validation, ACK handling, duplicate-response coverage and timeout
paths. The Linux side runs deterministic AI-control inference and sends the
model output to the RTOS side; the RTOS side applies the output to an observable
control state and returns status.

Task-one realtime evidence is centered on the landed AxVisor timer/interrupt
support anchor `rcore-os/tgoskits#1770`, native Zephyr baseline data,
before/after hub comparisons, TAP/tcpdump packet-captured before/after rows and
current-head `30000`-sample long-pressure hub/TAP rows.

## Likely Questions

### Q1. What exactly is the task-one realtime claim?

The claim is not that AxVisor has become a full RTOS. The claim is narrower:
the submission identifies AxVisor timer/interrupt delivery as the key path,
uses merged support PR `#1770` as the landed support anchor, and validates the
mixed Linux/RTOS workload before and after that support point. The evidence
shows periodic-task metrics, worst-case values, stress rows, TAP packet capture
and a native Zephyr RTOS baseline.

Evidence to show:

```text
docs/task-one-realtime-core-claim.md
docs/task-one-score-summary.md
results/task-one-second-version-summary.md
```

### Q2. How is the before/after comparison kept fair?

Both sides use the same workload shape: Linux guest with `2` vCPUs, Zephyr RTOS
guest, 1 ms Linux periodic probe, 1 ms RTOS periodic probe, UDP `20/20`, QCZ1
`10/10`, AI `10/10`, and the same worker-count categories. The result tables
keep unfavorable outliers visible instead of hiding them. The `4`-worker row is
labelled as a 2-vCPU overcommit boundary, not as the main latency-improvement
claim.

Evidence to show:

```text
results/task-one-before-after-hub-summary.md
results/task-one-before-after-tap-summary.md
docs/task-one-score-summary.md
```

### Q3. What is the strongest current-head task-one proof?

The strongest current-head proof is the `30000`-sample long TAP/tcpdump row. It
keeps the packet-captured Linux/RTOS network path active while the periodic
probe, plain UDP, QCZ1 and AI loop complete:

```text
TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS
linux_rt_samples=30000
linux_stress_workers=2
Linux guest vCPUs=2
UDP=20/20
QCZ1=10/10
QCZ1 retransmits=0
AI=10/10
AI e2e mean/max=2501 us / 5014 us
tcpdump captured/dropped=88/0
```

Evidence to show:

```text
results/task-one-current-head-long-tap-r30000-summary.md
results/task-one-second-version-summary.md
```

### Q4. Is the current-head result repeatable, or only one successful run?

The exact submitted-head repeat was run three times with the same 2-worker,
`30000`-sample hub pressure shape after the analyzer was hardened against
serial-log interleaving of the RTOS result marker. All three rows report
`TASK_ONE_SECOND_VERSION_MATRIX=PASS`, Linux `2` vCPUs, UDP `20/20`, QCZ1
`10/10`, AI `10/10`, no missing markers, and RTOS p99/max ranges of
`882896-1040304 / 2043904-3080560 ns`.

Evidence to show:

```text
results/task-one-head746-2w-hub-stability-r30000-summary.md
docs/second-version-submission-status.md
```

### Q5. Why is TAP/tcpdump important if hub mode also passes?

Hub mode is useful for repeatable QEMU-side runs and long before/after
comparisons. TAP mode adds host-visible packet capture, so it is better proof
for IP networking, isolation boundary and packet-loss accounting. The final
video should prefer TAP, or clearly label a hub run as a live rehearsal while
showing the recorded TAP summaries separately.

Evidence to show:

```text
docs/network-topology.md
results/task-one-before-after-tap-summary.md
results/task-one-current-head-long-tap-r30000-summary.md
```

### Q6. Does the communication path meet the IP-network requirement?

Yes. The main channel is IPv4/UDP between Linux `192.0.2.10` and Zephyr RTOS
`192.0.2.20`, UDP port `4242`. QCZ1 runs above UDP. Shared memory, HyperCall,
bare MMIO and vsock are not used as the primary data channel.

Evidence to show:

```text
docs/network-topology.md
docs/protocol.md
docs/task-two-three-50-point-checklist.md
```

### Q7. What reliability mechanisms are implemented on UDP?

QCZ1 adds a fixed header with magic/version/type/length/sequence/timestamp,
status and checksum fields. The Linux client validates responses, tracks ACKs,
handles duplicate responses, reports retransmit counts and requires status
validation. The submitted integrated runs report QCZ1 `10/10`, retransmits `0`
and duplicate-ACK coverage.

Evidence to show:

```text
docs/protocol.md
linux/qc_qcz1_guest_demo.c
rtos/zephyr_udp_qc_protocol_udp.c
results/task-one-current-head-long-tap-r30000-summary.md
```

### Q8. What proves the AI closed loop?

The Linux side computes a deterministic AI-control output and sends it in QCZ1
control frames. The RTOS side applies the output to a control state and returns
ACK/status. Integrated runs require `QC_AI_CONTROL_RESULT=PASS`, `AI=10/10`
and final status validation. The long TAP row also keeps AI `10/10` while
tcpdump capture is active.

Evidence to show:

```text
docs/ai-control-evaluation.md
docs/task-two-three-score-summary.md
linux/qc_ai_control_demo.py
results/task-one-current-head-long-tap-r30000-summary.md
```

### Q9. How is AI latency measured?

The main submitted measurement uses the Linux side as the measuring endpoint:
it records inference time and end-to-end request/response time around the QCZ1
exchange. This avoids depending on unsynchronized Linux/RTOS clocks. The method
is conservative and reproducible, and the error sources are documented.

Evidence to show:

```text
docs/ai-control-evaluation.md
docs/test-report.md
```

### Q10. What is the StarryOS bonus boundary?

The StarryOS branch is submitted as bonus evidence, not as a replacement for
the main Linux/RTOS AxVisor loop. It demonstrates a StarryOS QEMU non-RT guest
running a deterministic AI-control demo and QCZ1 frame-parity path. The team
does not claim the separate StarryOS syscall/ABI bonus item in this branch.

Evidence to show:

```text
docs/starryos-bonus.md
docs/starryos-bonus-scorecard.md
qcl-kernel/tgoskits-redcola#2
```

### Q11. What are the honest limitations?

- The strongest hardware-independent proof is QEMU AArch64; no board-specific
  final claim is made in this PR.
- The `4`-worker row is an overcommit boundary and not a latency-improvement
  claim.
- StarryOS evidence is a bonus non-RT guest demonstration, not the full
  replacement of all main Linux/RTOS tasks.
- Raw QEMU logs, pcaps and runtime images are kept outside git and referenced
  by evidence path and summary hashes to keep the repository reviewable.

These limitations are already reflected in the submitted docs so that the
review focuses on reproducible, bounded evidence rather than broad claims.

## Closing Answer

If asked for the shortest summary:

```text
The main score comes from a reproducible AxVisor Linux/Zephyr mixed-system
prototype with IP-based Linux/RTOS communication, a reliable QCZ1 UDP protocol,
AI-to-RTOS control linkage, native RTOS baseline data, before/after realtime
comparison, TAP/tcpdump packet-captured evidence and current-head 30000-sample
long-pressure proof. StarryOS is submitted separately as bonus evidence.
```
