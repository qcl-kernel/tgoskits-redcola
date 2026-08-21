# Final Package Plan

This note defines the redcola final-submission package for the 2026-08-24
Quancheng Lab AxVisor contest deadline. It is intentionally limited to source,
documents, tests, links and evidence hashes; large runtime images and raw
capture files stay outside git.

## Package Entry Points

| Item | Required in final package | Source of truth |
| --- | --- | --- |
| Private repository | Yes | `https://github.com/qcl-kernel/tgoskits-redcola` |
| Main AxVisor PR | Yes | `qcl-kernel/tgoskits-redcola#1` |
| StarryOS bonus PR | Yes | `qcl-kernel/tgoskits-redcola#2` |
| Main source path | Yes | `os/axvisor/contest/quancheng2026/` |
| StarryOS bonus source path | Yes | `apps/starry/qemu/redcola-ai-control/` in PR `#2` |
| Design document | Yes | `docs/design.md` |
| Test document | Yes | `docs/test-report.md` |
| Reproduction guide | Yes | `docs/reproduce.md` |
| Evidence index | Yes | `docs/evidence-index.md` |
| Scorecard mapping | Yes | `docs/scorecard-traceability.md` |
| Submission message | Yes | `docs/final-submission-message.md` |
| Chinese final defense brief | Yes | `docs/final-defense-brief-cn.md` |
| Demo video | Yes for final | Recorded from `docs/demo-video-script.md` |
| Final presentation | Yes | `presentation/redcola-axvisor-demo.pptx` |
| Narration script | Yes | `presentation/redcola-axvisor-narration.docx` |
| Demo acceptance checklist | Yes | `docs/final-demo-acceptance-checklist.md` |
| Demo video proof | Yes | `docs/final-video-proof.md` |
| Chinese video cue card | Yes | `docs/final-video-cue-card-cn.md` |
| Demo recording runbook | Yes | `docs/final-demo-recording-runbook.md` |

## Verified Package Proof Points

The current first-checkpoint archive is generated from the selected private PR
heads by `scripts/build_final_submission_package.sh`. The package `README.txt`
records the exact main branch head used for that build, and the sibling
`.zip.sha256` file is the authoritative archive hash. The hash is intentionally
not hard-coded here because any later documentation refresh changes the package
contents and therefore the archive digest.

The previous verified Windows package proof point after adding the current-head
`30000`-sample TAP/tcpdump row and the 4-worker hub overcommit proof, before
the later 4-worker TAP/tcpdump proof, reports:

```text
Main PR #1 source head: 43509bf19939faf5d64ff82d96625211f6164bae
StarryOS PR #2 source head: e3d8bbf8d9dc6cf7f512017092fb3fdb0c4857f2
ARCHIVE=redcola-current-head-with-video-20260814-43509bf1-v2.zip
ARCHIVE_SHA256=188302d51d744cbd71ffd16351e4f6676d2d65eadc821f423180fe6dcbd79857
FINAL_PACKAGE_VERIFY_FILE_COUNT=52
FINAL_PACKAGE_VERIFY=PASS
UNZIPPED_FINAL_PACKAGE_VERIFY=PASS
Included: video, StarryOS bonus material, long hub summary,
long TAP/tcpdump summary and 4-worker hub proof
```

The refreshed Windows package proof point after the 4-worker
TAP/tcpdump proof reports:

```text
Main PR #1 source head: b668ba83a69e1f1dbf40892267feac6038caf4bb
StarryOS PR #2 source head: e3d8bbf8d9dc6cf7f512017092fb3fdb0c4857f2
ARCHIVE=redcola-current-head-with-video-20260814-b668ba83a-v2.zip
ARCHIVE_SHA256=405dceb29de54ae4ac9a1243ae056bb30caaddcd769e76e71d2260b168abc883
FINAL_PACKAGE_VERIFY_FILE_COUNT=55
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY=PASS
UNZIPPED_FINAL_PACKAGE_VERIFY=PASS
Included: video, StarryOS bonus material, latest video scripts,
long hub/TAP summaries, 4-worker hub proof and 4-worker TAP/tcpdump proof
```

