# Second-Version Submission Status

This note tracks the redcola second-version status for the 2026-08-21
Quancheng Lab AxVisor contest checkpoint. It focuses on the task-one realtime
gap because that is the largest remaining scoring risk after the first-version
submission.

## Current Second-Version Position

| Area | Status | Evidence |
| --- | --- | --- |
| First-version private submission | submitted | `qcl-kernel/tgoskits-redcola#1` and `#2` |
| Main task-one automation | ready | `scripts/run_task_one_second_version_matrix.sh` |
| Current-branch hub smoke | passed | 0/2/4-worker hub-mode evidence in `docs/task-one-second-version-plan.md` |
| Private PR-head long hub matrix | passed | `760e253e`, 0/2-worker, 10000-sample evidence in `/home/kali/qc-evidence/t1-head760-hub-r10000-20260814_010458` |
| Previous private PR-head long hub matrix | passed | `238a868e`, 0/2-worker, 10000-sample evidence in `/home/kali/qc-evidence/t1-head238-hub-r10000-20260814_070406` |
| Previous 0/1/2-worker PR-head long hub matrix | passed | `588ddf1a`, 0/1/2-worker, 10000-sample evidence in `/home/kali/qc-evidence/t1-head588-hub-r10000-20260814_074255` |
| Latest runtime-proof long hub matrix | passed | `505ea1ff`, 0/2-worker, 10000-sample evidence in `/home/kali/qc-evidence/t1-head505-hub-r10000-20260814_091730` |
| Current-head long pressure row | passed | `8984bd23`, 2-worker, 30000-sample hub evidence in `/home/kali/qc-evidence/t1-head8984-long-hub-2w-r30000-20260814_173833`; UDP `20/20`, QCZ1 `10/10`, AI `10/10`, RTOS p99/max `685872 / 2001840 ns` |
| Current-head long TAP proof | passed | `91cb7c0f`, 2-worker, 30000-sample TAP/tcpdump evidence in `/home/kali/qc-evidence/t1-current-head-long-tap-20260814_180823`; UDP `20/20`, QCZ1 `10/10`, AI `10/10`, RTOS p99/max `1961824 / 9953504 ns`, tcpdump `88/0` |
| Current-head 4-worker hub overcommit proof | passed | `91cb7c0f`, 4-worker, 30000-sample hub evidence in `/home/kali/qc-evidence/t1-current-head-hub4-r30000-20260814_204459`; UDP `20/20`, QCZ1 `10/10`, AI `10/10`, RTOS p99/max `1143440 / 5372880 ns`, AI e2e mean/max `3428 / 7887 us` |
| Current-head 4-worker TAP overcommit proof | passed | `91cb7c0f`, 4-worker, 30000-sample TAP/tcpdump evidence in `/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018`; UDP `20/20`, QCZ1 `10/10`, AI `10/10`, RTOS p99/max `1821568 / 31444800 ns`, AI e2e mean/max `5277 / 15431 us`, tcpdump `88/0` |
| Recorded full long hub pressure matrix | passed | Runtime source head `b706a02c`, 0/1/2/4-worker, 30000-sample hub evidence in `/home/kali/qc-evidence/t1-headb706-full-hub-r30000-20260815_022916`; UDP `20/20`, QCZ1 `10/10`, AI `10/10` in all rows; RTOS p99/max ranges from `1372496 / 3525056 ns` at 0 workers to `931056 / 2066960 ns` at 4 workers |
| Exact submitted-head 2-worker stability repeat | passed | `746042293`, 3 repeated 2-worker hub runs with 30000 Linux periodic samples in `/home/kali/qc-evidence/t1-head746-2w-hub-stability-r30000-20260815_031511`; repeat result `3/3 PASS`; UDP `20/20`, QCZ1 `10/10`, AI `10/10` in every run; RTOS p99/max range `882896-1040304 / 2043904-3080560 ns` |
| Recorded a9ce long hub proof | passed | `a9ceb7dc`, 2-worker, 30000-sample hub evidence in `/home/kali/qc-evidence/t1-a9ce-long-hub-20260815_064606`; UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI `10/10`, no missing markers; RTOS p99/max `1115280 / 5921456 ns`; copied into `results/task-one-head-a9ce-long-hub-r30000-*` and included in the refreshed package manifest. |
| 8.14 archive proof point | passed | Generated from selected private PR heads with main PR `#1` source head `b668ba83a`, StarryOS PR `#2` source head `e3d8bbf8`, archive `redcola-current-head-with-video-20260814-b668ba83a-v2.zip`, SHA256 `405dceb29de54ae4ac9a1243ae056bb30caaddcd769e76e71d2260b168abc883`, files=`55`; strict package verify and fresh-unzip verify both `PASS`. Later documentation-only commits may record this proof point; regenerate once from the final selected head before the 2026-08-24 upload. |
| 8.15 verified archive proof point | passed | Generated from main PR `#1` source head `8ba0a9f3c9a8e9c698cacf99cc227215db9ec46c` with StarryOS PR `#2` source head `e3d8bbf8d9dc6cf7f512017092fb3fdb0c4857f2`, archive `redcola-current-head-with-video-20260815-8ba0a9f3-v1.zip`, SHA256 `7dba8d140ee03db828ccde6514b45dd387fd26d0e7eabbf03c3182538667501e`, files=`57`; strict package verify and fresh-unzip verify both `PASS`; includes video, StarryOS bonus material, exact-head stability repeat summaries and refreshed second-version message/defense notes. |
| 8.15 refreshed archive proof point | passed | Generated after adding the StarryOS scorecard to the package manifest from main PR `#1` source head `498218c726d90e766f9c6802677964c152c46f24` with StarryOS PR `#2` source head `e2a0493ada72fb58eb413bbe46253d2eaa07dc18`, archive `redcola-current-head-with-video-20260815-498218c7-v1.zip`, SHA256 `84755e3d3e2e784c4802b13aa967512cc87331b85e791282e66ef277498c1a30`, files=`59`; `FINAL_PACKAGE_BUILD=PASS`, `FINAL_PACKAGE_VERIFY=PASS`, fresh-unzip verify `PASS`; includes video, StarryOS bonus material and `starryos-bonus/SCORECARD.md`. |
| 8.15 refreshed archive proof point | passed | Generated after adding the task-one reviewer defense Q&A from main PR `#1` source head `ac4fb2e9a09fd41b209620f999862565b8d83242` with StarryOS PR `#2` source head `e2a0493ada72fb58eb413bbe46253d2eaa07dc18`, archive `redcola-current-head-with-video-20260815-ac4fb2e9-v1.zip`, SHA256 `8ac88200eb510b7c96d676864680001e73e0e9294483abe67e5454c08cbbe063`, files=`60`; `FINAL_PACKAGE_BUILD=PASS`, `FINAL_PACKAGE_VERIFY=PASS`, fresh-unzip verify `PASS`; includes video, StarryOS bonus material, `starryos-bonus/SCORECARD.md` and `docs/task-one-reviewer-defense-qna.md`. |
| 8.15 refreshed archive proof point | passed | Generated after adding the StarryOS reviewer quickstart from main PR `#1` source head `5b614af572296fc1e09f5b26917bdfd8d544cbf9` with StarryOS PR `#2` source head `c8ec750378c5783b9c32518395dc3fbd1ae2449e`, archive `redcola-current-head-with-video-20260815-5b614af5-v1.zip`, SHA256 `fe468e37439d4f45ab5fc8f078fa8adde484887479c8911b76e7ca3ef2f4b8a2`, files=`63`; `FINAL_PACKAGE_BUILD=PASS`, `FINAL_PACKAGE_VERIFY=PASS`, fresh-unzip verify `PASS`; includes video, StarryOS bonus material, `starryos-bonus/REVIEWER-QUICKSTART.md`, `starryos-bonus/SCORECARD.md`, task-one defense material and final video proof. |
| 8.15 latest refreshed archive proof point | passed | Generated after syncing the StarryOS bonus review head and latest reviewer-facing documentation from main PR `#1` source head `dca3bfdd58b3f1df14258c622cb824325ca89946` with StarryOS PR `#2` source head `359a2746d94f9128ea2843109e4eb6b8bf53eda7`, archive `redcola-current-head-with-video-20260815-dca3bfdd-v1.zip`, SHA256 `8710e9bbfad862201bd89e02d03b928a94f99f7b816d0eaece102be80c72aacd`, files=`63`; `FINAL_PACKAGE_BUILD=PASS`, `FINAL_PACKAGE_VERIFY=PASS`, fresh-unzip verify `PASS`; follow-up PR head `212b449e18a01218c1c9f74a081267e28605da13` records this package proof in the review documents. |
| Current upload package identity | generated artifact | For the current attached ZIP, use package `README.txt` for the exact main source head and the sibling external `.zip.sha256` file for the exact archive hash. This avoids self-referential hashes when documentation is refreshed. |
| Pre-`#1770` baseline hub smoke | passed | 0/2-worker baseline rows in `docs/task-one-second-version-plan.md` |
| Pre-`#1770` long hub matrix | passed | `bb562428c`, 0/2-worker, 10000-sample evidence in `/home/kali/qc-evidence/t1-before1770-hub-r10000-20260814_011825` |
| 1-worker long hub before/after fill-in | passed | before/after 1-worker, 10000-sample evidence in `/home/kali/qc-evidence/t1w1-hub-before-after-20260814_030333` |
| 4-worker overcommit hub boundary | passed | before/after 4-worker, 10000-sample evidence in `/home/kali/qc-evidence/t1w4-hub-before-after-recovered-20260814_020210` |
| TAP/tcpdump before/after matrix | passed | 0/2-worker before/after TAP evidence in `/home/kali/qc-evidence/t1-before-after-tap-fixed-114047`; `TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS`, tcpdump `88/0` in each row |
| Native RTOS baseline | ready | Zephyr `latency_measure` table in `docs/realtime-evaluation.md` |
| Static preflight | passed | Windows Python syntax check `QC_LOCAL_PY_SYNTAX=PASS`; Kali 64-bit preflight `QC_STATIC_PREFLIGHT=PASS` |
| Final video | final user-narrated recording pending | the second-version checkpoint archive included a superseded draft `video/redcola-axvisor-demo.mp4`; use `docs/demo-video-script.md` and the presentation package to record the selected final video before the final submission |

