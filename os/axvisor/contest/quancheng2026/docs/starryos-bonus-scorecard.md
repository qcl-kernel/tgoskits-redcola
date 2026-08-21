# StarryOS Bonus Scorecard

This page maps the optional StarryOS bonus items to the current redcola
evidence. It keeps the bonus claim useful but conservative: PR `#2` is a real
StarryOS guest workload proof, but it is not presented as a full replacement
for the main Linux/RTOS AxVisor delivery.

## Bonus Mapping

| Bonus item | Max points | Current redcola evidence | Suggested interpretation |
| --- | ---:| --- | --- |
| Use StarryOS instead of standard Linux | `4` | Private PR `qcl-kernel/tgoskits-redcola#2` runs the deterministic AI-control workload inside a StarryOS AArch64 QEMU guest and prints `REDCOLA_STARRY_AI_CONTROL_PASS`, `REDCOLA_STARRY_QCZ1_PARITY_PASS` and `REDCOLA_STARRY_AI_DONE`. | Strong bonus evidence for the StarryOS non-RT guest direction. It complements the main Linux/RTOS path rather than replacing every main-task runtime step. |
| Improve StarryOS syscall/Linux ABI support | `4` | No syscall or Linux ABI patch is claimed in the current redcola StarryOS branch. | Do not claim these points unless a later PR adds actual StarryOS syscall/ABI work and it is accepted by reviewers. |
| More complete baseline | `2` | The main submission includes native Zephyr RTOS latency baseline evidence and AxVisor-hosted Linux/Zephyr runs. The StarryOS PR adds a second non-RT guest direction, not a second RTOS or board baseline. | Count only if reviewers accept the combined baseline story. Do not overstate it as multiple RTOS or multi-board validation. |

## Evidence To Show

The StarryOS bonus PR is:

```text
https://github.com/qcl-kernel/tgoskits-redcola/pull/2
branch: contest/starry-redcola-ai-bonus-clean-20260731
path: apps/starry/qemu/redcola-ai-control/
submitted branch head: 2ac656341a63facdc3030fa3fd99bd20de156bef
latest-dev compatibility: supplemental final-package evidence
runtime evidence source head: 4cbd22ccb837
```

Reviewer fast path in PR `#2`:

```text
apps/starry/qemu/redcola-ai-control/REVIEWER-QUICKSTART.md
```

Required markers:

```text
REDCOLA_STARRY_AI_BEGIN guest=StarryOS role=non_rt_guest model=fixed_point_mlp_policy hidden=4
prebuild_marker=prebuild-ok
REDCOLA_STARRY_QCZ1_FRAME magic=QCZ1 version=1 type=CONTROL_SET header_len=28 payload_len=12
REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli=930 ai_score_milli=1000 sample_id=1
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0
REDCOLA_STARRY_AI_DONE
```

Representative evidence directory:

```text
/home/kali/qc-evidence/starry-qemu-redcola-qcz1-parity-head-4cbd22ccb837-20260814_103336
```

Evidence hashes:

```text
9e73e441e1028fdffdd4a4bdcb8fc64497e9cf505755c94ddf1a1e1956f54ddf  qemu.log
c81fd027897e0fdef72e36864791d1e99391c2d2681824820ff95fcf67befa33  summary.txt
```

## How It Connects To The Main Score

The main AxVisor score remains anchored in private PR `#1`:

```text
AxVisor starts Linux and Zephyr RTOS guests
Linux/RTOS communicate over IPv4/UDP
QCZ1 reliable UDP carries CONTROL_SET and STATUS
Linux-side AI output drives RTOS-side control state
TAP/tcpdump and realtime summaries prove the mixed-system run
```

The StarryOS bonus PR shows that the non-RT AI-control side can also be
packaged for StarryOS:

```text
StarryOS guest
  -> fixed-point MLP inference
  -> deterministic QCZ1 CONTROL_SET frame construction
  -> manual-vs-AI control quality comparison
  -> PASS/DONE markers inside the StarryOS QEMU guest
```

This is the correct relationship to describe in the final video: StarryOS is a
bonus extension of the non-RT guest direction, while the complete cross-guest
network/RTOS closed loop remains in the main AxVisor evidence.

## Final Video Wording

Use wording like this:

```text
In addition to the main Linux/RTOS AxVisor path, we submitted a separate
StarryOS bonus PR. It runs the same deterministic AI-control policy inside the
StarryOS QEMU guest and emits QCZ1 frame-parity and AI-control PASS markers.
This demonstrates the StarryOS non-realtime guest direction without mixing it
into the main AxVisor artifact PR.
```

Avoid wording like this:

```text
StarryOS fully replaces Linux for all three main tasks.
We implemented StarryOS syscall completion.
The StarryOS demo independently performs the RTOS-side network control loop.
```

Those statements are intentionally not claimed by the current redcola
submission.
