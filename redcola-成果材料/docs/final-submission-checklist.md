# Final Submission Checklist

This checklist tracks the remaining steps from the current redcola contest
artifact state to the final Quancheng Lab submission.

## Current Ready State

| Item | Status | Evidence |
| --- | --- | --- |
| Zephyr e1000/IP baseline | READY | `docs/e1000_axvisor.md`, `rtos/zephyr_ipv4only_udp_mgmt12288.conf` |
| Linux/RTOS QCZ1 reliable UDP | READY | `docs/protocol.md`, `linux/qc_reliable_udp_client.py`, integrated run summaries |
| AI control closed loop | READY | `docs/ai-control-evaluation.md`, `linux/qc_ai_control_demo.py` |
| Realtime comparison | SECOND-VERSION TAP GATE PASS | `docs/realtime-evaluation.md`, `results/realtime-comparison.csv`, 10000-sample hub before/after matrix, `results/task-one-before-after-tap-summary.csv`, and current-head 30000-sample hub/TAP long-pressure rows; TAP/tcpdump before/after reports `TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS`, and the 4-worker TAP overcommit proof reports tcpdump `88/0` |
| Physical-board native Linux baseline | PASS; CONSERVATIVE CLAIM | `docs/physical-board-native-linux-baseline.md`; ATK-DLRK3588B RK3588, `900000` cyclictest cycles, idle/isolated/full-pressure maximum latency `95/76/1338 us`, zero histogram overflows. This is a native-Linux reference, not AxVisor-on-RK3588. |
| Task-one second-version plan | READY | `docs/task-one-second-version-plan.md` |
| Second-version checkpoint status | READY | `docs/second-version-submission-status.md` |
| Task-one evidence summarizer | READY | `scripts/summarize_task_one_evidence.py` |
| Task-one second-version matrix runner | READY | `scripts/run_task_one_second_version_matrix.sh` |
| Task-one before/after TAP wrapper | READY | `scripts/run_task_one_before_after_tap_matrix.sh` |
| Task-one current-head long TAP proof | PASS | `scripts/run_task_one_current_head_long_tap_proof.sh`; 2-worker TAP evidence in `/home/kali/qc-evidence/t1-current-head-long-tap-20260814_180823` and 4-worker TAP overcommit evidence in `/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018`; both use 30000 Linux periodic samples, UDP `20/20`, QCZ1 `10/10`, AI `10/10` and tcpdump `88/0` |
| StarryOS bonus evidence note | READY | `docs/starryos-bonus.md` |
| First-version checkpoint status | READY | `docs/first-version-submission-status.md` |
| First-version checkpoint message | READY | `docs/first-version-submission-message.md` |
| Second-version reviewer quickstart | READY | `docs/second-version-reviewer-quickstart.md` |
| Task-one reviewer defense Q&A | READY | `docs/task-one-reviewer-defense-qna.md` |
| Task-one 30-point checklist | READY | `docs/task-one-30-point-checklist.md` |
| Task-two/task-three 50-point checklist | READY | `docs/task-two-three-50-point-checklist.md` |
| StarryOS bonus scorecard | READY | `docs/starryos-bonus-scorecard.md` |
| Stability summary | READY | `results/stability/2026-07-27-stress2-3x/stability-summary.md` |
| Reviewer scorecard | READY | `docs/scorecard-traceability.md` |
| Engineering/innovation 20-point checklist | READY | `docs/engineering-innovation-20-point-checklist.md` |
| Evidence index | READY | `docs/evidence-index.md` |
| Final package plan | READY | `docs/final-package.md` |
| Final package builder | READY; HEAD STABILITY VERIFIED | `scripts/build_final_submission_package.sh`; the manifest includes the 30000-sample task-one long hub/TAP summaries, the 4-worker hub/TAP proofs, exact-head stability summaries, compact physical-board native-Linux summaries plus the external raw-archive hash, StarryOS PR `#2` material, PPT, narration script and optional final video |
| Final package verifier | READY; FINAL VIDEO GATE PENDING | `scripts/verify_final_submission_package.py`, `scripts/verify_demo_video.py` and `scripts/finalize_final_submission.sh` check required files, physical-board documentation and summaries, video/audio metadata, forbidden artifacts, secret patterns, hashes and a fresh ZIP extraction. The no-video second-version package passed; final strict verification waits for the user-narrated video. |
| Current clean-head pre-final package | PASS; VIDEO PENDING | Clean-head dry run with PPTX and narration DOCX includes `79` files and reports `FINAL_PACKAGE_BUILD=PASS`, `FINAL_PACKAGE_VERIFY=PASS` and `PRESENTATION_STRICT_GATE=PASS`. It includes the latest task-three second-metric summary and StarryOS bonus material. The generated `README.txt` records the exact source head; the final ZIP is regenerated only after the narrated video is ready. |
| Verified checkpoint archive | READY; VERIFIED | Current uploadable archive identity is intentionally kept outside git: use the generated package `README.txt` for the exact main head and the sibling external `.zip.sha256` file for the exact ZIP hash. Recent checkpoint archives have passed strict package verification plus fresh-unzip verification. Regenerate once from the final selected head before the 2026-08-24 upload. |
| Final submission message | READY | `docs/final-submission-message.md` |
| Final defense brief | READY | `docs/final-defense-brief-cn.md`; one-page Chinese reviewer path, task evidence map and safe answer wording |
| Core patch review | READY | `docs/core-patch-review.md` |
| Demo video script | READY | `docs/demo-video-script.md` |
| Demo acceptance checklist | READY | `docs/final-demo-acceptance-checklist.md`; final video hard gates, no-go cases and reviewer shortcut |
| Demo video proof | DRAFT VERIFIED; FINAL USER-NARRATED VIDEO PENDING | `docs/final-video-proof.md`; the previous 300-second generated video remains a checked reference but is not the selected final upload. The final metadata and SHA256 will be generated after the user records narration. |
| Chinese video cue card | READY | `docs/final-video-cue-card-cn.md` |
| Demo recording runbook | READY | `docs/final-demo-recording-runbook.md` |
| Demo video hub rehearsal | PASS; TAP VIDEO STILL PREFERRED | `/home/kali/qc-evidence/qc-demo-hub-head-e1a01b82-20260814_094911`, head `e1a01b8263eba471625f26ef5e383db20744a40b`; reports final `result=PASS`, Linux `2` vCPUs, one Linux stress worker, UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI `10/10`, AI e2e mean/max `4984 us / 35679 us`; hub mode has no tcpdump counters |
| Recent PR-head hub rehearsal | PASS; TAP VIDEO STILL PREFERRED | `/home/kali/qc-evidence/qc-demo-hub-latest-e703-20260814_065528`, head `e703ae46f8b6b1a814c0e5051776fc09d8f4022e`; `result=PASS`, `analysis_result=PASS`, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, Linux `2` vCPUs; hub mode has no tcpdump counters |
| Latest long hub runtime matrix | PASS | `/home/kali/qc-evidence/t1-head8984-long-hub-2w-r30000-20260814_173833`, runtime-proof head `8984bd23dbb27b091aaa120020f0ac9eff59226d`; the 2-worker, 30000-sample row reports `TASK_ONE_SECOND_VERSION_MATRIX=PASS`, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, Linux `2` vCPUs, QCZ1 retransmits `0`; hub mode is retained as long-sample trend evidence |
| Latest 4-worker TAP runtime proof | PASS | `/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018`, runtime-proof head `91cb7c0fc00d579d62528a3c967e5efd3cc57836`; the 4-worker, 30000-sample TAP/tcpdump row reports `TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS`, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, RTOS p99/max `1821568 / 31444800 ns`, tcpdump `88/0` |
| Task-one TAP before/after matrix | PASS | `/home/kali/qc-evidence/t1-before-after-tap-fixed-114047`, private PR `#1` runtime source head `2737d1e603b5b0d62cc4d6faf71dbdee33bd75c5`; 0/2-worker before/after rows all report `PASS`, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, Linux `2` vCPUs, QCZ1 retransmits `0`, no missing markers, tcpdump `88/0` |
| Demo video recording | PENDING USER NARRATION | PPT and narration script are ready. After recording, run `scripts/finalize_final_submission.sh`; completion requires `FINAL_VIDEO_VERIFY=PASS`, strict package verification and `FINAL_SUBMISSION_FRESH_UNZIP_VERIFY=PASS`. |
| PR description draft | READY | `docs/pr-description.md` |

