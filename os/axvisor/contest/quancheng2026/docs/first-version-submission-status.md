# First-Version Submission Status

This note records the redcola first-version submission status for the
2026-08-14 Quancheng Lab AxVisor contest checkpoint.

## Repository Entry Points

| Item | Status | Location |
| --- | --- | --- |
| Private review repository | submitted | `https://github.com/qcl-kernel/tgoskits-redcola` |
| Main AxVisor contest PR | submitted | `qcl-kernel/tgoskits-redcola#1`, branch `contest/axvisor-2026` |
| StarryOS bonus PR | submitted separately | `qcl-kernel/tgoskits-redcola#2`, branch `contest/starry-redcola-ai-bonus-clean-20260731` |
| Main contest directory | submitted | `os/axvisor/contest/quancheng2026/` |
| StarryOS bonus directory | submitted separately | `apps/starry/qemu/redcola-ai-control/` |

The main PR intentionally keeps the first-version AxVisor contest artifacts
under `os/axvisor/contest/quancheng2026/`. It does not include generated
runtime images, QEMU logs, packet captures or temporary build outputs.

## First-Version Coverage

| Contest area | First-version evidence |
| --- | --- |
| Task one: realtime validation | AxVisor-hosted 2-vCPU Linux guest plus Zephyr RTOS guest, Linux/RTOS periodic probes, native Zephyr latency baseline, 0/1/2/4-worker stress tables, 2-worker stability campaign, pre-`#1770`/current 10000-sample hub before/after rows, and a 4-worker overcommit boundary. |
| Task two: guest communication | IPv4/UDP Linux-to-RTOS path, QCZ1 application protocol, ACK/status/error handling, duplicate ACK coverage, retransmit counters, tcpdump packet/drop evidence in TAP-mode runs. |
| Task three: AI control loop | Fixed-point neural-network inference on the non-RT side, QCZ1 transport to RTOS, RTOS state update and status return, end-to-end latency metrics, manual baseline comparison. |
| Engineering and documents | Design document, test report, reproduce guide, protocol spec, network topology, scorecard traceability, final checklist, PR description draft and video script. |
| StarryOS bonus | Separate StarryOS QEMU AI-control demo branch with runtime PASS markers. |

## Validation Snapshot

The submitted material contains the following representative checked evidence.
The current main PR branch head is shown by private PR `#1` and should be
treated as the source of truth. The entries below record the main validation
checkpoints rather than requiring a self-referential commit hash inside this
document.

- 2026-08-13 private-repository preflight at
  `1a3a94f357d27809ee6521d75f1861b16cab0554`: PR scope limited to
  `os/axvisor/contest/quancheng2026/`; `git diff --check` passed; Python
  `py_compile` passed for `9` files; tracked generated-artifact scan passed;
  credential scan for sudo/password markers passed; Kali/Linux `bash -n`
  passed for shell scripts; QCZ1 status negative selftest passed on Kali.
- 2026-08-14 documentation follow-up: PR scope remained limited to
  `os/axvisor/contest/quancheng2026/`; tracked generated-artifact scan passed;
  `git diff --check origin/dev...HEAD` passed; Task-Two communication,
  Task-Three AI-control and task-one score gates were clarified in the
  reviewer-facing documents.
- 2026-08-14 branch-head recording note: the evidence index, first-version
  status and final checklist point reviewers at private PR `#1` and `#2`
  instead of relying on a self-referential commit hash embedded in the same
  branch.
- 2026-08-14 long hub before/after matrix: pre-`#1770` baseline and current
  branch both ran 0/2-worker, 10000-sample rows with Linux `2` vCPUs, UDP
  `20/20`, QCZ1 `10/10` and AI `10/10`.
- 2026-08-14 4-worker overcommit boundary: pre-`#1770` baseline and current
  branch both kept RTOS periodic, UDP, QCZ1 and AI-control gates passing under
  4 Linux stress workers on the 2-vCPU Linux guest.
- 2026-08-14 TAP/tcpdump before/after matrix: pre-`#1770` baseline and current
  branch both ran 0/2-worker TAP rows; all four rows passed with Linux `2`
  vCPUs, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, retransmits `0` and tcpdump
  captured/dropped `88/0`.
- 2026-08-14 current-head long TAP pressure proof: 2-worker, `30000` Linux
  periodic samples, Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, AI `10/10`,
  RTOS p99/max `1961824 / 9953504 ns` and tcpdump captured/dropped `88/0`.
- 2026-08-14 current-head 4-worker hub overcommit proof: 4 Linux stress
  workers on a 2-vCPU Linux guest, `30000` Linux periodic samples, UDP
  `20/20`, QCZ1 `10/10`, AI `10/10`, RTOS p99/max
  `1143440 / 5372880 ns`, and
  `TASK_ONE_CURRENT_HEAD_LONG_HUB4_PROOF=PASS`.
- 2026-08-14 current-head 4-worker TAP/tcpdump proof: 4 Linux stress workers
  on a 2-vCPU Linux guest, `30000` Linux periodic samples, UDP `20/20`,
  QCZ1 `10/10`, AI `10/10`, RTOS p99/max `1821568 / 31444800 ns`, AI
  end-to-end mean/max `5277 / 15431 us`, and tcpdump captured/dropped `88/0`.
- 2026-08-14 first-checkpoint package proof after TAP4 and video-script
  refresh: archive `redcola-current-head-with-video-20260814-b668ba83a-v2.zip`,
  files `55`, SHA256
  `405dceb29de54ae4ac9a1243ae056bb30caaddcd769e76e71d2260b168abc883`,
  package verify `PASS` and fresh-unzip verify `PASS`.
- Native Zephyr latency baseline: `47` metrics and `PROJECT EXECUTION SUCCESSFUL`.
- AxVisor dual-guest Linux/Zephyr runtime: Linux `2` vCPUs online.
- Plain UDP: `20/20 PASS`.
- QCZ1 reliable UDP: `10/10 PASS`, retransmits `0`, duplicate ACK path covered.
- AI control: `10/10 PASS`, status return validated.
- TAP/tcpdump evidence: `88` packets captured, `0` kernel drops in recorded TAP runs.
- Stress evidence: 0/1/2/4 Linux-worker runs recorded; 2-worker stability campaign `3/3 PASS`.
- Second-version task-one preparation: pre-`#1770` and current-branch
  before/after rows are recorded in both hub and TAP/tcpdump modes, and the
  current-head long-pressure TAP proof is recorded as the extended packet
  capture gate.

## Follow-Up Toward Final Submission

These items are not blockers for the 2026-08-14 first-version checkpoint, but
they are planned for the 2026-08-21 and 2026-08-24 submissions:

- Completed for the second-version task-one evidence: the pre-`#1770` and
  current-branch comparison was rerun in TAP mode, so tcpdump captured/drop
  counters are present in the same before/after table. The committed summaries
  are `results/task-one-before-after-tap-summary.csv` and
  `results/task-one-before-after-tap-summary.md`.
- Keep the strongest second-version realtime results visible in
  `docs/realtime-evaluation.md`, `docs/test-report.md`,
  `docs/task-one-30-point-checklist.md` and
  `results/task-one-second-version-summary.md`.
- Keep the StarryOS bonus PR separate unless the organizers request a combined
  branch.
- Record or refresh the final five-minute demo video from
  `docs/demo-video-script.md` and `docs/final-video-cue-card-cn.md` before the
  2026-08-24 final package.
