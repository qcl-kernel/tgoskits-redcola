# Evidence Index

This file is the compact reviewer entry point for the redcola first-version
submission and second-version follow-up work. It points to the source, test,
runtime and bonus evidence without requiring raw QEMU logs or large runtime
images to be committed into git.

## Submitted Branches

| Item | Location | Current role |
| --- | --- | --- |
| Private repository | `https://github.com/qcl-kernel/tgoskits-redcola` | Contest-review source of truth |
| Main PR | `qcl-kernel/tgoskits-redcola#1` | Main AxVisor Linux/RTOS contest artifacts |
| Main branch | `contest/axvisor-2026` | Two AxVM PCI parser files plus `os/axvisor/contest/quancheng2026/` |
| Main branch reference | `contest/axvisor-2026` in `qcl-kernel/tgoskits-redcola#1` | Moving PR branch; use the PR page for the latest head. Runtime evidence source heads are listed below. |
| StarryOS bonus PR | `qcl-kernel/tgoskits-redcola#2` | Separate StarryOS AI-control bonus path |
| StarryOS bonus branch | `contest/starry-redcola-ai-bonus-clean-20260731` | `apps/starry/qemu/redcola-ai-control/` |
| StarryOS bonus head | `2ac656341a63facdc3030fa3fd99bd20de156bef`; PR `#2` is preserved as a separate review scope | Bonus PR branch head; latest-`dev` runtime compatibility is supplemental package evidence |
| Core support | `rcore-os/tgoskits#1770` | Merged AxVisor vTimer/interrupt support anchor |

## Latest Dev Sync

On 2026-08-21 the main final review branch was rebuilt against official
`rcore-os/tgoskits` `dev`:

```text
official upstream/dev: 8e39cbd586a4a34ab9f522931ca4b1e7523709c7
final-sync base: 8e39cbd586a4a34ab9f522931ca4b1e7523709c7
main PR #1 relative scope: 2 AxVM PCI interrupt-map parser files + os/axvisor/contest/quancheng2026/
StarryOS PR #2: preserved unchanged as a separate bonus scope
```

The new base passed the PCI `interrupt-map` targeted test `1/1` and complete
AxVM host-test suite `296/296`. A full same-source dual-guest run also passed:

```text
evidence: /home/kali/qc-evidence/final-demo-latestdev8e39-head17ee-20260821
runtime source head: 17ee96b89fd2e4c441a44dd5c1893f63ee5e77db
result: PASS
Linux guest: 2 vCPUs; periodic probe CPU 0; two stress workers CPU 1
plain UDP: 20/20 PASS
QCZ1 reliable UDP: 10/10 PASS, duplicate ACKs 2, retransmits 0
AI control: 10/10 PASS, AI/manual mean error 207/240
```

See `results/axvm-host-test-latestdev8e39-summary.txt` and
`results/final-demo-latestdev8e39-head17ee-summary.md`. The older `0340ed6b`
records below remain valid long-pressure and comparison evidence; they are not
presented as measurements from the newer base.

The final-sync source was subsequently exercised in a clean dual-guest run on
2026-08-21 with the local PCI `interrupt-map` passthrough-IRQ candidate applied:

```text
evidence: /home/kali/qc-evidence/redcola-latest-dev-clean-pass-20260821
base head: 26cb43d1b219f18fd197d0f608af0da51bd8e99d
source patch SHA256: 0cdb5925ed1684fcec5403c25209d5adb3ea96457b25af2674c3d36df80ac5e2
archive SHA256: 302bd734a86accaf7ff8c8d6dbee6316126dd4156e255eb71e94e42865436da1
result: PASS
Linux guest: 2 vCPUs
plain UDP: 20/20 PASS
QCZ1 reliable UDP: 10/10 PASS, duplicate ACKs 2, retransmits 0
AI control: 10/10 PASS, AI/manual mean error 207/240
QEMU filter-dump: 93 packets on each guest network endpoint
```

The evidence directory contains `source-working-tree.patch` and its SHA256, so
the locally applied core candidate is reviewable even before a separate core PR
is opened. This run is used for latest-`dev` compatibility and end-to-end
functional proof. Realtime score claims remain tied to the long TAP and
before/after source heads recorded below.

