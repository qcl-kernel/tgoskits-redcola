# redcola 成果材料

本目录是 redcola 队参加“泉城实验室 2026 AxVisor 揭榜挂帅擂台赛”的最终成果入口，对应赛题“智能化工控中基于虚拟化的混合系统部署及联动实现”。

## 1. 代码与原型系统

- 主交付分支：`contest/axvisor-2026`
- 主交付 PR：<https://github.com/qcl-kernel/tgoskits-redcola/pull/1>
- 主原型、Linux/RTOS 程序、QCZ1 协议、AI 控制与测试脚本：[`os/axvisor/contest/quancheng2026/`](../os/axvisor/contest/quancheng2026/)
- StarryOS 加分项分支：`contest/starry-redcola-ai-bonus-clean-20260731`
- StarryOS 加分项 PR：<https://github.com/qcl-kernel/tgoskits-redcola/pull/2>
- StarryOS 源码：<https://github.com/qcl-kernel/tgoskits-redcola/tree/contest/starry-redcola-ai-bonus-clean-20260731/apps/starry/qemu/redcola-ai-control>
- AxVisor 核心支撑补丁：<https://github.com/rcore-os/tgoskits/pull/1770>（已合入官方 `dev`）

## 2. 文档与测例

- `docs/`：设计、协议、网络拓扑、实时性、AI 控制、测试报告、复现说明、评分追踪和答辩问答。
- `evidence-summaries/`：AxVisor 双客户机、TAP/tcpdump、长时压力、通信、AI 闭环和开发板测试摘要。
- `starryos-bonus/`：StarryOS AI 控制加分项的快速复现、验证和评分映射。
- 主源码目录中的 `scripts/`、`linux/` 和 `rtos/` 是可执行测例与客户机程序。

## 3. 演示与开发板证据

- `presentation/redcola-axvisor-demo.pptx`：5 分钟演示 PPT。
- `presentation/redcola-axvisor-narration.docx`：配音稿。
- `video/redcola-axvisor-demo.mp4`：最终演示视频。
- `evidence-raw/redcola-board-evidence-20260824.tar.gz`：ATK-DLRK3588B/RK3588 实体开发板原始测试证据。
- `evidence-summaries/physical-board-atk-dlrk3588-native-linux-summary.md`：开发板测试摘要。

开发板 `cyclictest` 共记录 900,000 个周期，直方图溢出为 0：

| 场景 | 平均延迟 | 最大延迟 |
| --- | ---: | ---: |
| 空载 CPU7 | 7.41 us | 95 us |
| CPU7 隔离压力 | 2.40 us | 76 us |
| 全核压力 | 9.30 us | 1338 us |

## 4. 关键验证结果

- Linux/RTOS plain UDP：`20/20 PASS`
- QCZ1 可靠 UDP：`10/10 PASS`
- AI 控制闭环：`10/10 PASS`
- Linux 客户机：2 vCPU 启动通过
- TAP/tcpdump：88 个数据包，0 个内核丢包
- 当前分支长压力：30,000 个 1 ms 周期样本，全链路 `PASS`
- StarryOS：`REDCOLA_STARRY_QCZ1_PARITY_PASS`、`REDCOLA_STARRY_AI_CONTROL_PASS`、`REDCOLA_STARRY_AI_DONE`

## 5. 建议评审顺序

1. 阅读本文件。
2. 阅读 `docs/second-version-reviewer-quickstart.md`。
3. 阅读 `docs/evidence-index.md` 和 `docs/scorecard-traceability.md`。
4. 按 `docs/reproduce.md` 运行静态检查、单项测例或双客户机测试。
5. 查看 PPT、配音稿与 MP4 演示视频。

## 6. 提交边界

- 本目录不包含凭据、构建缓存、运行时镜像、内核二进制或临时日志。
- 不存在第三方测试报告；赛题中该项为“若有”。
- 文件完整性以本目录的 `SHA256SUMS.txt` 为准。
