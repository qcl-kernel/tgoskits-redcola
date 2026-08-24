# Final Submission Message

This note provides the finalized message for the 2026-08-24 submission.

## Chinese Template

```text
老师您好，redcola 队提交泉城实验室 2026 AxVisor 擂台赛“智能化工控中基于虚拟化的混合系统部署及联动实现”方向最终材料。

代码仓库：
https://github.com/qcl-kernel/tgoskits-redcola

主要分支和 PR：
1. 主交付 PR #1：contest/axvisor-2026
   范围：2 个 AxVM PCI interrupt-map 解析文件 + os/axvisor/contest/quancheng2026/
   链接：https://github.com/qcl-kernel/tgoskits-redcola/pull/1

2. 最终 StarryOS 加分项 PR #3：contest/starry-redcola-ai-bonus-final-20260824
   目录：apps/starry/qemu/redcola-ai-control/
   链接：https://github.com/qcl-kernel/tgoskits-redcola/pull/3

3. AxVisor core 支撑补丁：rcore-os/tgoskits#1770，已合入官方 dev
   链接：https://github.com/rcore-os/tgoskits/pull/1770

本次材料主要包含：
- 基于官方最新 dev `3a3af51675c9811dafd842db644cf915084ca9fe` 的最终同步与验证；
- AxVM PCI `interrupt-map` 透传 IRQ 解析修复，定向测试 `1/1 PASS`，AxVM host-test `296/296 PASS`；
- AxVisor 双 guest Linux/Zephyr RTOS 混合部署与复现脚本；
- Linux/RTOS IPv4/UDP 通信链路；
- QCZ1 可靠 UDP 应用层协议，包含 ACK、状态回传、错误路径、序号、时间戳和校验字段；
- Linux 侧 AI 推理到 RTOS 控制状态更新的闭环演示；
- Zephyr 原生 RTOS latency baseline、AxVisor 双 guest 周期任务数据、压力测试和稳定性结果；
- pre-#1770 与当前分支的 before/after 实时性对比、TAP/tcpdump before/after 矩阵，以及 4-worker 过载边界证据；
- StarryOS 非实时 guest AI-control 加分项；
- 设计文档、测试报告、复现说明、证据索引、评分追踪、5 分钟演示 PPT、配音稿、视频验收脚本和可验证最终提交包。

关键验证结果：
- 最新 dev 双 guest：Linux 2 vCPU，plain UDP 20/20 PASS，QCZ1 10/10 PASS，AI 10/10 PASS，最终 result=PASS；
- 最新 dev 任务一长压力：30000 个 1 ms 样本，2 个压力 worker，周期探针与压力任务分配到不同 guest vCPU，全链路 PASS；
- TAP/tcpdump before/after 矩阵已完成，四行均 PASS，tcpdump captured/dropped 均为 88/0；
- Linux/RTOS plain UDP：20/20 PASS；
- QCZ1 reliable UDP：10/10 PASS，retransmits 0；
- AI control loop：10/10 PASS；
- Linux guest：2 vCPU；
- StarryOS bonus：REDCOLA_STARRY_QCZ1_PARITY_PASS、REDCOLA_STARRY_AI_CONTROL_PASS、REDCOLA_STARRY_AI_DONE。
- 演示视频（队长本人录制并配音）：`redcola-成果材料/video/redcola-axvisor-demo.mp4`，385.079 秒、2560x1600；SHA256 为 `20a15f735f446595ad48cb15872d39c2dec0ce2e9107c450a8f59cc2017629ba`。
- 实体板证据：`redcola-成果材料/evidence-raw/redcola-board-evidence-20260824.tar.gz`；SHA256 为 `7af6beee3ef1ad2b041d25073a7df2a24e5ddca87d76d5e0bada46c0b5b6b974`。

推荐审阅入口：
1. os/axvisor/contest/quancheng2026/docs/evidence-index.md
2. os/axvisor/contest/quancheng2026/docs/second-version-reviewer-quickstart.md
3. os/axvisor/contest/quancheng2026/docs/scorecard-traceability.md
4. os/axvisor/contest/quancheng2026/docs/task-one-score-summary.md
5. os/axvisor/contest/quancheng2026/docs/physical-board-native-linux-baseline.md
6. os/axvisor/contest/quancheng2026/docs/task-two-three-score-summary.md
7. os/axvisor/contest/quancheng2026/docs/design.md
8. os/axvisor/contest/quancheng2026/docs/test-report.md
9. os/axvisor/contest/quancheng2026/docs/reproduce.md
10. os/axvisor/contest/quancheng2026/docs/starryos-bonus.md

演示视频位于私有仓库成果目录：
redcola-成果材料/video/redcola-axvisor-demo.mp4

成果文件完整性清单：
redcola-成果材料/SHA256SUMS.txt
```

## PR Links

```text
Private repository:
https://github.com/qcl-kernel/tgoskits-redcola

Main PR:
https://github.com/qcl-kernel/tgoskits-redcola/pull/1

Final StarryOS bonus PR:
https://github.com/qcl-kernel/tgoskits-redcola/pull/3

Merged AxVisor core support:
https://github.com/rcore-os/tgoskits/pull/1770
```

## Current Evidence Addendum

Use this addendum when preparing the 2026-08-24 final message, together with
the final video link and the final package SHA256:

```text
最终材料已补充当前 head 的 30000-sample 长压力证据：hub-mode 和 TAP/tcpdump 均保留汇总；TAP 证明覆盖 Linux guest 2 vCPU、2 个与 4 个 Linux stress worker、Linux/RTOS TAP 网络，结果均保持 UDP 20/20 PASS、QCZ1 10/10 PASS、AI 10/10 PASS，tcpdump captured/dropped 为 88/0。最新 4-worker TAP 行记录 RTOS p99/max 为 1821568 / 31444800 ns，AI 端到端 mean/max 为 5277 / 15431 us。任务一第二版汇总入口为 results/task-one-second-version-summary.md，最终演示视频提示卡为 docs/final-video-cue-card-cn.md。

另补充 ATK-DLRK3588B（RK3588）实机原生 Linux 周期延迟基线：3 个场景共 `900000` cycles，idle/隔离压力/全核压力最大延迟分别为 `95/76/1338 us`，histogram overflow 为 `0`。该证据仅作为物理平台压力参考，不宣称 AxVisor 已在该板运行。
```

Current long TAP evidence roots:

```text
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_180823
/home/kali/qc-evidence/t1-current-head-long-tap-20260814_215018
```

Package proof handling:

```text
FINAL_PACKAGE_BUILD=PASS
FINAL_PACKAGE_VERIFY=PASS
fresh-unzip verify=PASS
```

The uploaded ZIP hash is intentionally kept beside the archive in the external
`.zip.sha256` file. Do not write a ZIP archive's own SHA256 into a file inside
that same ZIP, because doing so changes the archive content and invalidates the
hash. For the 2026-08-24 final upload, regenerate the package once from the
selected final branch head and use that package's `README.txt`,
`SHA256SUMS.txt` and external `.zip.sha256` file as the authoritative final
proof.

## Final Fill-In Checklist

Before sending the final message:

1. Confirm private PR `#1` and final StarryOS PR `#3` point to the intended heads.
2. Confirm `SUBMISSION-BASE.txt` records official latest `dev`.
3. Confirm `SHA256SUMS.txt` verifies every submitted artifact.
4. Confirm no credentials, runtime images, kernels, build caches or temporary bundles are
   included in the uploaded package.