## Current PR State

| Item | Status | Link or branch |
| --- | --- | --- |
| Private contest repository | SUBMITTED | `https://github.com/qcl-kernel/tgoskits-redcola` |
| Main contest PR | SUBMITTED | `qcl-kernel/tgoskits-redcola#1`, branch `contest/axvisor-2026`; use the PR page for the moving branch head and use the generated package `README.txt` for the exact archived head. Current evidence docs include the 10000-sample before/after matrix, TAP/tcpdump matrix, task-one core-claim note, task-one reviewer defense Q&A, 4-worker overcommit boundary, 30000-sample hub proof at source head `8984bd23dbb27b091aaa120020f0ac9eff59226d`, 30000-sample 2-worker/4-worker TAP/tcpdump proof at source head `91cb7c0fc00d579d62528a3c967e5efd3cc57836`, and exact-head 3-run stability repeat at source head `746042293ac61bc5cb894c6c470ae76fdc02674a` |
| StarryOS bonus PR | SUBMITTED; PRESERVED AS SEPARATE SCOPE | `qcl-kernel/tgoskits-redcola#2`, branch `contest/starry-redcola-ai-bonus-clean-20260731`, head `2ac656341a63facdc3030fa3fd99bd20de156bef`; latest-`dev` runtime evidence is included separately in the final package. |
| Core vTimer PR | MERGED | `rcore-os/tgoskits#1770`, upstream commit `024ecca10a4240a84b2c24bed2dc2361a6043d3e` |
| Historical public artifact PR | RECORDED | `rcore-os/tgoskits#1703`, superseded for staged contest review by the private repository above |
| Final latest-dev sync | VALIDATED LOCALLY | Main submission rebuilt cleanly on official `dev` `8e39cbd586a4a34ab9f522931ca4b1e7523709c7`; targeted AxVM test `1/1`, full host-test `296/296`, static gates and full QEMU runtime pass. StarryOS remains a separate scope-limited bonus PR. |
| Final latest-dev dual-guest runtime | PASS | `/home/kali/qc-evidence/final-demo-latestdev8e39-head17ee-20260821`; Linux `2` vCPUs, CPU0 periodic probe, two CPU1 stress workers, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, final `result=PASS`; compact record in `results/final-demo-latestdev8e39-head17ee-summary.md`. |
| Latest-dev dual-guest runtime | PASS; ARCHIVED WITH FINAL SUBMISSION | `/home/kali/qc-evidence/final-demo-latestdev0340-hub-20260821`; Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, final `result=PASS`; AI end-to-end mean/max `7003/11063 us`. The exact submitted PR head is recorded by the generated package `README.txt`. |
| Latest-dev long pressure | PASS | `/home/kali/qc-evidence/t1-latestdev0340-long-hub-r30000-20260821`; Linux 30,000 samples at 1 ms, periodic probe on vCPU 0, two stress workers on vCPU 1, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, final `result=PASS`. |
| AxVM host-test suite | PASS | PCI `interrupt-map` targeted test `1/1`; full `cargo test -p axvm --features host-test --lib` suite `296/296`; compact record in `results/axvm-host-test-latestdev0340-summary.txt`. |
| StarryOS latest-dev QEMU | PASS; PR #2 PRESERVED | `/home/kali/qc-evidence/starry-latestdev0340-20260821`; `REDCOLA_STARRY_QCZ1_PARITY_PASS`, `REDCOLA_STARRY_AI_CONTROL_PASS`, `REDCOLA_STARRY_AI_DONE`, `REDCOLA_STARRY_LATESTDEV0340_QEMU=PASS`. PR `#2` remains an independently reviewable scope; the latest-`dev` compatibility record is packaged as supplemental evidence. |
| Latest-dev CPU-isolated matrix | PASS | `/home/kali/qc-evidence/t1-latestdev220-isolated-p10ms-20260821`; Linux periodic probe on guest CPU 0, two stress workers on guest CPU 1, 0/2-worker rows each use 3000 samples at 10 ms and retain UDP `20/20`, QCZ1 `10/10`, AI `10/10`; archive SHA256 `17f300e8d14a445fda0d1b727dd0c5a332716576683ac61006bde5274bad1163` |
| Latest-dev isolated 3-run stability | PASS | `results/task-one-latestdev-isolated-p10ms-stability-3x-summary.md`; 3/3 boots, 9000/9000 samples, UDP 60/60, QCZ1 30/30, AI 30/30, retransmits 0; archive SHA256 `e5dc492f90427a12f3e0d985e87136c13db89e316d77e1abdbaad03413ee63b8` |