The second-version task-one target is not merely to show that the system boots.
It should show the same dual-guest workload before and after the landed AxVisor
timer support, under both no-pressure and Linux-pressure conditions, with
packet-capture counters recorded in the same shape.

## Score-Raising Focus

The 2026-08-14 first-version submission is already present in the private
repository. The 2026-08-21 work should therefore focus on evidence that can
raise the realtime score, not on changing the already-working communication or
AI control paths.

| Priority | Evidence to add or preserve | Why it matters |
| --- | --- | --- |
| 1 | TAP/tcpdump before/after rows for current branch and pre-`#1770` baseline. | Completed on 2026-08-14; converts the existing hub-mode realtime comparison into packet-captured network evidence with the same shape as the contest communication requirement. |
| 2 | Keep the 0/1/2-worker before/after table as the primary latency-improvement claim. | These rows are comparable pressure points and already show RTOS p99 improvement while keeping UDP/QCZ1/AI markers passing. |
| 3 | Keep the 4-worker row as an overcommit boundary, not as the primary improvement claim. | Four Linux workers on a 2-vCPU Linux guest is useful stress evidence, but it is deliberately overloaded and should not be overstated. |
| 4 | Do not rewrite the stable QCZ1/AI path unless a reviewer requests it. | Task two and task three are currently the strongest scoring areas; unnecessary churn risks losing reproducibility. |
| 5 | Use the final video to show live PASS markers plus the before/after evidence table. | The video should make the closed loop easy to understand even if reviewers do not replay the full QEMU run. |

