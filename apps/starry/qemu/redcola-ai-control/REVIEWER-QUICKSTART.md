# Redcola StarryOS Bonus Reviewer Quickstart

This is the shortest review path for the redcola StarryOS bonus PR. It should
be read together with the main AxVisor artifact PR `#1`, which contains the
full Linux/RTOS dual-guest network and RTOS control loop.

## What To Review

| Item | Evidence |
| --- | --- |
| Bonus path | `apps/starry/qemu/redcola-ai-control/` |
| Guest | StarryOS AArch64 QEMU guest |
| Run command | `cargo xtask starry app qemu -t qemu/redcola-ai-control --arch aarch64` |
| StarryOS execution proof | `prebuild_marker=prebuild-ok` and `REDCOLA_STARRY_AI_DONE` |
| AI inference proof | `REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0` |
| Control-quality proof | manual total absolute error `1013`, AI total absolute error `0` |
| Protocol-alignment proof | `REDCOLA_STARRY_QCZ1_FRAME` and `REDCOLA_STARRY_QCZ1_PARITY_PASS` |
| Full validation note | `VALIDATION.md` |
| Score mapping | `SCORECARD.md` |

## Required Runtime Markers

A passing QEMU run should contain:

```text
REDCOLA_STARRY_AI_BEGIN guest=StarryOS role=non_rt_guest model=fixed_point_mlp_policy hidden=4
prebuild_marker=prebuild-ok
REDCOLA_STARRY_CONTROL_SUMMARY manual_abs_error=1013 ai_abs_error=0 max_ai_error=0
REDCOLA_STARRY_QCZ1_FRAME magic=QCZ1 version=1 type=CONTROL_SET header_len=28 payload_len=12
REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli=930 ai_score_milli=1000 sample_id=1
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0
REDCOLA_STARRY_AI_DONE
```

## How This Helps The Bonus Score

| Contest bonus angle | Current proof | Conservative boundary |
| --- | --- | --- |
| StarryOS instead of standard Linux | The non-RT AI-control workload runs inside the StarryOS QEMU guest. | This is bonus evidence; the complete AxVisor Linux/RTOS mixed deployment remains in PR `#1`. |
| AI model inside non-RT guest | The guest executes a deterministic fixed-point MLP policy. | The model is small so reviewers can inspect and reproduce it. |
| Control comparison | AI output improves the fixed manual baseline from total error `1013` to `0`. | This proves StarryOS-side AI-control behavior, not a separate RTOS network run. |
| Link to main protocol | The guest builds and validates a QCZ1 `CONTROL_SET` frame with the same protocol shape as PR `#1`. | This is protocol parity evidence, not a separate StarryOS-to-RTOS channel claim. |

## Bonus Review Decision

Use this branch as StarryOS bonus evidence when evaluating the redcola
submission:

| Decision point | Evidence in this branch | Review note |
| --- | --- | --- |
| Can StarryOS run the non-RT AI workload? | Yes: the QEMU guest prints `REDCOLA_STARRY_AI_CONTROL_PASS` and `REDCOLA_STARRY_AI_DONE`. | This supports the StarryOS-preferred non-RT guest direction. |
| Does the AI workload have a measurable control effect? | Yes: fixed manual error is `1013`, AI error is `0` over the deterministic sample set. | This is the same control-policy family used to explain the main AI loop. |
| Is it tied to the main protocol design? | Yes: QCZ1 `CONTROL_SET` frame parity is self-checked in the guest. | This shows a migration path toward StarryOS as the non-RT controller. |
| Is it the full replacement for PR `#1`? | No. | PR `#1` remains the full AxVisor Linux/RTOS network and RTOS-control proof. |

## Representative Evidence

```text
runtime_source_head=4cbd22ccb837
evidence_dir=/home/kali/qc-evidence/starry-qemu-redcola-qcz1-parity-head-4cbd22ccb837-20260814_103336
qemu_log_sha256=9e73e441e1028fdffdd4a4bdcb8fc64497e9cf505755c94ddf1a1e1956f54ddf
summary_sha256=c81fd027897e0fdef72e36864791d1e99391c2d2681824820ff95fcf67befa33
```

## What This PR Does Not Claim

- It does not replace the main PR `#1` Linux/RTOS TAP packet-capture evidence.
- It does not claim a separate StarryOS-to-RTOS network run.
- It does not claim StarryOS syscall/Linux ABI expansion.
- It does not commit generated rootfs images, QEMU logs, toolchain wrappers or
  build caches.
