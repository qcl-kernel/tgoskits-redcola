# Redcola StarryOS Bonus Validation

This file records the validation shape for the redcola StarryOS AI-control
bonus case. It is intentionally scoped to the StarryOS non-RT guest path and
does not replace the main AxVisor Linux/RTOS delivery in PR `#1`.
For a scoring-oriented summary, start with `REVIEWER-QUICKSTART.md` and then
see `SCORECARD.md`.

## Scope

| Item | Value |
| --- | --- |
| Private PR | `qcl-kernel/tgoskits-redcola#3` (final); `#2` is retained as historical evidence. |
| Branch | `contest/starry-redcola-ai-bonus-final-20260824` |
| Path | `apps/starry/qemu/redcola-ai-control/` |
| Guest role | StarryOS non-RT guest |
| Program role | Linux-user-mode AI-control workload inside StarryOS |
| QEMU architecture | AArch64 |
| QEMU machine | `virt,gic-version=3` |
| Rootfs device | NVMe, matching the current StarryOS QEMU rootfs path |

## Build And Runtime Command

Run from the repository root:

```sh
cargo xtask starry app qemu -t qemu/redcola-ai-control --arch aarch64
```

The QEMU config runs:

```text
/usr/bin/redcola-ai-control
```

and treats this marker as the final success condition:

```text
REDCOLA_STARRY_AI_DONE
```

## Required Markers

A valid run must show all of the following lines:

```text
REDCOLA_STARRY_AI_BEGIN guest=StarryOS role=non_rt_guest model=fixed_point_mlp_policy hidden=4
prebuild_marker=prebuild-ok
REDCOLA_STARRY_CONTROL_SUMMARY manual_abs_error=1013 ai_abs_error=0 max_ai_error=0
REDCOLA_STARRY_QCZ1_FRAME magic=QCZ1 version=1 type=CONTROL_SET header_len=28 payload_len=12
REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli=930 ai_score_milli=1000 sample_id=1
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0
REDCOLA_STARRY_AI_DONE
```

`mean_infer_us` is runtime-dependent and may vary by host load, but the pass
condition requires AI total error to stay below the fixed manual baseline and
the final DONE marker to be printed.

## Representative Evidence

Representative Kali evidence directory:

Runtime source head: `4cbd22ccb837` (the following docs-only commit records this evidence).


```text
/home/kali/qc-evidence/starry-qemu-redcola-qcz1-parity-head-4cbd22ccb837-20260814_103336
```

Representative pass lines:

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

Some reruns report a different `mean_infer_us` because it is measured inside
the guest at runtime. The control-quality values are deterministic for the
fixed sample table and fixed MLP weights.

Newer runs also print QCZ1 protocol-parity markers. These markers are
deterministic except for formatting position in the QEMU log:

```text
REDCOLA_STARRY_QCZ1_FRAME magic=QCZ1 version=1 type=CONTROL_SET header_len=28 payload_len=12 seq=9001 sample_id=1 checksum=0x...
REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli=930 ai_score_milli=1000 sample_id=1
```

They prove that the StarryOS guest can construct the same QCZ1 `CONTROL_SET`
application-frame shape used by the main AxVisor Linux/RTOS delivery. They do
not claim a separate StarryOS-to-RTOS network path.

## Scorecard Boundary

This branch supports the StarryOS bonus item by proving that a StarryOS guest
can run the non-RT AI-control workload and produce deterministic PASS/DONE
markers. The QCZ1 parity marker adds protocol-shape evidence that matches the
main delivery without expanding this PR beyond the StarryOS app path. It should
be cited together with the main AxVisor artifact PR:

```text
Main AxVisor artifact: qcl-kernel/tgoskits-redcola#1
StarryOS bonus artifact: qcl-kernel/tgoskits-redcola#3
```

## Validation Gate Summary

Treat the validation as passing only when all required markers are present in a
single QEMU run:

| Gate | Required proof |
| --- | --- |
| StarryOS app execution | `prebuild_marker=prebuild-ok` and `REDCOLA_STARRY_AI_DONE`. |
| AI inference | `REDCOLA_STARRY_AI_CONTROL_PASS` with `ai_abs_error < manual_abs_error`. |
| Control comparison | `REDCOLA_STARRY_CONTROL_SUMMARY manual_abs_error=1013 ai_abs_error=0`. |
| Protocol parity | `REDCOLA_STARRY_QCZ1_FRAME` and `REDCOLA_STARRY_QCZ1_PARITY_PASS`. |
| Reproducibility metadata | QEMU command, AArch64 `virt,gic-version=3`, evidence directory and log hashes. |

If one of these markers is missing, the run should be treated as incomplete
for bonus scoring even if the StarryOS guest itself boots.

## Reviewer Defense Notes

This bonus case is meant to answer three review questions directly:

| Review question | Answer |
| --- | --- |
| Does the code actually run inside StarryOS? | Yes. The runner boots the StarryOS QEMU guest and executes `/usr/bin/redcola-ai-control`, then waits for `REDCOLA_STARRY_AI_DONE`. |
| Is there a neural-network inference step? | Yes. The guest program runs a deterministic fixed-point 4-input, 4-hidden-unit MLP and compares it with a fixed manual-control baseline. |
| Is it connected to the main Linux/RTOS protocol design? | Yes, at protocol-shape level. The StarryOS guest builds and self-checks a QCZ1 `CONTROL_SET` frame with the same magic, version, type, header length, payload length, sequence and checksum layout used by PR `#1`. |

The strongest way to evaluate this branch is to inspect the required markers
above, then cross-reference PR `#1` for the complete AxVisor Linux/RTOS network
and RTOS control loop. This keeps the bonus evidence reviewable while still
showing a practical migration path from the Linux non-RT guest demo toward a
StarryOS non-RT guest.

This branch does not claim:

- RTOS-side network control by itself;
- StarryOS syscall or Linux ABI expansion;
- generated rootfs images, QEMU logs or temporary toolchain wrappers as source
  files.

Those boundaries keep the bonus PR easy to review and avoid mixing unrelated
contest artifacts into the StarryOS app path.