## Runtime State

The latest prepared Kali worktree for the main private PR package build is:

```text
/home/kali/qc-tgoskits-qcl-run-91cb-1806
```

An older TAP before/after helper worktree remains documented below because it
is the source of the completed privileged TAP matrix:

```text
/home/kali/qc-tgoskits-qcl-current-962e3c4d
```

The current pre-`#1770` baseline worktree is:

```text
/home/kali/qc-task1-before-1770-20260813
```

The current PR worktree has the task-one matrix runner and the runtime
artifacts linked in. The long hub runtime rows used source head `760e253e` for
the after side and baseline commit `bb562428c` for the before side. Later
private PR commits update documentation and the runtime analyzer. The analyzer
follow-up at `6dddec6dc80c1695b7c299668c9c40f684fb2dca` recovers a strict
RTOS periodic PASS only when a completed RTOS sample stream is present and no
RTOS failure marker is seen. The runtime long hub runs generated both CSV and
Markdown summaries under:

```text
/home/kali/qc-evidence/t1-head760-hub-r10000-20260814_010458
/home/kali/qc-evidence/t1-before1770-hub-r10000-20260814_011825
/home/kali/qc-evidence/t1w1-hub-before-after-20260814_030333
/home/kali/qc-evidence/t1w4-hub-before-after-recovered-20260814_020210
/home/kali/qc-evidence/t1-head238-hub-r10000-20260814_070406
/home/kali/qc-evidence/t1-head588-hub-r10000-20260814_074255
/home/kali/qc-evidence/t1-head505-hub-r10000-20260814_091730
```