The same final-sync source also passed the latest 30,000-sample pressure gate:

```text
evidence: /home/kali/qc-evidence/t1-latestdev0340-long-hub-r30000-20260821
Linux periodic probe: 30000 samples, 1 ms period, guest vCPU 0
stress: 2 workers pinned to guest vCPU 1
plain UDP: 20/20 PASS
QCZ1: 10/10 PASS, duplicate ACKs 2, retransmits 0
AI: 10/10 PASS, e2e mean/max 7222/12528 us
result: PASS
```

The PCI `interrupt-map` candidate additionally passed its targeted host unit
test and the complete AxVM host-test library suite (`296/296 PASS`). See
`results/axvm-host-test-latestdev0340-summary.txt`.

The same latest-`dev` source was then exercised with explicit Linux guest CPU
affinity. The periodic probe ran on guest CPU 0 while two stress workers ran on
guest CPU 1. Both 3000-sample, 10 ms rows passed the complete dual-guest chain:

```text
evidence: /home/kali/qc-evidence/t1-latestdev220-isolated-p10ms-20260821
archive SHA256: 17f300e8d14a445fda0d1b727dd0c5a332716576683ac61006bde5274bad1163
matrix: TASK_ONE_SECOND_VERSION_MATRIX=PASS
0 workers Linux mean/p99/max: 2808020 / 9620384 / 118127472 ns
2 workers Linux mean/p99/max: 2166081 / 4614832 / 73586592 ns
each row: UDP 20/20, QCZ1 10/10, AI 10/10
```

`results/task-one-latestdev-isolated-p10ms-summary.md` records the interpretation
boundary: this is a same-head affinity/load comparison, while the existing TAP
rows remain the primary AxVisor before/after evidence.

The 2-worker isolated row was then repeated across three independent boots:

```text
evidence: /home/kali/qc-evidence/t1-latestdev220-isolated-p10ms-3x-hub-20260821
archive SHA256: e5dc492f90427a12f3e0d985e87136c13db89e316d77e1abdbaad03413ee63b8
stability: 3/3 PASS
Linux periodic samples: 9000/9000
plain UDP: 60/60 PASS
QCZ1 reliable UDP: 30/30 PASS, retransmits 0
AI control: 30/30 PASS
Linux mean lateness across runs: 2.150 ms
worst observed Linux P99/max: 8.753 / 127.734 ms
```

See `results/task-one-latestdev-isolated-p10ms-stability-3x-summary.md` for the
per-round table and the nested-QEMU interpretation boundary.

## Reviewer Reading Order

1. `docs/final-defense-brief-cn.md` for the one-page Chinese final defense
   path, score-oriented evidence map and safe wording.
2. `docs/first-version-submission-status.md` for the 2026-08-14 submitted
   state, representative PASS markers and known remaining work.
3. `docs/first-version-submission-message.md` for the 2026-08-14 organizer
   checkpoint message template.
4. `docs/scorecard-traceability.md` for requirement-by-requirement evidence.
5. `docs/engineering-innovation-20-point-checklist.md` for engineering
   completeness and system innovation scoring.
6. `docs/design.md` for architecture, guest roles, isolation and model
   placement.
7. `docs/test-report.md` for runtime validation, reliability and latency
   summaries.
8. `docs/reproduce.md` for rebuild and rerun commands.
9. `docs/second-version-reviewer-quickstart.md` for the compact second-version
   review path, exact branch heads and completed TAP/tcpdump gate.
10. `docs/second-version-submission-status.md` for the task-one realtime
   before/after matrix gate toward the 2026-08-21 checkpoint.
11. `docs/task-one-30-point-checklist.md` for the task-one 30-point scoring
   coverage table.
12. `docs/task-one-score-summary.md` for the score-oriented task-one delta
   table.
13. `docs/task-two-three-50-point-checklist.md` for the task-two/task-three
   50-point scoring coverage table.
14. `docs/task-two-three-score-summary.md` for the score-oriented communication
   and AI-control summary.
15. `docs/second-version-submission-message.md` for the 2026-08-21 organizer
   checkpoint message template.
