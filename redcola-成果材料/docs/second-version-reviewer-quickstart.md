# Second-Version Reviewer Quickstart

This page is the compact review entry point for the redcola 2026-08-21
second-version checkpoint. It points reviewers to the exact submitted branches,
the strongest current evidence and the completed privileged TAP runtime gate.

## Submitted Branch References

| Item | Branch or PR | Verified reference |
| --- | --- | --- |
| Main AxVisor contest artifact | `qcl-kernel/tgoskits-redcola#1`, `contest/axvisor-2026` | use the PR page for the moving branch head, the package `README.txt` for the archived source head, and the runtime source heads below for measured QEMU evidence |
| StarryOS bonus artifact | `qcl-kernel/tgoskits-redcola#2`, `contest/starry-redcola-ai-bonus-clean-20260731` | submitted head `2ac656341a63facdc3030fa3fd99bd20de156bef`; latest-`dev` runtime compatibility is supplied as supplemental package evidence |
| Landed AxVisor support anchor | `rcore-os/tgoskits#1770` | `024ecca10a4240a84b2c24bed2dc2361a6043d3e` |

Latest final dev sync gate on 2026-08-21:

```text
official upstream/dev: 8e39cbd586a4a34ab9f522931ca4b1e7523709c7
final-sync base: 8e39cbd586a4a34ab9f522931ca4b1e7523709c7
main PR #1 scope after sync: 2 AxVM PCI interrupt-map parser files + os/axvisor/contest/quancheng2026/
StarryOS PR #2 scope after sync: apps/starry/qemu/redcola-ai-control/
```

Main PR `#1` was rebuilt on this latest `dev` base and remains exactly two
commits above it. StarryOS PR `#2` remains independently scoped and was not
changed by this final main-branch sync.

The latest main source passed the PCI `interrupt-map` targeted test `1/1`, the
complete AxVM host-test suite `296/296`, static script/protocol gates, and a
full dual-guest compatibility run. The runtime source head
`17ee96b89fd2e4c441a44dd5c1893f63ee5e77db` reports Linux `2` vCPUs, pinned
CPU0 periodic work and CPU1 stress, UDP `20/20`, QCZ1 `10/10`, AI `10/10` and
final `result=PASS`. See
`results/final-demo-latestdev8e39-head17ee-summary.md`.

A clean latest-base dual-guest run was completed on 2026-08-21 with the local
PCI `interrupt-map` passthrough-IRQ candidate applied. It reports final
`result=PASS`, Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, and two
QEMU filter-dump PCAPs with `93` packets each. The exact source patch, patch
SHA256 and runtime logs are stored at
`/home/kali/qc-evidence/redcola-latest-dev-clean-pass-20260821`. Use this as
latest-`dev` compatibility evidence; use the long TAP rows for realtime scoring.

An additional same-head affinity matrix pins the Linux periodic probe to guest
CPU 0 and two stress workers to guest CPU 1. Both 3000-sample rows at a 10 ms
period pass UDP `20/20`, QCZ1 `10/10` and AI `10/10`; Linux mean/p99/max is
`2.808/9.620/118.127 ms` without stress and `2.166/4.615/73.587 ms` with two
isolated workers. Evidence and the interpretation boundary are recorded in
`results/task-one-latestdev-isolated-p10ms-summary.md` and
`/home/kali/qc-evidence/t1-latestdev220-isolated-p10ms-20260821`.

The final main PR is intentionally limited to two cohesive commits and these
paths:

```text
virtualization/axvm/src/boot/fdt/core/mod.rs
virtualization/axvm/src/boot/fdt/core/parser.rs
os/axvisor/contest/quancheng2026/
```

The AxVM commit parses passthrough IRQs from PCI `interrupt-map` entries and is
covered by the targeted `1/1` test plus the complete `296/296` AxVM host-test
suite. The contest commit contains the runnable demos, tests, evidence and
review documents. No other core paths are included.

Runtime evidence source heads for the main artifact are listed in
`docs/evidence-index.md`. The PR branch head itself may be newer when only
documentation, packaging notes or reviewer-facing summaries are refreshed, so
the runtime source heads below are the authoritative proof points for measured
QEMU data.

The StarryOS bonus PR is intentionally limited to:

```text
apps/starry/qemu/redcola-ai-control/
```

## Recommended Review Order

1. `docs/reviewer-defense-qna.md` for short answers to likely review and
   defense questions.
2. `docs/task-one-reviewer-defense-qna.md` for the short task-one realtime
   defense path.
3. `docs/scorecard-traceability.md` for requirement-to-evidence mapping.
4. `docs/task-one-realtime-core-claim.md` for the exact task-one core claim.
5. `docs/task-one-30-point-checklist.md` for the task-one 30-point scoring
   coverage table.
6. `docs/task-one-score-summary.md` for realtime before/after deltas.
7. `docs/task-two-three-50-point-checklist.md` for the task-two/task-three
   50-point scoring coverage table.