A verified package proof point after the second-version message and
defense-note refresh reports:

```text
Main PR #1 source head: 8ba0a9f3c9a8e9c698cacf99cc227215db9ec46c
StarryOS PR #2 source head: e3d8bbf8d9dc6cf7f512017092fb3fdb0c4857f2
ARCHIVE=redcola-current-head-with-video-20260815-8ba0a9f3-v1.zip
ARCHIVE_SHA256=7dba8d140ee03db828ccde6514b45dd387fd26d0e7eabbf03c3182538667501e
FINAL_PACKAGE_VERIFY_FILE_COUNT=57
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY=PASS
UNZIPPED_FINAL_PACKAGE_VERIFY=PASS
Included: video, StarryOS bonus material, long hub/TAP summaries, 4-worker hub proof, 4-worker TAP/tcpdump proof, exact-head 3-run stability repeat summaries and refreshed second-version message/defense notes
```

A refreshed package proof point after adding the StarryOS scorecard to the
package manifest reports:

```text
Main PR #1 source head: 498218c726d90e766f9c6802677964c152c46f24
StarryOS PR #2 source head: e2a0493ada72fb58eb413bbe46253d2eaa07dc18
ARCHIVE=redcola-current-head-with-video-20260815-498218c7-v1.zip
ARCHIVE_SHA256=84755e3d3e2e784c4802b13aa967512cc87331b85e791282e66ef277498c1a30
FINAL_PACKAGE_VERIFY_FILE_COUNT=59
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY=PASS
UNZIPPED_FINAL_PACKAGE_VERIFY=PASS
Included: video, StarryOS bonus material, starryos-bonus/SCORECARD.md, long hub/TAP summaries, 4-worker hub proof, 4-worker TAP/tcpdump proof and exact-head 3-run stability repeat summaries
```

One verified package proof point after adding the task-one reviewer defense Q&A
reports:

```text
Main PR #1 source head: ac4fb2e9a09fd41b209620f999862565b8d83242
StarryOS PR #2 source head: e2a0493ada72fb58eb413bbe46253d2eaa07dc18
ARCHIVE=redcola-current-head-with-video-20260815-ac4fb2e9-v1.zip
ARCHIVE_SHA256=8ac88200eb510b7c96d676864680001e73e0e9294483abe67e5454c08cbbe063
FINAL_PACKAGE_VERIFY_FILE_COUNT=60
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY=PASS
UNZIPPED_FINAL_PACKAGE_VERIFY=PASS
Included: video, StarryOS bonus material, starryos-bonus/SCORECARD.md, task-one reviewer defense Q&A, long hub/TAP summaries, 4-worker hub proof, 4-worker TAP/tcpdump proof and exact-head 3-run stability repeat summaries
```

The previous verified staged Windows package proof point after adding the final defense
brief, demo acceptance checklist and video proof reports:

```text
Main PR #1 source head: ecd47ee25e8df7aa078579102131f4ab0978fe4c
StarryOS PR #2 source head: e2a0493ada72fb58eb413bbe46253d2eaa07dc18
ARCHIVE=redcola-current-head-with-video-20260815-ecd47ee2-v1.zip
ARCHIVE_SHA256=565f4cbf67af01fd4a5a4d4429ac721e2d57f3fff245de1ab4984a4e46adbdb2
FINAL_PACKAGE_VERIFY_FILE_COUNT=62
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY=PASS
UNZIPPED_FINAL_PACKAGE_VERIFY=PASS
VIDEO=video/redcola-axvisor-demo.mp4, duration=300 seconds
Included: video, StarryOS bonus material, starryos-bonus/SCORECARD.md,
task-one reviewer defense Q&A, final defense brief, demo acceptance checklist,
video proof, long hub/TAP summaries, 4-worker hub proof, 4-worker TAP/tcpdump
proof and exact-head 3-run stability repeat summaries
```

The refreshed Windows package proof point after adding the StarryOS bonus
reviewer quickstart reports:

```text
Main PR #1 source head: 5b614af572296fc1e09f5b26917bdfd8d544cbf9
StarryOS PR #2 source head: c8ec750378c5783b9c32518395dc3fbd1ae2449e
ARCHIVE=redcola-current-head-with-video-20260815-5b614af5-v1.zip
ARCHIVE_SHA256=fe468e37439d4f45ab5fc8f078fa8adde484887479c8911b76e7ca3ef2f4b8a2
FINAL_PACKAGE_VERIFY_FILE_COUNT=63
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY=PASS
UNZIPPED_FINAL_PACKAGE_VERIFY=PASS
Included: video, StarryOS bonus material, starryos-bonus/REVIEWER-QUICKSTART.md,
starryos-bonus/SCORECARD.md, task-one reviewer defense Q&A, final defense brief,
demo acceptance checklist, video proof, long hub/TAP summaries, 4-worker hub
proof, 4-worker TAP/tcpdump proof and exact-head 3-run stability repeat summaries
```

The refreshed Windows package proof point after syncing the StarryOS bonus
review head and the latest reviewer-facing documentation reports:

```text
Main PR #1 source head: dca3bfdd58b3f1df14258c622cb824325ca89946
StarryOS PR #2 source head: 359a2746d94f9128ea2843109e4eb6b8bf53eda7
ARCHIVE=redcola-current-head-with-video-20260815-dca3bfdd-v1.zip
ARCHIVE_SHA256=8710e9bbfad862201bd89e02d03b928a94f99f7b816d0eaece102be80c72aacd
FINAL_PACKAGE_VERIFY_FILE_COUNT=63
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY=PASS
UNZIPPED_FINAL_PACKAGE_VERIFY=PASS
Included: video, StarryOS bonus material, starryos-bonus/REVIEWER-QUICKSTART.md,
starryos-bonus/SCORECARD.md, task-one reviewer defense Q&A, final defense brief,
demo acceptance checklist, video proof, long hub/TAP summaries, 4-worker hub
proof, 4-worker TAP/tcpdump proof and exact-head 3-run stability repeat summaries
```

The latest package manifest includes the 4-worker TAP/tcpdump proof files, the
exact-head stability repeat summaries, the recorded a9ce long-pressure proof,
the task-one reviewer defense Q&A, the StarryOS reviewer quickstart and the
final defense/video proof documents:

```text
evidence-summaries/task-one-current-head-long-tap4-r30000-summary.csv
evidence-summaries/task-one-current-head-long-tap4-r30000-summary.md
evidence-summaries/task-one-current-head-long-tap4-r30000-proof.txt
evidence-summaries/task-one-head746-2w-hub-stability-r30000-summary.csv
evidence-summaries/task-one-head746-2w-hub-stability-r30000-summary.md
evidence-summaries/task-one-head-a9ce-long-hub-r30000-summary.csv
evidence-summaries/task-one-head-a9ce-long-hub-r30000-summary.md
evidence-summaries/task-one-head-a9ce-long-hub-r30000-proof.txt
docs/final-defense-brief-cn.md
docs/final-demo-acceptance-checklist.md
docs/final-video-proof.md
starryos-bonus/REVIEWER-QUICKSTART.md
starryos-bonus/SCORECARD.md
video/redcola-axvisor-demo.mp4
```

The archive is also extracted into a fresh verification directory and checked
again with `--require-video --require-starry`, so the verification covers the
actual uploadable ZIP contents rather than only the source package directory.
For any later package rebuild, the generated package `README.txt` and sibling
`.zip.sha256` file are the authoritative identity for that exact ZIP; the
proof point above is retained as a known-good checkpoint, not as a hard-coded
future final archive.
Later commits may record this proof point or clarify review text. For the
final 2026-08-24 upload, regenerate the package once from the selected final
head and use the generated package `README.txt`, `SHA256SUMS.txt` and sibling
`.zip.sha256` file as the authoritative proof for that exact final archive.

## Recommended Final Upload Layout