## Contest Submission Milestones

| Date | Required material | Redcola status |
| --- | --- | --- |
| 2026-08-14 | First version: code, documents and tests | READY in private PRs `#1` and `#2` |
| 2026-08-21 | Second version: strengthened code, documents and tests | READY after TAP/tcpdump before/after matrix and current-head 4-worker TAP overcommit proof; next polish is concise reviewer explanation and final-video rehearsal |
| 2026-08-24 | Final version: code, documents, tests and demo video | Record final video using `docs/final-demo-recording-runbook.md` plus `docs/demo-video-script.md`, refresh SHA256 evidence links, and package final evidence summaries |

The `qcl-kernel/tgoskits-redcola` repository is a private contest-review mirror.
Its GitHub Actions may be unavailable if organization-level hosted-runner
billing or spending limits block Actions startup. In that case, staged review
should use the submitted branches, PR diffs, reproduction scripts and recorded
local validation evidence rather than the mirror repository Actions status.

## Award-Oriented Remaining Gates

The first-version submission is complete enough for the 2026-08-14 checkpoint.
The remaining work is focused on raising the score rather than fixing a missing
first-version upload.

| Area | Next scoring action | Gate |
| --- | --- | --- |
| Task one realtime | Keep the completed TAP/tcpdump before/after rows and explain them clearly in the final video. | `TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS`, Linux `2` vCPUs, RTOS periodic stats, UDP/QCZ1/AI PASS, tcpdump captured/dropped `88/0` in every TAP row. |
| Task one second-version stretch | Completed current-head long TAP wrapper to combine long pressure, overcommit pressure and tcpdump proof. | `TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS`, Linux `2` vCPUs, 30000 Linux periodic samples, UDP/QCZ1/AI PASS and tcpdump captured/dropped `88/0` for both 2-worker and 4-worker TAP rows. |
| Task one CPU isolation | Keep the new guest-affinity mechanism and same-head 10 ms matrix as an additional deterministic-placement proof. | `TASK_ONE_SECOND_VERSION_MATRIX=PASS`; probe CPU 0, stress CPU 1, 0/2-worker rows both retain the full communication and AI chain. |
| Task two communication | Keep protocol and network evidence stable; avoid changing the working QCZ1 path unless a reviewer asks. | Plain UDP `20/20`, QCZ1 `10/10`, status/error path validated, duplicate ACK path covered. |
| Task three AI control | Use the final video to show the full loop from AI input through RTOS state return. | `QC_AI_CONTROL_RESULT=PASS`, AI-vs-manual metric comparison, end-to-end latency table. |
| StarryOS bonus | Keep the StarryOS PR separate and reproducible. | `REDCOLA_STARRY_QCZ1_PARITY_PASS`, `REDCOLA_STARRY_AI_CONTROL_PASS` and `REDCOLA_STARRY_AI_DONE` in PR `#2`. |
| Final packaging | Produce a small final package with links, docs, evidence hashes and video. | No generated images, raw logs, credentials or local caches included. |