16. `docs/starryos-bonus.md` for the separate StarryOS bonus boundary.
17. `docs/starryos-bonus-scorecard.md` for the optional bonus scoring map.
18. `docs/demo-video-script.md` for the final five-minute recording flow.
19. `docs/final-package.md` for the 2026-08-24 upload shape and exclusions.
20. `docs/final-submission-message.md` for the organizer/platform message.

## Task Evidence Map

| Contest area | Primary source paths | Primary evidence docs |
| --- | --- | --- |
| Task one realtime validation | `scripts/run_task_one_second_version_matrix.sh`, `scripts/run_task_one_before_after_tap_matrix.sh`, `scripts/run_task_one_current_head_long_tap_proof.sh`, `scripts/analyze_dual_guest_realtime.py`, `linux/qc_periodic_latency_probe.c`, `linux/qc_affinity_run.c` | `docs/task-one-realtime-core-claim.md`, `docs/task-one-30-point-checklist.md`, `docs/realtime-evaluation.md`, `docs/task-one-second-version-plan.md`, `docs/task-one-score-summary.md`, `results/realtime-comparison.csv`, `results/task-one-before-after-hub-summary.csv`, `results/task-one-before-after-tap-summary.csv`, `results/task-one-current-head-long-hub-r30000-summary.csv`, `results/task-one-current-head-long-hub4-r30000-summary.csv`, `results/task-one-current-head-long-tap-r30000-summary.csv`, `results/task-one-current-head-long-tap4-r30000-summary.csv`, `results/task-one-latestdev-isolated-p10ms-summary.csv`, `results/task-one-latestdev-isolated-p10ms-stability-3x-summary.csv` |
| Task two IP communication | `linux/qc_reliable_udp_client.py`, `linux/qc_qcz1_guest_demo.c`, `rtos/zephyr_udp_qc_protocol_udp.c` | `docs/protocol.md`, `docs/network-topology.md`, `docs/task-two-three-50-point-checklist.md`, `docs/task-two-three-score-summary.md`, `docs/test-report.md` |
| Task three AI control loop | `linux/qc_ai_control_demo.py`, `linux/qc_qcz1_guest_demo.c`, `rtos/zephyr_udp_qc_protocol_udp.c` | `docs/ai-control-evaluation.md`, `docs/task-two-three-50-point-checklist.md`, `docs/task-two-three-score-summary.md`, `results/task-three-second-metric-latestdev-summary.md`, `docs/test-report.md`, `docs/demo-video-script.md` |
| Engineering and reproducibility | `scripts/*.sh`, `scripts/*.py`, `docs/reproduce.md` | `docs/engineering-innovation-20-point-checklist.md`, `docs/final-submission-checklist.md`, this file |
| StarryOS bonus | `apps/starry/qemu/redcola-ai-control/` in private PR `#2` | `docs/starryos-bonus.md`, `docs/starryos-bonus-scorecard.md` |

## Representative Runtime Evidence

All raw runtime evidence is stored outside git under:

```text
/home/kali/qc-evidence/
```

Representative first-version evidence directories:

```text
/home/kali/qc-evidence/task1-hub-smoke-0worker-20260813_221836
/home/kali/qc-evidence/task1-hub-smoke-2worker-20260813_222007
/home/kali/qc-evidence/task1-after-hub-4worker-rt5000-20260813_232804
/home/kali/qc-evidence/task1-before1770-hub-smoke-0worker-rerun-20260813_223638
/home/kali/qc-evidence/task1-before1770-hub-smoke-2worker-20260813_224238
/home/kali/qc-evidence/t1-before1770-hub-r10000-20260814_011825
/home/kali/qc-evidence/t1-head760-hub-r10000-20260814_010458
/home/kali/qc-evidence/t1w1-hub-before-after-20260814_030333
/home/kali/qc-evidence/t1w4-hub-before-after-recovered-20260814_020210
/home/kali/qc-evidence/demo-hub-rehearsal-20260814_040528
/home/kali/qc-evidence/demo-hub-rehearsal-w1-20260814_042902
/home/kali/qc-evidence/qc-demo-hub-latest-e703-20260814_065528
/home/kali/qc-evidence/t1-head238-hub-r10000-20260814_070406
/home/kali/qc-evidence/t1-head588-hub-r10000-20260814_074255
/home/kali/qc-evidence/t1-head505-hub-r10000-20260814_091730
/home/kali/qc-evidence/t1-before-after-tap-fixed-114047
/home/kali/qc-evidence/qc-demo-hub-head-d9f8fa3c2-20260814_081925
/home/kali/qc-evidence/starry-qemu-redcola-ai-control-head-a43c124eefad-20260814_090233
/home/kali/qc-evidence/qc-demo-hub-head-e1a01b82-20260814_094911
/home/kali/qc-evidence/starry-qemu-redcola-qcz1-parity-head-4cbd22ccb837-20260814_103336
/home/kali/qc-evidence/t1-current-head-long-hub-2w-r30000-20260814_161251
/home/kali/qc-evidence/t1-head8984-long-hub-2w-r30000-20260814_173833
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_180823
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018
```