```text
redcola-final-submission/
  README.txt
  PR-LINKS.txt
  SUBMISSION-MESSAGE.txt
  SHA256SUMS.txt
  docs/
    design.md
    test-report.md
    reproduce.md
    evidence-index.md
    scorecard-traceability.md
    final-defense-brief-cn.md
    final-demo-acceptance-checklist.md
    final-video-proof.md
    engineering-innovation-20-point-checklist.md
    first-version-submission-status.md
    first-version-submission-message.md
    second-version-reviewer-quickstart.md
    second-version-submission-status.md
    second-version-submission-message.md
    realtime-evaluation.md
    task-one-30-point-checklist.md
    task-one-second-version-plan.md
    task-one-score-summary.md
    task-two-three-50-point-checklist.md
    task-two-three-score-summary.md
    protocol.md
    network-topology.md
    ai-control-evaluation.md
    starryos-bonus.md
    starryos-bonus-scorecard.md
    core-patch-review.md
    final-submission-checklist.md
    final-submission-message.md
    demo-video-script.md
    final-video-cue-card-cn.md
    final-demo-recording-runbook.md
  video/
    redcola-axvisor-demo.mp4
  starryos-bonus/
    README.md
    VALIDATION.md
    REVIEWER-QUICKSTART.md
    SCORECARD.md
  evidence-summaries/
    task-one-second-version-summary.csv
    task-one-second-version-summary.md
    task-one-before-after-hub-summary.csv
    task-one-before-after-hub-summary.md
    task-one-before-after-tap-summary.csv
    task-one-before-after-tap-summary.md
    task-one-current-head-long-hub-r30000-summary.csv
    task-one-current-head-long-hub-r30000-summary.md
    task-one-current-head-long-hub4-r30000-summary.csv
    task-one-current-head-long-hub4-r30000-summary.md
    task-one-current-head-long-hub4-r30000-proof.txt
    task-one-current-head-long-tap-r30000-summary.csv
    task-one-current-head-long-tap-r30000-summary.md
    task-one-current-head-long-tap4-r30000-summary.csv
    task-one-current-head-long-tap4-r30000-summary.md
    task-one-current-head-long-tap4-r30000-proof.txt
    task-one-head-a9ce-long-hub-r30000-summary.csv
    task-one-head-a9ce-long-hub-r30000-summary.md
    task-one-head-a9ce-long-hub-r30000-proof.txt
    task-one-head746-2w-hub-stability-r30000-summary.csv
    task-one-head746-2w-hub-stability-r30000-summary.md
    realtime-comparison.csv
    stability-summary.md
    demo-hub-rehearsal-analysis.md
    demo-hub-rehearsal-analysis.json
```

The final upload can be a platform form submission, a compressed archive, or a
set of links, depending on organizer instructions. The private repository
remains the code source of truth.

## Include

- Source code and scripts under `os/axvisor/contest/quancheng2026/`.
- StarryOS bonus source under the separate private PR `#2`.
- StarryOS bonus README and validation note from PR `#2`.
- StarryOS bonus reviewer quickstart from PR `#2`.
- StarryOS bonus scorecard boundary note.
- Design, test, reproduction, protocol, topology, AI and realtime documents.
- Engineering completeness and system innovation scorecard.
- First-version and second-version checkpoint status notes.
- Second-version reviewer quickstart for the compact review path.
- Core patch review and task-one before/after plan.
- Task-one 30-point reviewer checklist.
- Task-two/task-three 50-point reviewer checklist.
- Final demo video script and operational recording runbook.
- Chinese final-video cue card for the live recording flow.
- Small CSV/Markdown summaries.
- Completed TAP/tcpdump before/after summary table.
- Current-head 2-worker and 4-worker long TAP/tcpdump proof summaries.
- Recorded `a9ceb7dc` 2-worker long hub proof summary.
- Final-video hub rehearsal summary, clearly labelled as `net_mode=hub`.
- SHA-256 values for evidence archives and the final user-narrated video.
- PPT and narration script used to record the final video.
- User-narrated demo video recorded from the final script.

## Exclude

- QEMU disk images, kernel images, rootfs images and generated firmware blobs.
- Raw `.pcap`, raw QEMU logs and large evidence tarballs.
- Local build directories such as `target/`, `build/`, `__pycache__/` and
  `.venv/`.
- SSH keys, GitHub tokens, passwords or sudo credentials.
- Temporary Windows or Kali workspace bundles.