8. `docs/task-two-three-score-summary.md` for IP communication and AI-control
   evidence.
9. `docs/second-version-submission-status.md` for the completed TAP/tcpdump
   before/after matrix gate.
10. `docs/reproduce.md` for clean-environment rerun instructions.
11. `docs/engineering-innovation-20-point-checklist.md` for engineering
   completeness and system innovation scoring.
12. `docs/final-submission-checklist.md` for milestone and packaging status.
13. `docs/starryos-bonus.md`, `docs/starryos-bonus-scorecard.md` and PR `#2`
    for the separate StarryOS evidence.

## Current Score-Oriented Evidence

| Contest area | Current second-version evidence |
| --- | --- |
| Task one realtime | 0/1/2/4-worker before/after hub matrix, completed 0/2-worker TAP before/after matrix, current-head `30000`-sample hub/TAP long-pressure rows, current-head `30000`-sample 4-worker hub and TAP/tcpdump overcommit proofs, latest-`dev` CPU0-probe/CPU1-stress affinity matrix, recorded `a9ceb7dc` 2-worker long hub proof, `TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS`, `TASK_ONE_CURRENT_HEAD_LONG_HUB4_PROOF=PASS`, Linux `2` vCPU marker, RTOS and Linux periodic latency stats, native Zephyr baseline and stress/stability rows. |
| Task two IP communication | Linux/RTOS IPv4 UDP link, QCZ1 frame format, ACK/timeout/retry/duplicate handling, status and error path validation, plain UDP `20/20`, QCZ1 `10/10`, recorded TAP tcpdump `88` packets with kernel drops `0`. |
| Task three AI closed loop | Deterministic neural-network inference, QCZ1 `CONTROL_SET`, RTOS applied control output, ACK/STATUS return path, AI `10/10`, AI-vs-manual error comparison and end-to-end latency data. |
| Latest `dev` compatibility | Clean Linux/Zephyr dual-guest runtime on official base `8e39cbd58`, final `result=PASS`, Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, AI `10/10`; the earlier 30,000-sample 1 ms and TAP rows remain the long-pressure evidence. |
| AxVM core validation | PCI `interrupt-map` targeted unit test `1/1 PASS`; full `cargo test -p axvm --features host-test --lib` suite `296/296 PASS`. |
| StarryOS bonus | StarryOS QEMU AI-control demo with `REDCOLA_STARRY_QCZ1_PARITY_PASS`, `REDCOLA_STARRY_AI_CONTROL_PASS` and `REDCOLA_STARRY_AI_DONE` markers in PR `#2`. |
| Engineering | Static preflight PASS, scope-limited PRs, no tracked raw images/logs/pcaps/caches, reproducibility docs, exact-head package verify PASS, final demo script and hub-mode final-video rehearsal PASS. |

## Task-One Before/After Snapshot

| Workers | Main result |
| ---:| --- |
| `0` | RTOS p99 improves `1.323 ms -> 0.761 ms`; RTOS max improves `8.055 ms -> 1.773 ms`; UDP/QCZ1/AI stay `100%`. |
| `1` | RTOS p99 improves `1.124 ms -> 0.782 ms`; Linux p99/max also improve; UDP/QCZ1/AI stay `100%`. |
| `2` | RTOS p99 improves `1.454 ms -> 0.993 ms`; a larger RTOS max outlier is kept visible and not hidden. |
| `4` | Treated as a 2-vCPU Linux overcommit boundary and stability row, not as the primary latency-improvement claim. |

Latest current-head 4-worker hub overcommit row:

```text
/home/kali/qc-evidence/t1-current-head-hub4-r30000-20260814_204459
TASK_ONE_CURRENT_HEAD_LONG_HUB4_PROOF=PASS
UDP 20/20, QCZ1 10/10, AI 10/10
RTOS p99/max: 1143440 / 5372880 ns
AI e2e mean/max: 3428 / 7887 us
```

Latest current-head 4-worker TAP/tcpdump overcommit row:

```text
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018
TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS
UDP 20/20, QCZ1 10/10, AI 10/10, tcpdump 88/0
RTOS p99/max: 1821568 / 31444800 ns
AI e2e mean/max: 5277 / 15431 us
```

Recorded a9ceb7dc 2-worker long hub row:

```text
/home/kali/qc-evidence/t1-a9ce-long-hub-20260815_064606
TASK_ONE_A9CE_LONG_HUB_PROOF=PASS
UDP 20/20, QCZ1 10/10, AI 10/10
RTOS p99/max: 1115280 / 5921456 ns
Linux p99/max: 4862240 / 31883280 ns
```

## Validation Already Performed