## Artifact PR Preflight

Run from the repository root:

```bash
REPO=/path/to/tgoskits
cd "${REPO}/os/axvisor/contest/quancheng2026"
find . -type d -name __pycache__ -prune -exec rm -rf {} +
cache_dir=/tmp/qc_pycompile_cache_$$
PYTHONPYCACHEPREFIX=$cache_dir python3 -m py_compile scripts/*.py linux/*.py
rm -rf $cache_dir
python3 scripts/qc_qcz1_guest_status_negative_selftest.py
python3 linux/qc_reliable_udp_client.py --selftest-status-validation
bash -n scripts/*.sh linux/*.sh
find . \( -name '*.img' -o -name '*.qcow2' -o -name '*.iso' -o -name '*.elf' -o -name '*.o' -o -name '*.bin' -o -name '__pycache__' -o -name '*.pyc' -o -name '*.log' -o -name '*.tar.gz' \) -print | sort
cd "${REPO}"
git diff --check upstream/dev...HEAD
git diff --name-only upstream/dev...HEAD | \
  grep -Ev '^os/axvisor/contest/quancheng2026/|^virtualization/axvm/src/boot/fdt/core/(mod|parser)\.rs$' || true
```

Expected artifact PR result:

```text
changed paths: 110
AxVM PCI parser paths: 2
contest paths: 108
outside selected final scope: 0
forbidden generated artifacts: 0
```