## Final Acceptance Checklist

Before final submission, verify:

1. Main PR `#1` is open and points to the latest `contest/axvisor-2026` head.
2. StarryOS bonus PR `#2` is open and its scope is only the StarryOS demo path.
3. `docs/test-report.md` contains the strongest task-one before/after and
   stress evidence available by 2026-08-21.
4. TAP/tcpdump before/after evidence is included through
   `task-one-before-after-tap-summary.csv` and
   `task-one-before-after-tap-summary.md`.
5. Current-head long TAP/tcpdump evidence is included through the 2-worker and
   4-worker `task-one-current-head-long-tap*-r30000-*` summaries.
6. User-narrated demo video follows `docs/final-demo-recording-runbook.md`,
   shows the required PASS markers, and passes `scripts/verify_demo_video.py`.
7. `SHA256SUMS.txt` contains hashes for the final video, PPT, narration script
   and any evidence summary/archive files submitted outside git.
8. No generated images, raw logs, credentials or local caches are included.

## Package Builder

The package layout above can be generated from the repository root with:

```bash
cd os/axvisor/contest/quancheng2026
./scripts/build_final_submission_package.sh \
  --out /tmp/redcola-final-package \
  --evidence-dir /home/kali/qc-evidence/demo-hub-rehearsal-w1-20260814_042902 \
  --starry-dir /path/to/apps/starry/qemu/redcola-ai-control \
  --video /path/to/redcola-axvisor-demo.mp4
```

For a dry run before the final video is recorded, omit `--video`. The script
will leave `video/README.txt` in the package as an explicit reminder. The
script copies only small documents and summaries, writes `SHA256SUMS.txt`, and
excludes raw logs, pcaps, images, kernels, caches and credentials.

Verify the generated package with:

```bash
python3 scripts/verify_final_submission_package.py \
  /tmp/redcola-final-package/redcola-final-submission \
  --require-starry
```

For the final 2026-08-24 upload, add `--require-video` after
`redcola-axvisor-demo.mp4` is copied into the package.

The dry-run records below are proof points for the exact source heads listed in
each block. They are not meant to be chased after every documentation-only
commit that records a new proof point. For the final 2026-08-24 upload,
regenerate the package once from the selected final branch head and use that
run's `SHA256SUMS.txt` as the authoritative submission hash source.

Latest dry-run check:

```text
FINAL_PACKAGE_DIR=tmp/redcola-final-package-dryrun/redcola-final-submission
FINAL_PACKAGE_FILE_COUNT=31
FINAL_PACKAGE_BUILD=PASS

FINAL_PACKAGE_DIR=tmp/redcola-final-package-with-starry-dryrun/redcola-final-submission
FINAL_PACKAGE_FILE_COUNT=32
FINAL_PACKAGE_BUILD=PASS
StarryOS bonus README.md and VALIDATION.md included

FINAL_PACKAGE_VERIFY_DIR=tmp/redcola-final-package-verify-dryrun/redcola-final-submission
FINAL_PACKAGE_VERIFY_FILE_COUNT=32
FINAL_PACKAGE_VERIFY=PASS

Kali/Linux clean-worktree dry run with the StarryOS bonus PR material:
AXVISOR_HEAD=4e0ab747eea0e9bca1bd3d756429bf59657d42fb
STARRY_HEAD=3d9c0f2825b3ccc678542b9f6459872ce18faff5
FINAL_PACKAGE_DIR=/tmp/redcola-final-package-linux-dryrun-with-starry/redcola-final-submission
FINAL_PACKAGE_FILE_COUNT=35
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_DIR=/tmp/redcola-final-package-linux-dryrun-with-starry/redcola-final-submission
FINAL_PACKAGE_VERIFY_FILE_COUNT=35
FINAL_PACKAGE_VERIFY=PASS

Kali/Linux clean-worktree dry run after adding the first-version submission
message to the package manifest:
AXVISOR_HEAD=69c25e0183548691bfbd6f0e3144b9cd58522695
FINAL_PACKAGE_DIR=/tmp/redcola-final-package-linux-dryrun-current/redcola-final-submission
FINAL_PACKAGE_FILE_COUNT=35
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_DIR=/tmp/redcola-final-package-linux-dryrun-current/redcola-final-submission
FINAL_PACKAGE_VERIFY_FILE_COUNT=35
FINAL_PACKAGE_VERIFY=PASS
FIRST_VERSION_MESSAGE_INCLUDED=YES

Kali/Linux clean-worktree dry run after the latest realtime evidence refresh:
AXVISOR_HEAD=f897822aab4b22bfc3d038c1f92564be1cfd6206
STARRY_HEAD=3d9c0f2825b3ccc678542b9f6459872ce18faff5
FINAL_PACKAGE_DIR=/tmp/redcola-final-package-f897-20260814_080421/redcola-final-submission
FINAL_PACKAGE_FILE_COUNT=33
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_DIR=/tmp/redcola-final-package-f897-20260814_080421/redcola-final-submission
FINAL_PACKAGE_VERIFY_FILE_COUNT=33
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS=0db780fdc9950929307b3e18b1393b22285c0890fb479d76964b2a18763445f4

Kali/Linux clean-worktree dry run after the latest demo rehearsal evidence:
AXVISOR_HEAD=9f3e9f42c27ae3faf01a7d293ecdca9d1874b76e
STARRY_HEAD=3d9c0f2825b3ccc678542b9f6459872ce18faff5
EVIDENCE_DIR=/home/kali/qc-evidence/qc-demo-hub-head-d9f8fa3c2-20260814_081925
FINAL_PACKAGE_DIR=/tmp/redcola-final-package-9f3e9f42c-20260814_082521/redcola-final-submission
FINAL_PACKAGE_FILE_COUNT=36
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_DIR=/tmp/redcola-final-package-9f3e9f42c-20260814_082521/redcola-final-submission
FINAL_PACKAGE_VERIFY_FILE_COUNT=36
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS=696bc2efbb9eeeab23ccd923fd43c570b972e14d8e8af2f4b63a7d6f8547d7bb

Kali/Linux clean-worktree dry run after the current task-one evidence refresh:
AXVISOR_HEAD=062ed8e4c71c700091d124c383a0683248f72869
STARRY_HEAD=c611704ea80a1752d63afe0f0dccf058293928c2
EVIDENCE_DIR=/home/kali/qc-evidence/qc-demo-hub-head-d9f8fa3c2-20260814_081925
FINAL_PACKAGE_DIR=/tmp/redcola-final-dryrun-062ed8e4c-093037/redcola-final-submission
FINAL_PACKAGE_FILE_COUNT=36
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_DIR=/tmp/redcola-final-dryrun-062ed8e4c-093037/redcola-final-submission
FINAL_PACKAGE_VERIFY_FILE_COUNT=36
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS=bf4191734074f17f9d7fa365b0b108bdc3b2486d7be290e4f56246fc6f98dee4

Kali/Linux clean-worktree dry run after tightening the final-video narrative:
AXVISOR_HEAD=fae6bcf498fa29a29ae3c5843670b6d842b4fa93
STARRY_HEAD=c611704ea80a1752d63afe0f0dccf058293928c2
EVIDENCE_DIR=/home/kali/qc-evidence/qc-demo-hub-head-d9f8fa3c2-20260814_081925
FINAL_PACKAGE_DIR=/tmp/redcola-final-dryrun-fae6bcf49-093958/redcola-final-submission
FINAL_PACKAGE_FILE_COUNT=36
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_DIR=/tmp/redcola-final-dryrun-fae6bcf49-093958/redcola-final-submission
FINAL_PACKAGE_VERIFY_FILE_COUNT=36
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS=302862f789cb955caa68b34cd09aed10adec896d4570db817e52a69e7b1272b7

Kali/Linux clean-worktree dry run after refreshing StarryOS QCZ1 parity links:
AXVISOR_HEAD=c65bc73c60a3c5dbc6220cc5ede6a581671f26a3
STARRY_HEAD=35bb10d9a50a772359693b0d0516108c69de77a5
STARRY_RUNTIME_EVIDENCE_HEAD=4cbd22ccb837
EVIDENCE_DIR=/home/kali/qc-evidence/qc-demo-hub-head-e1a01b82-20260814_094911
STARRY_EVIDENCE_DIR=/home/kali/qc-evidence/starry-qemu-redcola-qcz1-parity-head-4cbd22ccb837-20260814_103336
FINAL_PACKAGE_DIR=/tmp/redcola-final-dryrun-c65bc73c-104627/redcola-final-submission
FINAL_PACKAGE_FILE_COUNT=34
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_DIR=/tmp/redcola-final-dryrun-c65bc73c-104627/redcola-final-submission
FINAL_PACKAGE_VERIFY_FILE_COUNT=34
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS=cee126ad6646252e3766d29043cc0949590002e9b1db4c9258b3f579af42f7f7

Windows/Git Bash dry run after adding the TAP before/after summaries to the
package manifest:
AXVISOR_HEAD=353d555d5bf38841dd9ba2ea22572b8d05dc8a27
FINAL_PACKAGE_DIR=tmp/redcola-final-package-dryrun-current/redcola-final-submission-dryrun
FINAL_PACKAGE_FILE_COUNT=34
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_FILE_COUNT=34
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS=57817694973208e6f754d75ed12550bb8ac3562c7d7c2aea89da81e4a29919f8

Windows/Git Bash dry run from the current submitted PR `#1` head:
AXVISOR_HEAD=2a7e974a93b5a4ba00270fb0d552b8b72a05b21e
FINAL_PACKAGE_DIR=tmp/redcola-final-package-dryrun-head-2a7e974a/redcola-final-submission-dryrun
FINAL_PACKAGE_FILE_COUNT=34
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_FILE_COUNT=34
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS_TXT_HASH=<regenerate-from-selected-final-head>