Representative markers already recorded in the submitted documents:

```text
Linux guest 2 vCPUs online
Plain UDP 20/20 PASS
QCZ1 reliable UDP 10/10 PASS
AI control 10/10 PASS
QC_RTOS_PERIODIC_RESULT=PASS
QC_DUAL_GUEST_LINUX_INIT=PASS
tcpdump kernel drops=0 in recorded TAP runs
Native Zephyr latency baseline: 47 metrics, PROJECT EXECUTION SUCCESSFUL
StarryOS bonus: REDCOLA_STARRY_QCZ1_PARITY_PASS, REDCOLA_STARRY_AI_CONTROL_PASS and REDCOLA_STARRY_AI_DONE
Latest verified checkpoint package:
redcola-current-head-with-video-20260815-dca3bfdd-v1.zip
Latest checkpoint package SHA256:
8710e9bbfad862201bd89e02d03b928a94f99f7b816d0eaece102be80c72aacd
Latest checkpoint package verification:
FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, fresh-unzip verify=PASS, files=63
```

The main PR branch may continue to receive documentation-only clarification
commits after the checkpoint package. In that case, use the package `README.txt`
and the SHA256 above to identify the exact verified upload package, and use the
runtime source heads listed below to identify measured QEMU evidence.

The 2026-08-14 private PR-head long hub matrix at
`/home/kali/qc-evidence/t1-head760-hub-r10000-20260814_010458` was collected
from runtime source head `760e253eec50c0425eadec321d56663e400ac28b`. It ran
`0` and `2` Linux-worker cases with `10000` Linux periodic samples. Both rows
reported `TASK_ONE_SECOND_VERSION_MATRIX=PASS`, Linux `2` vCPUs, UDP `20/20`,
QCZ1 `10/10`, AI `10/10`, and no missing markers. Because the run used hub
networking, tcpdump counters remain `n/a`; packet counters are covered by the
completed TAP/tcpdump matrix.

The matching pre-`#1770` long hub baseline at
`/home/kali/qc-evidence/t1-before1770-hub-r10000-20260814_011825` was collected
from baseline commit `bb562428c69317faccf2761167d2fabc47b82a37`. It also ran
`0` and `2` Linux-worker cases with `10000` Linux periodic samples and reported
UDP `20/20`, QCZ1 `10/10`, AI `10/10`, Linux `2` vCPUs and no missing markers.
Together with the private PR-head long hub matrix, this gives task one a
current before/after runtime comparison while the completed TAP/tcpdump matrix
adds packet-capture counters for the 0/2-worker shape.

The 1-worker fill-in evidence at
`/home/kali/qc-evidence/t1w1-hub-before-after-20260814_030333` extends the
same long hub before/after shape to an intermediate Linux pressure point. The
after row improves RTOS p99/max, Linux p99/max, UDP mean/max, QCZ1 mean/max and
AI e2e mean/max while keeping UDP `20/20`, QCZ1 `10/10`, AI `10/10` and Linux
`2` vCPUs in both rows.