The previous long hub matrix uses private PR `#1` head
`238a868e61fe70b97e00b623a38ad73324339a42`. It preserves the same 0/2-worker,
10000-sample shape after the final-package and documentation refreshes, and
reports `TASK_ONE_SECOND_VERSION_MATRIX=PASS` for both rows.

The previous 0/1/2-worker long hub matrix uses private PR `#1` head
`588ddf1a3e5e9697799f39b8334db73a1ea3bd15`. It preserves the same `0` and `2`
Linux-worker long-sample shape and adds the `1`-worker middle point; all three
rows report `TASK_ONE_SECOND_VERSION_MATRIX=PASS`, Linux `2` vCPUs, UDP
`20/20`, QCZ1 `10/10`, AI `10/10` and no missing markers.

The latest runtime-proof long hub matrix uses private PR `#1` source head
`505ea1ff96c8fdb2d9c3ebe3ba372250ae721afb`. It preserves the `0` and `2`
Linux-worker long-sample shape after the latest StarryOS bonus evidence links
were refreshed. Both rows report `TASK_ONE_SECOND_VERSION_MATRIX=PASS`,
Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, AI `10/10` and no missing
markers. The 0-worker RTOS mean/p99/max latency is `97403 / 1330176 /
4647392 ns`; the 2-worker RTOS mean/p99/max latency is `82387 / 1783376 /
5684112 ns`. Because this was a hub-mode run, tcpdump counters remain `n/a`;
the subsequent TAP matrix below is the packet-captured before/after proof.

The latest current-head long pressure row uses private PR `#1` runtime source
head `8984bd23dbb27b091aaa120020f0ac9eff59226d`. It extends the 2-worker
pressure case from `10000` to `30000` Linux periodic samples while keeping
Linux `2` vCPUs, plain UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI
`10/10` and no missing markers. The evidence root is:

```text
/home/kali/qc-evidence/t1-head8984-long-hub-2w-r30000-20260814_173833
```

The row reports RTOS mean/p99/max `51404 / 685872 / 2001840 ns`, Linux
mean/p99/max `1258737 / 9481712 / 37442704 ns`, QCZ1 latency mean/max
`3125 / 8779 us`, and AI end-to-end mean/max `3441 / 5529 us`. Because this is
a hub-mode long run, tcpdump remains `n/a`; packet-capture counters remain
covered by the TAP matrix.