Latest non-privileged static preflight:

```text
2026-08-14 Windows local Python syntax check: QC_LOCAL_PY_SYNTAX=PASS
2026-08-14 Kali 64-bit static preflight: QC_STATIC_PREFLIGHT=PASS
2026-08-14 Kali/Linux final package dry run with StarryOS material: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS
2026-08-14 Kali/Linux final package dry run at 69c25e018: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, FIRST_VERSION_MESSAGE_INCLUDED=YES
2026-08-14 Kali/Linux final package dry run at 63c787326 with StarryOS material: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, files=36
2026-08-14 Kali/Linux final package dry run at bc9d6348e with StarryOS material: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, files=36, SHA256SUMS=b456cae7ebdcb33286fe948bb3d752e79f70ef9ab5ec89cef72a0c089cca879d
2026-08-14 Kali/Linux final package dry run at f897822aa with StarryOS material: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, files=33, SHA256SUMS=0db780fdc9950929307b3e18b1393b22285c0890fb479d76964b2a18763445f4
2026-08-14 Kali/Linux final package dry run at 9f3e9f42c with StarryOS material and latest demo rehearsal evidence: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, files=36, SHA256SUMS=696bc2efbb9eeeab23ccd923fd43c570b972e14d8e8af2f4b63a7d6f8547d7bb
2026-08-14 Kali/Linux final package dry run at 062ed8e4c with StarryOS material, current task-one evidence notes and latest demo rehearsal evidence: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, files=36, SHA256SUMS=bf4191734074f17f9d7fa365b0b108bdc3b2486d7be290e4f56246fc6f98dee4
2026-08-14 Kali/Linux final package dry run at fae6bcf49 with StarryOS material, current task-one evidence notes, latest demo rehearsal evidence and tightened video script: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, files=36, SHA256SUMS=302862f789cb955caa68b34cd09aed10adec896d4570db817e52a69e7b1272b7
2026-08-14 Kali/Linux final package dry run at c65bc73c6 with StarryOS QCZ1 parity material and current demo rehearsal evidence: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, files=34, SHA256SUMS=cee126ad6646252e3766d29043cc0949590002e9b1db4c9258b3f579af42f7f7
2026-08-15 Windows verified checkpoint archive after the second-version message and defense-note refresh: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, unzipped FINAL_PACKAGE_VERIFY=PASS, files=57, archive=`redcola-current-head-with-video-20260815-8ba0a9f3-v1.zip`, SHA256=`7dba8d140ee03db828ccde6514b45dd387fd26d0e7eabbf03c3182538667501e`. The uploadable archive hash is kept beside the ZIP in the external `.zip.sha256` file. Regenerate once more only from the final selected head before the 2026-08-24 upload.
2026-08-15 refreshed checkpoint archive after adding the StarryOS scorecard to the package manifest: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, fresh-unzip verify=PASS, files=59, main source head=`498218c726d90e766f9c6802677964c152c46f24`, StarryOS source head=`e2a0493ada72fb58eb413bbe46253d2eaa07dc18`, archive=`redcola-current-head-with-video-20260815-498218c7-v1.zip`, SHA256=`84755e3d3e2e784c4802b13aa967512cc87331b85e791282e66ef277498c1a30`. The uploadable archive hash is kept beside the ZIP in the external `.zip.sha256` file.
2026-08-15 refreshed checkpoint archive after adding the task-one reviewer defense Q&A: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, fresh-unzip verify=PASS, files=60, main source head=`ac4fb2e9a09fd41b209620f999862565b8d83242`, StarryOS source head=`e2a0493ada72fb58eb413bbe46253d2eaa07dc18`, archive=`redcola-current-head-with-video-20260815-ac4fb2e9-v1.zip`, SHA256=`8ac88200eb510b7c96d676864680001e73e0e9294483abe67e5454c08cbbe063`. The uploadable archive hash is kept beside the ZIP in the external `.zip.sha256` file.
2026-08-15 refreshed checkpoint archive after adding the StarryOS reviewer quickstart to the package manifest: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, fresh-unzip verify=PASS, files=63, main source head=`5b614af572296fc1e09f5b26917bdfd8d544cbf9`, StarryOS source head=`c8ec750378c5783b9c32518395dc3fbd1ae2449e`, archive=`redcola-current-head-with-video-20260815-5b614af5-v1.zip`, SHA256=`fe468e37439d4f45ab5fc8f078fa8adde484887479c8911b76e7ca3ef2f4b8a2`. The uploadable archive hash is kept beside the ZIP in the external `.zip.sha256` file.
2026-08-15 refreshed checkpoint archive after syncing the StarryOS bonus review head and latest reviewer-facing documentation: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, fresh-unzip verify=PASS, files=63, main source head=`dca3bfdd58b3f1df14258c622cb824325ca89946`, StarryOS source head=`359a2746d94f9128ea2843109e4eb6b8bf53eda7`, archive=`redcola-current-head-with-video-20260815-dca3bfdd-v1.zip`, SHA256=`8710e9bbfad862201bd89e02d03b928a94f99f7b816d0eaece102be80c72aacd`. The uploadable archive hash is kept beside the ZIP in the external `.zip.sha256` file.
```