Windows/Git Bash dry run after adding the task-one core-claim document:
FINAL_PACKAGE_DIR=tmp/redcola-final-package-dryrun-coreclaim-20260814-144407/redcola-final-submission-dryrun
FINAL_PACKAGE_FILE_COUNT=35
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_FILE_COUNT=35
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS_TXT_HASH=<regenerate-from-selected-final-head>

Windows/Git Bash dry run after adding the final demo recording runbook:
FINAL_PACKAGE_DIR=tmp/redcola-final-package-dryrun-runbook-20260814-150703/redcola-final-submission-dryrun
FINAL_PACKAGE_FILE_COUNT=36
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_FILE_COUNT=36
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS_TXT_HASH=<regenerate-from-selected-final-head>

Windows/Git Bash dry run after adding the task-one 30-point reviewer checklist:
FINAL_PACKAGE_DIR=tmp/redcola-final-package-dryrun-taskone30-20260814-151839/redcola-final-submission-dryrun
FINAL_PACKAGE_FILE_COUNT=37
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_FILE_COUNT=37
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS_TXT_HASH=<regenerate-from-selected-final-head>

Windows/Git Bash dry run after adding the task-two/task-three 50-point
reviewer checklist:
FINAL_PACKAGE_DIR=tmp/redcola-final-package-dryrun-task23-50-20260814-152516/redcola-final-submission-dryrun
FINAL_PACKAGE_FILE_COUNT=38
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_FILE_COUNT=38
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS_TXT_HASH=<regenerate-from-selected-final-head>

Windows/Git Bash dry run after adding the StarryOS bonus scorecard:
FINAL_PACKAGE_DIR=tmp/redcola-final-package-dryrun-starry-scorecard-20260814-153235/redcola-final-submission-dryrun
FINAL_PACKAGE_FILE_COUNT=39
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_FILE_COUNT=39
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS_TXT_HASH=<regenerate-from-selected-final-head>

Windows/Git Bash dry run after adding the engineering/innovation 20-point
reviewer checklist:
FINAL_PACKAGE_DIR=tmp/redcola-final-package-dryrun-eng20-20260814-154020/redcola-final-submission-dryrun
FINAL_PACKAGE_FILE_COUNT=40
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY_FILE_COUNT=40
FINAL_PACKAGE_VERIFY=PASS
SHA256SUMS_TXT_HASH=<regenerate-from-selected-final-head>