The current-head long TAP proof uses private PR `#1` runtime source head
`91cb7c0fc00d579d62528a3c967e5efd3cc57836`. It keeps the same `30000` Linux
periodic samples, `2` Linux stress workers, Linux `2` vCPUs, plain UDP
`20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI `10/10` and no missing
markers, but runs through the privileged TAP/tcpdump path. The evidence root is:

```text
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_180823
```

The row reports RTOS mean/p99/max `89652 / 1961824 / 9953504 ns`, Linux
mean/p99/max `1251285 / 7613808 / 25035136 ns`, QCZ1 latency mean/max
`3107 / 8682 us`, AI end-to-end mean/max `2501 / 5014 us`, and tcpdump
captured/dropped `88/0`. The committed summaries are
`results/task-one-current-head-long-tap-r30000-summary.csv` and
`results/task-one-current-head-long-tap-r30000-summary.md`.

After this long TAP proof, the private PR head advanced to
`b706a02cdbf9e4688edc3def932ea4ae5159bbcd` for evidence documentation
refreshes. That exact head was checked with the same integrated dual-guest
runner in hub mode at
`/home/kali/qc-evidence/t1-headb706-full-hub-r30000-20260815_022916`, using
`30000` Linux periodic samples at `0`, `1`, `2` and `4` Linux stress workers.
All four rows produced `result=PASS`, Linux `2` vCPUs, UDP `20/20`, QCZ1
`10/10`, AI `10/10`, and no missing markers. This is kept as a recorded
full long hub proof; packet-capture claims remain tied to the recorded
TAP/tcpdump source heads above.

The exact submitted head then advanced to
`746042293ac61bc5cb894c6c470ae76fdc02674a` after hardening the analyzer
against serial-log interleaving of the RTOS result marker. The same 2-worker,
`30000`-sample hub pressure row was repeated 3 times at:

```text
/home/kali/qc-evidence/t1-head746-2w-hub-stability-r30000-20260815_031511
```

All three runs report `TASK_ONE_SECOND_VERSION_MATRIX=PASS`,
`analysis_result=PASS`, Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, AI
`10/10`, and no missing markers. The RTOS p99/max range across the repeat is
`882896-1040304 / 2043904-3080560 ns`.

After the first-version package wording refresh, an additional recorded
long-hub proof was refreshed at source head
`a9ceb7dc8e93d1d91df16036800bdad1600ea835` using the same 2-worker,
`30000`-sample hub pressure shape. The evidence root is:

```text
/home/kali/qc-evidence/t1-a9ce-long-hub-20260815_064606
```

The row reports `TASK_ONE_A9CE_LONG_HUB_PROOF=PASS`,
`TASK_ONE_SECOND_VERSION_MATRIX=PASS`, Linux `2` vCPUs, UDP `20/20`, QCZ1
`10/10`, QCZ1 retransmits `0`, duplicate ACKs `2`, AI `10/10`, no missing
markers, RTOS mean/p99/max `72094 / 1115280 / 5921456 ns`, Linux mean/p99/max
`1021556 / 4862240 / 31883280 ns`, and AI end-to-end mean/max
`6335 / 30654 us`. Because this is a hub-mode long proof, packet capture
remains covered by the TAP/tcpdump rows above.

The matching 4-worker TAP/tcpdump overcommit proof was then run from the same
runtime source head. It keeps `4` Linux stress workers on the `2`-vCPU Linux
guest with `30000` Linux periodic samples and the privileged packet-capture
path. The evidence root is:

```text
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018
```

It reports `TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS`, UDP `20/20`, QCZ1
`10/10`, QCZ1 retransmits `0`, duplicate ACKs `2`, AI `10/10`, RTOS p99/max
`1821568 / 31444800 ns`, AI end-to-end mean/max `5277 / 15431 us`, and tcpdump
captured/dropped `88/0`. The committed summaries are
`results/task-one-current-head-long-tap4-r30000-summary.csv`,
`results/task-one-current-head-long-tap4-r30000-summary.md` and
`results/task-one-current-head-long-tap4-r30000-proof.txt`.

The first-checkpoint archive is generated from the selected private PR heads and
records the exact main source head in its generated `README.txt`. Later
documentation-only PR commits may advance the branch after a package is built;
the runtime source heads, package source head and current PR head are therefore
intentionally tracked separately.

The TAP before/after matrix was then run from current private PR `#1` source
head `2737d1e603b5b0d62cc4d6faf71dbdee33bd75c5` with the pre-`#1770`
baseline worktree. The evidence root is:

```text
/home/kali/qc-evidence/t1-before-after-tap-fixed-114047
```

All four rows report `PASS`, Linux `2` vCPUs, plain UDP `20/20`, QCZ1
`10/10`, QCZ1 retransmits `0`, AI `10/10`, no missing markers, and tcpdump
captured/dropped `88/0`.

| Phase | Workers | Result | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | AI | tcpdump |
| --- | ---:| --- | ---:| ---:| ---:| ---:| ---:| ---:|
| after | `0` | `PASS` | `83166 / 1290544 / 9349568` | `786370 / 2141264 / 14366752` | `20/20` | `10/10` | `10/10` | `88/0` |
| after | `2` | `PASS` | `72137 / 927216 / 9913056` | `949349 / 5177888 / 29571664` | `20/20` | `10/10` | `10/10` | `88/0` |
| before | `0` | `PASS` | `51834 / 791120 / 3671568` | `863998 / 2761120 / 13642256` | `20/20` | `10/10` | `10/10` | `88/0` |
| before | `2` | `PASS` | `54287 / 1273216 / 3565712` | `1259651 / 13018080 / 41490032` | `20/20` | `10/10` | `10/10` | `88/0` |