The Kali static preflight covers Python compilation, QCZ1 guest status negative
selftest, Python status-validation selftest and `bash -n` over the contest
shell scripts. It does not require TAP devices or tcpdump privileges.

The final-package dry-run hashes above are recorded proof points for the listed
source heads. The PR branch may advance afterward when documentation records a
new proof point. For the final 2026-08-24 upload, regenerate the package once
from the final selected head and use that run's `SHA256SUMS.txt` as the
submission hash source.

## StarryOS Bonus PR Candidate

The StarryOS bonus branch is intentionally separate from this artifact PR. It
adds only:

```text
apps/starry/qemu/redcola-ai-control/
```

It has a StarryOS AArch64 QEMU PASS log with a fixed-point MLP policy:

```text
CURRENT_BRANCH_HEAD=use PR #2 for the latest moving head
LATEST_2026_08_18_SYNCED_HEAD=2ac656341a63facdc3030fa3fd99bd20de156bef
EVDIR=/home/kali/qc-evidence/starry-qemu-redcola-qcz1-parity-head-4cbd22ccb837-20260814_103336
RUNTIME_EVIDENCE_HEAD=4cbd22ccb837
QEMU_MACHINE=virt,gic-version=3
LOG_SHA256=9e73e441e1028fdffdd4a4bdcb8fc64497e9cf505755c94ddf1a1e1956f54ddf
SUMMARY_SHA256=c81fd027897e0fdef72e36864791d1e99391c2d2681824820ff95fcf67befa33
REDCOLA_STARRY_QCZ1_FRAME magic=QCZ1 version=1 type=CONTROL_SET header_len=28 payload_len=12 seq=9001 sample_id=1 checksum=0x1ac5c2ff frame_len=40
REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli=930 ai_score_milli=1000 sample_id=1
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0 mean_infer_us=82
REDCOLA_STARRY_AI_DONE
RESULT=PASS
```

The current StarryOS branch head may be newer than `RUNTIME_EVIDENCE_HEAD`
because later commits only refresh validation notes. The runtime source changes
needed for the current AArch64 run are the explicit `virt,gic-version=3` QEMU
machine argument and the StarryOS-side QCZ1 `CONTROL_SET` frame parity marker
in PR `#2`.

Reviewer-facing scope and scoring notes are in `docs/starryos-bonus.md`.
The StarryOS PR itself also contains
`apps/starry/qemu/redcola-ai-control/VALIDATION.md`.

## Core Patch Tracking

The first core PR is `rcore-os/tgoskits#1770`. It covers AArch64 physical timer
virtualization and cross-CPU timer cancellation. Remaining optional core work,
if still useful after review, should stay in follow-up PRs rather than this
artifact PR.

The review reasoning, SHA256 values and validation commands are in
`docs/core-patch-review.md`.

## Demo Video

Record the final video with `docs/final-demo-recording-runbook.md` and
`docs/demo-video-script.md`.

Capture these markers:

```text
result=PASS
plain_udp=20/20
qcz1=10/10
ai_control=10/10
QC_RTOS_PERIODIC_RESULT=PASS
QC_DUAL_GUEST_LINUX_INIT=PASS
tcpdump kernel drops=0
```

## Final Platform Submission

Submit or link:

- PR branch and commit hash.
- `docs/design.md`.
- `docs/test-report.md`.
- `docs/reproduce.md`.
- `docs/scorecard-traceability.md`.
- `docs/evidence-index.md`.
- `docs/final-package.md`.
- `docs/final-submission-message.md`.
- Demo video.
- Latest source/documentation package SHA256.
