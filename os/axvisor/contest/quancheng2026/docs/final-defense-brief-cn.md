# redcola 最终答辩速读卡

本文件用于 2026 泉城实验室 AxVisor 擂台赛最终答辩、演示视频和评审沟通。它只记录可复现、可验证的交付边界，避免把实验性改动说成已合入主线能力。

## 一句话结论

redcola 当前交付的是一个基于 AxVisor 的 Linux/RTOS 混合部署与智能控制闭环：Linux/StarryOS 侧负责非实时计算和 AI 推理，Zephyr RTOS 侧负责实时控制响应，两侧通过 IPv4/UDP 上的 QCZ1 应用层协议通信，并用任务一实时性数据、任务二网络协议数据、任务三 AI 闭环数据和 StarryOS 加分材料支撑最终评分。

## 评审先看这些

| 入口 | 用途 |
| --- | --- |
| `PR-LINKS.txt` | 私有仓库、主交付 PR、StarryOS 加分 PR 和已合入 core PR 链接 |
| `docs/scorecard-traceability.md` | 按评分项映射全部证据 |
| `docs/final-submission-checklist.md` | 当前交付状态、里程碑和最终包状态 |
| `docs/task-one-reviewer-defense-qna.md` | 任务一实时性答辩口径 |
| `docs/task-two-three-50-point-checklist.md` | 任务二通信和任务三 AI 闭环评分覆盖 |
| `docs/starryos-bonus-scorecard.md` | StarryOS 加分项边界与证据 |
| `video/redcola-axvisor-demo.mp4` | 最终演示视频 |

## 三个任务怎么讲

| 任务 | 答辩重点 | 关键证据 |
| --- | --- | --- |
| 任务一：实时性改造与验证 | 不只提交演示脚本，而是围绕 AxVisor 定时器/中断路径、双 guest、2 vCPU Linux、Zephyr RTOS、压力场景和前后对比做了可复现实验。 | 已合入 `rcore-os/tgoskits#1770`；主 PR 中两文件 PCI `interrupt-map` 解析修复；AxVM 定向 `1/1` 和完整 `296/296` 测试；10000 样本前后对比；30000 样本长压力；TAP/tcpdump 和 Zephyr 原生基线。 |
| 任务二：客户机间通信 | 主数据通道是 IP 网络，不是共享内存、HyperCall 或裸 MMIO。Linux 与 RTOS 通过 IPv4/UDP 通信，并在应用层实现 QCZ1。 | Plain UDP `20/20 PASS`；QCZ1 `10/10 PASS`；ACK/超时/重传/状态/错误路径；状态负例自测；tcpdump 抓包。 |
| 任务三：AI 控制闭环 | AI 推理输出通过 QCZ1 发送给 RTOS，RTOS 根据输出调整控制量并回传状态，形成完整闭环。 | AI control `10/10 PASS`；平均误差 AI `207` 对固定参数 `240`；同样本 `+/-200` 容差达标 AI `6/10` 对固定参数 `0/10`；端到端延迟统计和视频闭环展示。 |

## StarryOS 加分怎么讲

StarryOS 加分项单独放在私有 PR `#2`，避免和主 AxVisor 交付混在一起。当前证据包括 StarryOS QEMU 内运行确定性 AI 控制 demo、QCZ1 frame parity 标记和 AI control PASS 标记。这里主张的是“StarryOS 非实时客户机方向的可运行加分证据”，不主张已经完成 StarryOS syscall/ABI 加分项。

## 建议答辩话术

1. 我们的主线交付在私有仓库 `qcl-kernel/tgoskits-redcola`，主交付 PR 是 `#1`，StarryOS 加分 PR 是 `#2`。
2. 任务二和任务三是完整闭环：IPv4/UDP 网络链路、QCZ1 协议、AI 推理、RTOS 控制和状态回传都已跑通并记录结果。
3. 任务一重点是把实时性验证从普通 smoke test 提升到前后对比、长压力、TAP 抓包和 RTOS 基线对比；核心支撑 PR `#1770` 已合入上游。
4. 最终包只包含源码、文档、测例、证据摘要、视频和 SHA256，不包含镜像、原始日志、pcap、缓存或凭据。

## 不要这样说

| 不建议说法 | 推荐说法 |
| --- | --- |
| “三个任务全部 100% 完成。” | “三个任务均已形成可复现交付闭环，任务一仍保留进一步硬件验证和更深实时化优化空间。” |
| “StarryOS 已完全替代 Linux 完成全部任务。” | “StarryOS 已作为独立加分 PR 提供可运行 AI 控制和协议一致性证据。” |
| “CI 红叉说明代码失败。” | “私有镜像仓库 Actions 可能受组织 runner/镜像/空间限制影响；评审以分支、PR diff、复现脚本和本地验证证据为准。” |
| “我们改了很多核心代码都在主 PR 里。” | “主 PR 仅包含一个独立的两文件 AxVM PCI `interrupt-map` 解析修复和竞赛材料；更广的定时器/中断核心支撑 PR `#1770` 已合入上游。” |

## 当前冲分重点

第一版和第二版提交已经具备完整交付形态。最终版继续优先做三件事：保持任务一长压力和前后对比证据稳定，录制/替换最终演示视频，按最终 head 重新生成 ZIP 与外部 `.zip.sha256` 文件。
