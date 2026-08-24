# StarryOS Bonus Evidence

This note explains the redcola StarryOS bonus submission for the Quancheng Lab
2026 AxVisor contest. It is intentionally separate from the main AxVisor
artifact PR so that the main Linux/RTOS mixed-system evidence remains easy to
review.

## Branch And Scope

| Item | Value |
| --- | --- |
| Private repository | `https://github.com/qcl-kernel/tgoskits-redcola` |
| Private PR | `qcl-kernel/tgoskits-redcola#2` |
| Branch | `contest/starry-redcola-ai-bonus-clean-20260731` |
| Submitted branch head | `2ac656341a63facdc3030fa3fd99bd20de156bef`; latest-`dev` compatibility is recorded separately in the final package |
| Changed path | `apps/starry/qemu/redcola-ai-control/` |
| Runtime evidence commit | `4cbd22ccb837` |
| QEMU machine | `virt,gic-version=3` |

The StarryOS branch adds a small deterministic AI-control workload that runs as
a Linux-user-mode program inside the StarryOS QEMU guest. It does not change
AxVisor core code and does not change the main contest artifact directory.

## What This Proves

The StarryOS bonus branch proves that the same redcola AI-control policy can be
packaged as a StarryOS guest workload rather than only as a standard Linux-side
demo. It is useful for the contest bonus item that prefers StarryOS over a
standard Linux non-realtime guest.

Runtime markers:

```text
REDCOLA_STARRY_QCZ1_FRAME magic=QCZ1 version=1 type=CONTROL_SET header_len=28 payload_len=12 seq=9001 sample_id=1 checksum=0x1ac5c2ff frame_len=40
REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli=930 ai_score_milli=1000 sample_id=1
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0 mean_infer_us=82
REDCOLA_STARRY_AI_DONE
RESULT=PASS
```

Evidence path from the validated Kali run:

```text
/home/kali/qc-evidence/starry-qemu-redcola-qcz1-parity-head-4cbd22ccb837-20260814_103336
```

Log hash:

```text
9e73e441e1028fdffdd4a4bdcb8fc64497e9cf505755c94ddf1a1e1956f54ddf
```

The current branch head includes reviewer-path and validation-note refreshes
after the validated runtime commit, and was rebuilt on the latest private
`dev` base during the 2026-08-18 final-preparation sync. The runtime PASS
markers and QCZ1 parity markers above correspond to the runtime evidence
commit listed in the scope table.

## Boundary

This branch should be counted as StarryOS bonus evidence, not as a replacement
for the main AxVisor Linux/RTOS dual-guest artifact.

Current boundary:

- StarryOS QEMU guest runs the deterministic fixed-point AI-control workload.
- The workload demonstrates the same policy behavior used by the main AI
  control story: the AI policy removes the manual-control absolute error in
  the included sample set.
- The workload builds and self-checks a deterministic QCZ1 `CONTROL_SET` frame
  with the same application-frame shape as the main Linux/RTOS delivery.
- The branch is cleanly scoped to `apps/starry/qemu/redcola-ai-control/`.

Not claimed yet:

- It is not a full StarryOS replacement for every main-task Linux guest step.
- It does not yet run the complete AxVisor Linux/RTOS QCZ1 TAP/tcpdump matrix
  with StarryOS as the non-realtime guest.
- It does not add new StarryOS syscalls, so it is not evidence for the separate
  syscall-completion bonus item.

## How To Review

Review the StarryOS bonus after the main AxVisor artifact:

1. Confirm private PR `#2` changes only `apps/starry/qemu/redcola-ai-control/`.
2. Start with `apps/starry/qemu/redcola-ai-control/REVIEWER-QUICKSTART.md`
   for the shortest scoring path.
3. Read the branch README for the StarryOS QEMU run command and expected
   markers.
4. Read `apps/starry/qemu/redcola-ai-control/VALIDATION.md` in PR `#2` for the
   marker checklist and representative evidence path.
5. Check the runtime PASS markers above.
6. Treat it as an additive StarryOS bonus item while the main score remains
   anchored in private PR `#1`.

## Final Submission Note

For the final 2026-08-24 package, include both:

- main PR `#1`, branch `contest/axvisor-2026`;
- StarryOS bonus PR `#2`, branch
  `contest/starry-redcola-ai-bonus-clean-20260731`.

This keeps the main AxVisor evidence reproducible while still making the
StarryOS bonus path visible to reviewers.