```text
git diff --check origin/dev...HEAD: PASS
scope check for main artifact PR: PASS
forbidden tracked artifact check: PASS
Windows Python syntax check: QC_LOCAL_PY_SYNTAX=PASS
Kali 64-bit static preflight: QC_STATIC_PREFLIGHT=PASS
AxVM PCI interrupt-map targeted host test: 1/1 PASS
AxVM full host-test library suite: 296/296 PASS
Recent verified package proof: package build PASS, strict package verify PASS and fresh-unzip verify PASS. The uploadable ZIP hash is kept outside the archive in the sibling `.zip.sha256` file to avoid self-referential archive hashes. Regenerate once from the selected 2026-08-24 final head and use that package's README.txt, SHA256SUMS.txt and external .zip.sha256 as the authoritative final proof.
Recorded runtime-source long hub matrix: TASK_ONE_SECOND_VERSION_MATRIX=PASS at 8984bd23
Latest TAP before/after matrix: TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS from runtime source 2737d1e60, tcpdump 88/0 in all rows
Recorded a9ceb7dc long hub proof: TASK_ONE_A9CE_LONG_HUB_PROOF=PASS
StarryOS bonus markers: REDCOLA_STARRY_QCZ1_PARITY_PASS, REDCOLA_STARRY_AI_CONTROL_PASS, REDCOLA_STARRY_AI_DONE
```

The private mirror repository may show GitHub Actions failures if
organization-level runner/container access or billing limits prevent jobs from
starting. Those mirror CI failures are not used as the runtime proof for this
contest artifact. The submitted evidence is the PR content, local/static
preflight, QEMU runtime markers and referenced evidence directories.

The package dry-run hash is a recorded proof point for its listed source head.
The PR branch may advance afterward when documentation records that proof. The
final upload should regenerate `SHA256SUMS.txt` once from the selected final
branch head.

## Completed High-Value TAP Gate

The main second-version scoring gate was the TAP/tcpdump before/after matrix:

```text
current branch, TAP, 0 workers
current branch, TAP, 2 workers
pre-#1770 baseline, TAP, 0 workers
pre-#1770 baseline, TAP, 2 workers
```

It was completed on 2026-08-14 from private PR runtime source head
`2737d1e603b5b0d62cc4d6faf71dbdee33bd75c5` and the pre-`#1770` baseline
worktree. Evidence root:

```text
/home/kali/qc-evidence/t1-before-after-tap-fixed-114047
```

All four rows report `PASS`, Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, AI
`10/10`, QCZ1 retransmits `0`, no missing markers, and tcpdump
captured/dropped `88/0`. The repository intentionally does not store or pass a
sudo password; the run used caller-authenticated `sudo -v` on the Kali host.

The latest private PR-head long hub rerun is
`/home/kali/qc-evidence/t1-head8984-long-hub-2w-r30000-20260814_173833`,
collected from `8984bd23dbb27b091aaa120020f0ac9eff59226d`. It covers the
2-worker pressure case with `30000` Linux periodic samples and reports
`TASK_ONE_SECOND_VERSION_MATRIX=PASS`, UDP `20/20`, QCZ1 `10/10`, AI `10/10`,
Linux `2` vCPUs, QCZ1 retransmits `0` and no missing markers. The PR branch
itself may be newer when only documentation and package notes have been
refreshed.

The current-head 4-worker TAP/tcpdump overcommit proof is
`/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018`, collected
from `91cb7c0fc00d579d62528a3c967e5efd3cc57836`. It covers `4` Linux stress
workers on the `2`-vCPU Linux guest with `30000` Linux periodic samples and
reports `TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS`, UDP `20/20`, QCZ1
`10/10`, AI `10/10`, tcpdump captured/dropped `88/0`, RTOS p99/max
`1821568 / 31444800 ns`, and AI end-to-end mean/max `5277 / 15431 us`.

The exact submitted-head 2-worker stability repeat is
`/home/kali/qc-evidence/t1-head746-2w-hub-stability-r30000-20260815_031511`,
collected from `746042293ac61bc5cb894c6c470ae76fdc02674a` after the analyzer
was hardened against serial-log interleaving of the RTOS PASS marker. It runs
the `30000`-sample, 2-worker hub pressure row three times. All three runs
report `TASK_ONE_SECOND_VERSION_MATRIX=PASS`, Linux `2` vCPUs, UDP `20/20`,
QCZ1 `10/10`, AI `10/10`, no missing markers, and RTOS p99/max ranges of
`882896-1040304 / 2043904-3080560 ns`.

A final-video hub rehearsal has also passed at:

```text
/home/kali/qc-evidence/demo-hub-rehearsal-20260814_040528
/home/kali/qc-evidence/demo-hub-rehearsal-w1-20260814_042902
/home/kali/qc-evidence/qc-demo-hub-head-e1a01b82-20260814_094911
```

The latest recorded private PR-head rehearsal uses head
`e1a01b8263eba471625f26ef5e383db20744a40b`, includes one Linux stress worker
and `3000` Linux periodic samples, and reports final `result=PASS`, Linux `2`
vCPUs, UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI `10/10` and RTOS
periodic `PASS`. These runs are useful for recording readiness and
task-two/task-three marker capture; the packet-captured task-one proof is the
completed TAP before/after matrix above.