The 4-worker overcommit hub boundary at
`/home/kali/qc-evidence/t1w4-hub-before-after-recovered-20260814_020210` uses
the same before/after shape with `4` Linux stress workers on a `2`-vCPU Linux
guest. Both rows report UDP `20/20`, QCZ1 `10/10`, AI `10/10`, Linux `2`
vCPUs and completed RTOS periodic probes. This evidence is kept as a pressure
boundary and stability note; it is not the primary latency-improvement claim
because the 4-worker Linux side is deliberately overcommitted.

The final-video hub rehearsal at
`/home/kali/qc-evidence/demo-hub-rehearsal-20260814_040528` is a recording
readiness check. It reports `analysis_result=PASS`, final `result=PASS`, Linux
`2` vCPUs, plain UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI `10/10`,
AI end-to-end mean/max `1589 us / 2697 us`, and RTOS periodic `PASS`. This run
uses `net_mode=hub`, so tcpdump is `SKIPPED`; it is a video rehearsal rather
than a replacement for the completed TAP/tcpdump before/after matrix.

The 1-worker final-video hub rehearsal at
`/home/kali/qc-evidence/demo-hub-rehearsal-w1-20260814_042902` is closer to
the final recording command because it runs one Linux stress worker and `3000`
Linux periodic samples. It reports `analysis_result=PASS`, final `result=PASS`,
Linux `2` vCPUs, Linux stress `STARTED` and `STOPPED`, plain UDP `20/20`, QCZ1
`10/10`, QCZ1 retransmits `0`, AI `10/10`, AI end-to-end mean/max
`3450 us / 20765 us`, RTOS periodic `PASS`, and `net_mode=hub`. It is useful
for final-video readiness under light Linux pressure. Because it uses hub mode,
tcpdump remains `SKIPPED`; packet-capture counters are covered by the completed
TAP matrix.

The recent PR-head hub rehearsal at
`/home/kali/qc-evidence/qc-demo-hub-latest-e703-20260814_065528` confirms that
head `e703ae46f8b6b1a814c0e5051776fc09d8f4022e` still reproduces the
integrated chain after the packaging/documentation updates. It reports final
`result=PASS`, `analysis_result=PASS`, Linux `2` vCPUs, one Linux stress
worker, plain UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI `10/10`, AI
end-to-end mean/max `4886 us / 18775 us`, RTOS p99/max `627184 ns /
2568800 ns`, and `net_mode=hub`. It is a recorded current-branch health check, not a
replacement for the completed TAP/tcpdump before/after matrix.

The previous PR-head long hub matrix at
`/home/kali/qc-evidence/t1-head238-hub-r10000-20260814_070406` was collected
from private PR `#1` head `238a868e61fe70b97e00b623a38ad73324339a42`. It ran
the `0` and `2` Linux-worker cases with `10000` Linux periodic samples and
reported `TASK_ONE_SECOND_VERSION_MATRIX=PASS`. Both rows kept Linux `2`
vCPUs, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, QCZ1 retransmits `0`, and no
missing markers. Because this was a hub-mode run, tcpdump counters remain
`n/a`; packet counters are covered by the completed TAP/tcpdump before/after
matrix.

The previous 0/1/2-worker private PR-head long hub matrix at
`/home/kali/qc-evidence/t1-head588-hub-r10000-20260814_074255` was collected
from private PR `#1` head `588ddf1a3e5e9697799f39b8334db73a1ea3bd15`. It ran
the `0`, `1` and `2` Linux-worker cases with `10000` Linux periodic samples and
reported `TASK_ONE_SECOND_VERSION_MATRIX=PASS`. All three rows kept Linux `2`
vCPUs, UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI `10/10` and no
missing markers. Because this was a hub-mode run, tcpdump counters remain
`n/a`; packet counters are covered by the completed TAP/tcpdump before/after
matrix.

The latest private PR long hub runtime matrix at
`/home/kali/qc-evidence/t1-head505-hub-r10000-20260814_091730` was collected
from private PR `#1` head `505ea1ff96c8fdb2d9c3ebe3ba372250ae721afb`. It ran
the `0` and `2` Linux-worker cases with `10000` Linux periodic samples and
reported `TASK_ONE_SECOND_VERSION_MATRIX=PASS`. Both rows kept Linux `2`
vCPUs, UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI `10/10` and no
missing markers. The 0-worker row reports RTOS mean/p99/max latency
`97403 / 1330176 / 4647392 ns` and AI e2e mean/max `1445 us / 2377 us`; the
2-worker row reports RTOS mean/p99/max latency `82387 / 1783376 / 5684112 ns`
and AI e2e mean/max `4024 us / 17057 us`. Because this was a hub-mode run,
tcpdump counters remain `n/a`; the TAP/tcpdump before/after matrix remains the
privileged packet-capture gate.

