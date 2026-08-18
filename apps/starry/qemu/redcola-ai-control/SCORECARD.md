# Redcola StarryOS Bonus Scorecard

This scorecard maps the StarryOS bonus branch to the Quancheng 2026 AxVisor
contest scoring items. It is intentionally conservative: the complete AxVisor
Linux/RTOS network and RTOS control loop remain in PR `#1`, while this branch
focuses on StarryOS non-RT guest bonus evidence.

## Review Fast Path

| Question | Evidence |
| --- | --- |
| Where is the bonus code? | `apps/starry/qemu/redcola-ai-control/` |
| What does it run on? | StarryOS AArch64 QEMU guest. |
| How is it launched? | `cargo xtask starry app qemu -t qemu/redcola-ai-control --arch aarch64` |
| What proves the guest app ran? | `prebuild_marker=prebuild-ok` and `REDCOLA_STARRY_AI_DONE`. |
| What proves neural-network inference? | `REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0`. |
| What proves protocol alignment with PR `#1`? | `REDCOLA_STARRY_QCZ1_FRAME` and `REDCOLA_STARRY_QCZ1_PARITY_PASS`. |
| Where is validation recorded? | `VALIDATION.md`. |
| What should reviewers read first? | `REVIEWER-QUICKSTART.md`. |

## Bonus Mapping

| Scoring item | Current evidence | Boundary |
| --- | --- | --- |
| StarryOS instead of standard Linux | StarryOS boots in QEMU and executes the redcola AI-control workload as a Linux-user-mode program. | This is bonus evidence for the non-RT guest direction. The full Linux/RTOS mixed-system delivery stays in PR `#1`. |
| Neural-network inference | The guest program runs a deterministic fixed-point 4-input, 4-hidden-unit MLP over eight samples. | The model is small by design so reviewers can inspect and reproduce it easily. |
| Control effect comparison | The app compares fixed manual PWM with AI policy output: manual total absolute error is `1013`, AI total absolute error is `0`. | This proves the StarryOS-side AI-control workload, not a separate StarryOS-to-RTOS control link. |
| Protocol connection to main delivery | The app builds and self-checks a QCZ1 `CONTROL_SET` frame with magic, version, type, header length, payload length, sequence, checksum and payload. | This is protocol-shape parity with PR `#1`, not an extra network-channel claim. |
| Reproducibility | QEMU config records AArch64 `virt,gic-version=3`, NVMe rootfs device, success marker and timeout. | Generated rootfs images, logs and temporary toolchain wrappers are not committed. |
| StarryOS syscall improvement | Not claimed in this branch. | Keeps the syscall/ABI bonus separate from this AI demo. |

## What This Should Be Worth

This branch is meant to make the StarryOS bonus credible without overstating
it. The evidence supports the "StarryOS instead of standard Linux" direction
for the non-RT AI workload, plus protocol-shape parity with the main QCZ1
delivery. It does not try to claim the separate syscall/ABI bonus or a complete
StarryOS-to-RTOS network replacement.

| Bonus area | Strength | Why |
| --- | --- | --- |
| StarryOS non-RT guest | Strong | The app boots and runs inside StarryOS QEMU with explicit PASS/DONE markers. |
| AI-control workload | Strong | The deterministic MLP improves the manual baseline from `1013` total error to `0`. |
| Link to main delivery | Moderate to strong | QCZ1 `CONTROL_SET` frame parity ties the StarryOS app to the PR `#1` protocol design. |
| Full task replacement | Not claimed | No separate StarryOS-to-RTOS network channel is asserted in this branch. |
| StarryOS syscall improvement | Not claimed | No syscall or Linux ABI change is included. |

The intended score posture is therefore: strong support for the StarryOS
non-RT-guest bonus direction, while keeping the main 100-point proof anchored
in PR `#1`.

## Current Evidence Snapshot

Representative runtime evidence:

```text
/home/kali/qc-evidence/starry-qemu-redcola-qcz1-parity-head-4cbd22ccb837-20260814_103336
```

Representative markers:

```text
REDCOLA_STARRY_QCZ1_FRAME magic=QCZ1 version=1 type=CONTROL_SET header_len=28 payload_len=12 seq=9001 sample_id=1 checksum=0x1ac5c2ff frame_len=40
REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli=930 ai_score_milli=1000 sample_id=1
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0 mean_infer_us=82
REDCOLA_STARRY_AI_DONE
```

Evidence hashes:

```text
9e73e441e1028fdffdd4a4bdcb8fc64497e9cf505755c94ddf1a1e1956f54ddf  qemu.log
c81fd027897e0fdef72e36864791d1e99391c2d2681824820ff95fcf67befa33  summary.txt
```

Use this branch together with:

```text
Main AxVisor artifact: qcl-kernel/tgoskits-redcola#1
StarryOS bonus artifact: qcl-kernel/tgoskits-redcola#2
```

## Upgrade Path Toward A Fuller StarryOS Replacement

If more time is available before the final checkpoint, the next useful
extensions are:

1. Run the PR `#1` Linux-side QCZ1 client as a StarryOS user-mode workload.
2. Keep the same QCZ1 fields, sequence validation and status checks.
3. Reuse the existing RTOS-side Zephyr protocol server.
4. Report the same success markers: UDP/QCZ1/AI pass counts, status validation,
   end-to-end latency and AI/manual control error.
5. Keep this branch small and reviewable; any syscall or ABI improvement should
   be a separate change if it becomes necessary.

That path would turn the current StarryOS parity evidence into a stronger
"StarryOS as the non-RT guest" proof while preserving the clean boundary of the
current bonus PR.