## TAP Matrix Commands

This is the exact rerun command for the completed TAP matrix. It requires
interactive `sudo -v` on Kali because TAP devices, bridge devices and tcpdump
captures need host privileges; the repo intentionally does not store or pass
any sudo password.

```sh
cd /home/kali/qc-tgoskits-qcl-current-962e3c4d/os/axvisor/contest/quancheng2026
sudo -v

./scripts/run_task_one_before_after_tap_matrix.sh \
  --current-repo /home/kali/qc-tgoskits-qcl-current-962e3c4d \
  --baseline-repo /home/kali/qc-task1-before-1770-20260813 \
  --linux-rt-samples 10000 \
  --workers 0,2 \
  --timeout 900 \
  --evidence-root "/tmp/t1-before-after-tap-fixed-$(date +%H%M%S)"
```

Expected wrapper output:

```text
TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS
after_summary_csv=<evidence-root>/after/task-one-second-version-summary.csv
before_summary_csv=<evidence-root>/before/task-one-second-version-summary.csv
```

Equivalent manual commands are:

```sh
cd /home/kali/qc-tgoskits-qcl-current-962e3c4d/os/axvisor/contest/quancheng2026
sudo -v

./scripts/run_task_one_second_version_matrix.sh \
  --net-mode tap \
  --linux-rt-samples 10000 \
  --workers 0,2 \
  --timeout 900 \
  --label-prefix after \
  --evidence-root "/tmp/t1-after-tap-$(date +%H%M%S)"

./scripts/run_task_one_second_version_matrix.sh \
  --repo /home/kali/qc-task1-before-1770-20260813 \
  --net-mode tap \
  --linux-rt-samples 10000 \
  --workers 0,2 \
  --timeout 900 \
  --label-prefix before \
  --evidence-root "/tmp/t1-before-tap-$(date +%H%M%S)"
```

Expected per-matrix output:

```text
TASK_ONE_SECOND_VERSION_MATRIX=PASS
summary_csv=<evidence-root>/task-one-second-version-summary.csv
summary_md=<evidence-root>/task-one-second-version-summary.md
```

For a score-raising current-head long TAP proof, use the dedicated wrapper
after a fresh interactive sudo authentication:

```sh
cd /home/kali/qc-tgoskits-qcl-current-962e3c4d/os/axvisor/contest/quancheng2026
sudo -v

./scripts/run_task_one_current_head_long_tap_proof.sh \
  --repo /home/kali/qc-tgoskits-qcl-current-962e3c4d \
  --linux-rt-samples 30000 \
  --workers 2 \
  --timeout 1800
```

The completed 4-worker overcommit rerun used the same wrapper with `--workers 4`.

Expected wrapper output:

```text
TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS
persisted_evidence_root=/home/kali/qc-evidence/t1-current-head-long-tap-<timestamp>
summary_csv=/tmp/t1ltap-<timestamp>/task-one-second-version-summary.csv
summary_md=/tmp/t1ltap-<timestamp>/task-one-second-version-summary.md
```

Each row should include:

- Linux guest `2` vCPU marker;
- RTOS periodic mean, p99 and max latency;
- Linux periodic mean, p99 and max latency;
- plain UDP `20/20`;
- QCZ1 `10/10`, retransmits and duplicate ACKs;
- AI `10/10`, end-to-end mean and max latency;
- tcpdump captured packets and kernel dropped packets.

## Second-Version Acceptance Gate

The task-one second-version evidence now satisfies the TAP matrix gate on top
of the existing hub-mode smoke rows:

1. Current branch, TAP, `0` Linux workers: `PASS` with tcpdump kernel drops `0`.
2. Current branch, TAP, `2` Linux workers: `PASS` with tcpdump kernel drops `0`.
3. Pre-`#1770` baseline, TAP, `0` Linux workers: `PASS` with tcpdump kernel
   drops `0`.
4. Pre-`#1770` baseline, TAP, `2` Linux workers: `PASS` with tcpdump kernel
   drops `0`.
5. The final table states what improved, what stayed stable and which numbers
   are not directly comparable to native Zephyr.

Task one should still be improved through final-video packaging and concise
reviewer explanation, but the main second-version packet-capture gap is no
longer pending.