The latest current-head long pressure row at
`/home/kali/qc-evidence/t1-head8984-long-hub-2w-r30000-20260814_173833`
was collected from private PR `#1` runtime source head
`8984bd23dbb27b091aaa120020f0ac9eff59226d`. It extends the 2-worker pressure
case to `30000` Linux periodic samples and reports
`TASK_ONE_SECOND_VERSION_MATRIX=PASS`, Linux `2` vCPUs, UDP `20/20`, QCZ1
`10/10`, QCZ1 retransmits `0`, AI `10/10` and no missing markers. The
committed summaries are `results/task-one-current-head-long-hub-r30000-summary.csv`
and `results/task-one-current-head-long-hub-r30000-summary.md`. Because this
was a hub-mode long run, tcpdump counters remain `n/a`; the completed TAP
matrix continues to cover packet-capture proof.

The current-head 4-worker hub overcommit proof at
`/home/kali/qc-evidence/t1-current-head-hub4-r30000-20260814_204459` was
collected from private PR `#1` runtime source head
`91cb7c0fc00d579d62528a3c967e5efd3cc57836`. It extends the long-pressure
coverage to `4` Linux stress workers on a `2`-vCPU Linux guest and reports
`TASK_ONE_CURRENT_HEAD_LONG_HUB4_PROOF=PASS`, UDP `20/20`, QCZ1 `10/10`,
QCZ1 retransmits `0`, duplicate ACKs `2`, AI `10/10`, RTOS mean/p99/max
`79469 / 1143440 / 5372880 ns` and AI end-to-end mean/max
`3428 / 7887 us`. The committed summaries are
`results/task-one-current-head-long-hub4-r30000-summary.csv`,
`results/task-one-current-head-long-hub4-r30000-summary.md` and
`results/task-one-current-head-long-hub4-r30000-proof.txt`. This row is
reported as a heavy-pressure completion boundary, not as the primary
latency-improvement comparison.

The current-head 4-worker TAP/tcpdump overcommit proof at
`/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018` was collected
from the same private PR `#1` runtime source head
`91cb7c0fc00d579d62528a3c967e5efd3cc57836`. It keeps `4` Linux stress workers,
`30000` Linux periodic samples and the privileged TAP/tcpdump path active. The
row reports `TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS`, UDP `20/20`, QCZ1
`10/10`, QCZ1 retransmits `0`, duplicate ACKs `2`, AI `10/10`, RTOS
mean/p99/max `120165 / 1821568 / 31444800 ns`, Linux mean/p99/max
`15268450 / 124812416 / 153937328 ns`, AI end-to-end mean/max
`5277 / 15431 us`, and tcpdump captured/dropped `88/0`. The committed
summaries are `results/task-one-current-head-long-tap4-r30000-summary.csv`,
`results/task-one-current-head-long-tap4-r30000-summary.md` and
`results/task-one-current-head-long-tap4-r30000-proof.txt`.

The current-head long TAP proof at
`/home/kali/qc-evidence/t1-current-head-long-tap-20260814_180823` was collected
from private PR `#1` source head
`91cb7c0fc00d579d62528a3c967e5efd3cc57836`. It keeps the `30000` Linux
periodic samples and `2` Linux stress workers while using the privileged
TAP/tcpdump path. The row reports `PASS`, Linux `2` vCPUs, UDP `20/20`, QCZ1
`10/10`, QCZ1 retransmits `0`, duplicate ACKs `2`, AI `10/10`, RTOS
mean/p99/max `89652 / 1961824 / 9953504 ns`, Linux mean/p99/max
`1251285 / 7613808 / 25035136 ns`, AI end-to-end mean/max `2501 / 5014 us`,
and tcpdump captured/dropped `88/0`. The committed summaries are
`results/task-one-current-head-long-tap-r30000-summary.csv` and
`results/task-one-current-head-long-tap-r30000-summary.md`.

