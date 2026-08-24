# First-Version Submission Message

This note provides a concise organizer-facing message template for the
2026-08-14 first-version checkpoint. It is intentionally modest: it states the
submitted scope, points reviewers to the private repository and records the
remaining work for the next checkpoints.

## Chinese Template

```text
老师您好，redcola 队已提交 2026-08-14 第一版阶段性材料。

私有仓库：
https://github.com/qcl-kernel/tgoskits-redcola

主要提交入口：
1. 主交付 PR #1：contest/axvisor-2026
   目录：os/axvisor/contest/quancheng2026/
2. StarryOS 加分项 PR #2：contest/starry-redcola-ai-bonus-clean-20260731
   目录：apps/starry/qemu/redcola-ai-control/
3. AxVisor 核心支撑补丁：rcore-os/tgoskits#1770，已合入上游 dev

第一版材料主要包含：
- AxVisor 双 guest Linux/Zephyr RTOS 混合部署与复现脚本；
- Linux/RTOS IPv4/UDP 通信链路；
- QCZ1 可靠 UDP 应用层协议，包含 ACK、状态回传、错误路径、序号、时间戳和校验字段；
- Linux 侧 AI 推理到 RTOS 控制状态更新的闭环演示；
- Zephyr 原生 RTOS latency baseline、AxVisor 双 guest 周期任务数据、压力测试和稳定性结果；
- pre-#1770 与当前分支的 10000-sample before/after hub-mode 对比、TAP/tcpdump before/after 矩阵、当前 head 30000-sample 长样本 TAP/tcpdump 压力证据，以及 4-worker 过载边界证据；
- StarryOS 非实时 guest AI-control 加分项；
- 设计文档、测试报告、复现说明、协议说明、网络拓扑、证据索引、评分追踪、最终提交 checklist、演示视频脚本和中文录屏提示卡。

推荐审阅入口：
1. os/axvisor/contest/quancheng2026/docs/first-version-submission-status.md
2. os/axvisor/contest/quancheng2026/docs/evidence-index.md
3. os/axvisor/contest/quancheng2026/docs/scorecard-traceability.md
4. os/axvisor/contest/quancheng2026/docs/design.md
5. os/axvisor/contest/quancheng2026/docs/test-report.md
6. os/axvisor/contest/quancheng2026/docs/reproduce.md
7. os/axvisor/contest/quancheng2026/docs/starryos-bonus.md

当前说明：
第一版已经覆盖代码、文档和测例。任务一实时性部分目前已有原生 Zephyr baseline、AxVisor 双 guest 长样本、stress、before/after hub-mode 对比、TAP/tcpdump before/after 矩阵、当前 head 30000-sample 长 TAP/tcpdump 压力证据和 4-worker 过载边界。后续 8.21/8.24 节点会继续整理最终演示视频、最终包 SHA256 和答辩展示材料。
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
