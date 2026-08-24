# Second-Version Submission Message

This note provides a concise organizer-facing message template for the
2026-08-21 second-version checkpoint.

## Chinese Template

```text
老师您好，redcola 队提交 2026-08-21 第二版阶段性材料。

私有仓库：
https://github.com/qcl-kernel/tgoskits-redcola

主要提交入口如下：

1. 主交付 PR #1：contest/axvisor-2026
   目录：os/axvisor/contest/quancheng2026/
   链接：https://github.com/qcl-kernel/tgoskits-redcola/pull/1

2. StarryOS 加分项 PR #2：contest/starry-redcola-ai-bonus-clean-20260731
   目录：apps/starry/qemu/redcola-ai-control/
   链接：https://github.com/qcl-kernel/tgoskits-redcola/pull/2

3. 已合入官方 dev 的 AxVisor core 支撑 PR：
   https://github.com/rcore-os/tgoskits/pull/1770

第二版相对第一版主要补充如下：

- 补充任务一实时性说明，明确 AxVisor timer/interrupt 路径、PR #1770 支撑点、before/after 基线和保守结论；
- 补充 pre-#1770 基线与当前分支的同形态 before/after 对比，覆盖 hub 与 TAP/tcpdump 两类运行方式；
- 补充 10000-sample hub-mode 0/1/2-worker 长样本矩阵，并保留最大延迟与异常 outlier，不隐藏不利数据；
- 完成 TAP/tcpdump before/after 矩阵，0/2-worker 四行均 PASS，tcpdump captured/dropped 均为 88/0；
- 补充当前 head 的 30000-sample 2-worker 与 4-worker 长压力证据，其中 4-worker 作为 2-vCPU Linux guest 的 overcommit 边界证据；
- 补充精确提交 head 的 2-worker、30000-sample 三轮稳定性 repeat，三轮均 PASS；
- 保持任务二 Linux/RTOS UDP、QCZ1 可靠协议、ACK/状态/错误路径验证稳定；
- 保持任务三 AI 推理、QCZ1 网络发送、RTOS 控制输出和状态回传闭环稳定；
- 重新生成并校验当前阶段提交包，包含 63 个文件、演示视频、StarryOS 加分材料、StarryOS reviewer quickstart、任务一证据摘要和最终答辩/视频证明材料。

推荐审阅顺序：

1. os/axvisor/contest/quancheng2026/docs/second-version-reviewer-quickstart.md
2. os/axvisor/contest/quancheng2026/docs/task-one-realtime-core-claim.md
3. os/axvisor/contest/quancheng2026/docs/second-version-submission-status.md
4. os/axvisor/contest/quancheng2026/docs/task-one-score-summary.md
5. os/axvisor/contest/quancheng2026/docs/task-two-three-score-summary.md
6. os/axvisor/contest/quancheng2026/docs/realtime-evaluation.md
7. os/axvisor/contest/quancheng2026/docs/test-report.md
8. os/axvisor/contest/quancheng2026/docs/scorecard-traceability.md
9. os/axvisor/contest/quancheng2026/docs/evidence-index.md

当前阶段包：
redcola-current-head-with-video-20260815-dca3bfdd-v1.zip

SHA256：
8710e9bbfad862201bd89e02d03b928a94f99f7b816d0eaece102be80c72aacd

说明：
仓库中只提交源码、配置、文档、脚本和小型结果摘要；原始 QEMU 日志、pcap、镜像、rootfs 等大文件不放入 git。压缩包精确 head 以包内 `README.txt` 为准，SHA256 以包外同名 `.zip.sha256` 文件为准。PR 后续可能继续有文档说明类提交；运行证据和压缩包身份均按文档中记录的 source head/README/SHA256 对应。最终版将在 2026-08-24 前按最终选定 head 重新生成。
```

## Review Entry Points

```text
Private repository:
https://github.com/qcl-kernel/tgoskits-redcola

Main PR:
https://github.com/qcl-kernel/tgoskits-redcola/pull/1

StarryOS bonus PR:
https://github.com/qcl-kernel/tgoskits-redcola/pull/2

Merged AxVisor core support:
https://github.com/rcore-os/tgoskits/pull/1770
```

## Current Evidence Addendum

Add this short paragraph if the organizer asks what changed after the
first-version submission:

```text
第二版主要加强任务一实时性验证证据：新增记录型 runtime-source 的 30000-sample 长压力 hub/TAP 证明、TAP/tcpdump before/after 矩阵，以及精确提交 head 的三轮稳定性 repeat。相关运行均保持 UDP 20/20 PASS、QCZ1 10/10 PASS、AI 10/10 PASS；TAP/tcpdump 行记录 captured/dropped 为 88/0。4-worker 行作为 2-vCPU Linux guest 的 overcommit 边界证据，用于说明重压下链路完整性，不作为主要延迟改善结论。当前阶段包已完成 63 文件校验和 fresh-unzip 校验，并包含 task-one reviewer defense Q&A、final defense brief、demo acceptance checklist、video proof 和 StarryOS reviewer quickstart。
```

Current long TAP evidence roots:

```text
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_180823
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018
```

Current exact-head stability repeat:

```text
/home/kali/qc-evidence/t1-head746-2w-hub-stability-r30000-20260815_031511
```

Attached package identity:

```text
Archive: use the attached ZIP filename
Source head: recorded in package README.txt
StarryOS head: recorded in StarryOS bonus material
SHA256: use the sibling .zip.sha256 file
Verify: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS, fresh-unzip verify=PASS
```

Latest verified checkpoint package proof:

```text
Archive: redcola-current-head-with-video-20260815-dca3bfdd-v1.zip
Main head: dca3bfdd58b3f1df14258c622cb824325ca89946
StarryOS head used by this archive: 359a2746d94f9128ea2843109e4eb6b8bf53eda7
Current PR #2 branch head after the 2026-08-18 latest-dev sync:
2ac656341a63facdc3030fa3fd99bd20de156bef
SHA256: 8710e9bbfad862201bd89e02d03b928a94f99f7b816d0eaece102be80c72aacd
FINAL_PACKAGE_VERIFY_FILE_COUNT=63
FINAL_PACKAGE_VERIFY=PASS
UNZIPPED_FINAL_PACKAGE_VERIFY=PASS
Video: video/redcola-axvisor-demo.mp4
```

For the current upload archive, use that archive's package `README.txt` and
sibling `.zip.sha256` file as the authoritative source head and ZIP hash.

## Before Sending

1. Confirm private PR `#1` and `#2` are still open and point to the intended
   latest heads.
2. Keep the message modest: describe the 4-worker row as an overcommit
   boundary, not as a latency-improvement claim.
3. If the 2026-08-24 final video is rerecorded, replace the package/video
   reference with the final archive generated from the selected final head.