Latest Windows package proof point after aligning the final video scripts with
the 4-worker TAP/tcpdump proof and refreshing the uploadable archive:
AXVISOR_ARCHIVE_SOURCE_HEAD=b668ba83a69e1f1dbf40892267feac6038caf4bb
STARRY_ARCHIVE_SOURCE_HEAD=e3d8bbf8d9dc6cf7f512017092fb3fdb0c4857f2
ARCHIVE=redcola-current-head-with-video-20260814-b668ba83a-v2.zip
ARCHIVE_SHA256=405dceb29de54ae4ac9a1243ae056bb30caaddcd769e76e71d2260b168abc883
FINAL_PACKAGE_VERIFY_FILE_COUNT=55
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY=PASS
UNZIPPED_FINAL_PACKAGE_VERIFY=PASS
```

The package builder includes the three small 4-worker TAP/tcpdump proof files
listed above. Regenerate only once more from the selected final head before the
2026-08-24 upload, because any later documentation or video change will
naturally change the archive hash.

The package builder may include three additional small demo-analysis files when
`--evidence-dir` points at a final-video rehearsal directory. The current
Windows proof above intentionally uses only repository summaries, StarryOS PR
material and the demo video, so it is the easiest package to reproduce from the
private PR heads.

## Current Evidence Hashes To Carry Forward

The following small evidence summaries are ready to copy into the final package
if no newer TAP/video evidence supersedes them:

```text
demo hub rehearsal evidence directory:
/home/kali/qc-evidence/demo-hub-rehearsal-20260814_040528

11adb4fc9cec9774bed4c3202550fa5b62a8fd8c67e82760aedf851dc0bfe958  realtime-report.md
5ceaa1df23a048aa6afe302ea781e8f40b05c920e70bfb021001a26942a76bcd  realtime-summary.json
bf87df6796d8a00dbdebd88a5e63b1e599d3f3dc3617c64fbabf84022b131790  runner.log

demo hub rehearsal with one Linux stress worker:
/home/kali/qc-evidence/demo-hub-rehearsal-w1-20260814_042902

fe4f250c36f3421fb7f51b88a21c08c9b01ef5377a7e355bb9f0b021be8f4bd8  realtime-report.md
7d68d4a5ea9cb13a624c263fc1f9a89fe69f07760f19a41c8a1f5c160ee01f29  realtime-summary.json
5275d62425bdf0842b746bd73f448d5561317f67d1ef30b94a2edad9cf1147dc  runner.log
```

The hub rehearsal is useful for final-video readiness and marker capture:
Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, AI `10/10`, AI end-to-end mean/max
`1589 us / 2697 us`, RTOS periodic `PASS` and final `result=PASS`. It remains
separate from TAP/tcpdump evidence because hub mode records `tcpdump=SKIPPED`.
The 1-worker rehearsal additionally confirms Linux stress `STARTED`/`STOPPED`,
`3000` Linux periodic samples, AI end-to-end mean/max `3450 us / 20765 us`, and
the same UDP/QCZ1/AI PASS markers under light Linux pressure.

Recent PR-head hub rehearsal at `e703ae46f8b6b1a814c0e5051776fc09d8f4022e`:

```text
/home/kali/qc-evidence/qc-demo-hub-latest-e703-20260814_065528

498df0c88445ce72db2dde1efd00e89b4c05401ecf302519c7b5e3068446cb37  analysis.md
57ac99f0f99e2eb232f31793276afa2207ea98a2f715a2f666944e34c63c39d0  analysis.json
121ac3e0025d87b6d0fcea9111b17086c35f63beaa752810e8db681acc7474b3  runner.log

result=PASS
analysis_result=PASS
net_mode=hub
Linux guest CPUs=2
Linux stress workers=1
Linux periodic samples=3000
RTOS periodic samples=1000
Plain UDP=20/20 PASS
QCZ1 reliable UDP=10/10 PASS
QCZ1 retransmits=0
AI control=10/10 PASS
AI e2e mean/max=4886 us / 18775 us
RTOS p99/max=627184 ns / 2568800 ns
tcpdump=SKIPPED
```
