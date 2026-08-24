# Engineering And Innovation 20-Point Reviewer Checklist

This page maps the remaining non-task scoring items to the redcola evidence
set. It complements the task-one 30-point checklist, the task-two/task-three
50-point checklist and the StarryOS bonus scorecard.

## Engineering Completeness, 15 Points

| Official scoring detail | Points | Current coverage | Evidence to inspect | Conservative boundary |
| --- | ---:| --- | --- | --- |
| Complete design plan | `4` | The design describes the AxVisor mixed-system architecture, Linux/RTOS guest roles, network topology, QCZ1 protocol, isolation boundary, AI-control placement and realtime validation plan. | `docs/design.md`, `docs/network-topology.md`, `docs/protocol.md`, `docs/realtime-evaluation.md`, `docs/ai-control-evaluation.md` | The design is QEMU-first and records hardware-board work as a future extension unless later board evidence is added. |
| Complete test document | `4` | The test report and score summaries cover startup, IP communication, QCZ1 reliability, AI closed loop, realtime before/after, TAP/tcpdump, stability and StarryOS bonus markers. | `docs/test-report.md`, `docs/task-one-score-summary.md`, `docs/task-two-three-score-summary.md`, `docs/evidence-index.md` | Raw logs and pcaps stay outside git; committed files carry small summaries, paths and hashes. |
| Complete source and configuration | `4` | The main PR keeps Linux clients, Zephyr protocol code, scripts, configs, docs and summaries under `os/axvisor/contest/quancheng2026/`; StarryOS bonus code is separate in PR `#2`. | `docs/final-submission-checklist.md`, `docs/pr-boundary.md`, `docs/commit-plan.md`, PR `#1`, PR `#2` | Runtime images, kernels, rootfs files, caches and generated logs are intentionally excluded. |
| Operable reproduction instructions | `3` | Reproduction docs and scripts cover artifact preflight, QEMU run commands, evidence directories, package building and package verification. | `docs/reproduce.md`, `docs/final-package.md`, `docs/final-demo-recording-runbook.md`, `scripts/build_final_submission_package.sh`, `scripts/verify_final_submission_package.py` | Final `--require-video` package verification must be rerun after the real final video is recorded. |

## System Innovation And Extensibility, 5 Points

| Official scoring detail | Points | Current coverage | Evidence to inspect | Conservative boundary |
| --- | ---:| --- | --- | --- |
| Realtime, communication or control innovation | `2` | The prototype combines AxVisor timer/interrupt support, Zephyr e1000 guest networking, QCZ1 reliable UDP and a deterministic AI-to-RTOS control loop in one mixed-system validation path. | `docs/task-one-realtime-core-claim.md`, `docs/protocol.md`, `docs/ai-control-evaluation.md`, `docs/task-two-three-50-point-checklist.md` | The innovation is an integrated contest prototype, not a certified industrial safety product. |
| Extension to more guests, RTOSes or control scenarios | `2` | The design separates protocol, topology, AI policy and RTOS control output so the path can extend to StarryOS, other RTOS guests, hardware TAP/network paths and observable devices such as LED/PWM/motor control. | `docs/design.md`, `docs/starryos-bonus-scorecard.md`, `docs/final-demo-recording-runbook.md`, `docs/reproduce.md` | StarryOS is currently a bonus/parity path; hardware actuator validation is not claimed unless later evidence is added. |
| Code quality and engineering discipline | `1` | The submission keeps scope-limited PRs, no stored sudo password, no generated images/logs/pcaps in git, static preflight checks and a conservative final-package verifier. | `docs/final-submission-checklist.md`, `docs/final-package.md`, `scripts/verify_final_submission_package.py`, `docs/starryos-bonus-scorecard.md` | Private mirror GitHub Actions may fail for runner/container availability; local/static/QEMU evidence is the authoritative contest proof. |

## Review Path

For the engineering and innovation section, review in this order:

1. `docs/scorecard-traceability.md` for the whole evidence map.
2. `docs/design.md` for architecture and isolation.
3. `docs/test-report.md` for test coverage.
4. `docs/reproduce.md` for rerun steps.
5. `docs/final-package.md` for the final upload shape.
6. `docs/final-submission-checklist.md` for milestone status.
7. `scripts/verify_final_submission_package.py` for package guardrails.

## Final Package Gate

Before the final 2026-08-24 upload, the package verifier should pass twice:

```text
dry run before video: FINAL_PACKAGE_VERIFY=PASS
required final gate after recording the selected user-narrated video: FINAL_PACKAGE_VERIFY=PASS --require-video --require-presentation --require-starry
```

The final run should include:

```text
docs/design.md
docs/test-report.md
docs/reproduce.md
docs/scorecard-traceability.md
docs/task-one-30-point-checklist.md
docs/task-two-three-50-point-checklist.md
docs/engineering-innovation-20-point-checklist.md
docs/starryos-bonus-scorecard.md
video/redcola-axvisor-demo.mp4
SHA256SUMS.txt
```

## What Is Not Claimed

- The package does not include raw QEMU images, rootfs images, kernels, pcaps
  or build caches.
- The final video is not considered complete until an actual `.mp4` is
  included and verified with `--require-video`.
- Organization mirror CI failures caused by runner/container access are not
  treated as source or runtime failures.
- Hardware-board deployment is not claimed unless a later evidence set records
  it explicitly.