The main PR branch may advance as documentation and package-manifest notes are
refreshed. Runtime evidence source heads are listed separately below so
reviewers can distinguish measured QEMU runs from later documentation-only
updates.

The completed TAP before/after matrix at
`/home/kali/qc-evidence/t1-before-after-tap-fixed-114047` was collected from
private PR `#1` runtime source head
`2737d1e603b5b0d62cc4d6faf71dbdee33bd75c5` and the pre-`#1770` baseline
worktree. It reports `TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS`. The committed
tables are `results/task-one-before-after-tap-summary.csv` and
`results/task-one-before-after-tap-summary.md`. All four rows keep Linux `2`
vCPUs, UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI `10/10`, no missing
markers, and tcpdump captured/dropped `88/0`.

The latest private PR-head final-video rehearsal at
`/home/kali/qc-evidence/qc-demo-hub-head-d9f8fa3c2-20260814_081925` was
collected from head `d9f8fa3c24e92c52929f4903b80d4c08bc6cea37`. It reports
final `result=PASS`, `analysis_result=PASS`, Linux `2` vCPUs, one Linux stress
worker, plain UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI `10/10`, AI
end-to-end mean/max `2013 us / 3263 us`, RTOS p99/max
`632384 ns / 4649328 ns`, and `net_mode=hub`. It is the current recording
rehearsal proof; TAP/tcpdump remains preferred for a final recording when host
sudo is authenticated, while the task-one packet-capture proof is already
recorded in the completed TAP matrix.

The latest recorded private PR-head hub rehearsal at
`/home/kali/qc-evidence/qc-demo-hub-head-e1a01b82-20260814_094911` was
collected from head `e1a01b8263eba471625f26ef5e383db20744a40b`. It reports
final `result=PASS`, QEMU status `0`, Linux `2` vCPUs, one Linux stress
worker, plain UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, duplicate ACKs
`2`, AI `10/10`, AI end-to-end mean/max `4984 us / 35679 us`, AI-vs-manual
control error `207 / 240`, RTOS p99/max `965584 ns / 31472960 ns`, Linux
periodic p99/max `5504064 ns / 17148128 ns`, and `net_mode=hub`. The
`summary.txt` hash is
`690d21ef428c85331bd8bc354d494cc156e98639e650e571515908c4c6e1dfdd`; the
`qemu.log` hash is
`7ff865f1e1d380b722f5f1627c1f292dc53e7e8064084c28181bb3fdeab0b8e3`.
This is a current-head integrated rehearsal proof; the privileged
packet-capture gate is covered by the completed TAP before/after matrix.

The latest StarryOS bonus was also rebuilt and executed on official `dev`
`0340ed6b`:

```text
evidence: /home/kali/qc-evidence/starry-latestdev0340-20260821
REDCOLA_STARRY_QCZ1_PARITY_PASS
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0 mean_infer_us=131
REDCOLA_STARRY_AI_DONE
REDCOLA_STARRY_LATESTDEV0340_QEMU=PASS
qemu.log SHA256: c0a4db06c8625ca40d8ed060a5d3259c918b1e4f6b28878a593656b559ea2d16
summary.txt SHA256: e6164b25703183dd793fba3e601e3fd3a0ec179c47810fd385d83f735c7867b7
```

This is StarryOS non-RT guest and protocol-frame parity bonus evidence; it does
not replace the main AxVisor Linux/RTOS network closed loop. The updated
StarryOS notes remain local until PR `#2` is separately authorized for update.

## Second-Version TAP Evidence

The previous task-one packet-capture gap is now closed by the TAP/tcpdump
before/after matrix described in `docs/second-version-submission-status.md`:

```text
current branch, TAP, 0 workers
current branch, TAP, 2 workers
pre-#1770 baseline, TAP, 0 workers
pre-#1770 baseline, TAP, 2 workers
```

This step required interactive `sudo -v` on the Kali host because TAP devices,
bridge devices and tcpdump captures need host privileges. The repository does
not store or pass any sudo password. The final output was
`TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS`.
