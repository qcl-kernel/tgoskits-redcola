# 5-Minute Demo Video Script

This script is for the final Quancheng Lab 2026 AxVisor contest video. It is
written for a single-screen recording with two terminals:

- left terminal: run the AxVisor reproduction command;
- right terminal: show the scorecard, evidence index and result reports.

Use `docs/final-demo-recording-runbook.md` as the operational checklist before
recording. This script focuses on the five-minute narration and screen flow.
For a shorter Chinese prompt that can stay open during recording, use
`docs/final-video-cue-card-cn.md`. After recording, use
`docs/final-demo-acceptance-checklist.md` as the pass/fail gate before
rebuilding the final package.

## Recording Setup

Pre-recording checklist:

```text
Private main PR is open: qcl-kernel/tgoskits-redcola#1
StarryOS bonus PR is open: qcl-kernel/tgoskits-redcola#2
PR branch is contest/axvisor-2026
Prepared Kali runtime worktree is available
Runtime worktree may be detached at the measured evidence source head
Evidence index is visible: docs/evidence-index.md
Scorecard traceability is visible: docs/scorecard-traceability.md
Kali sudo is authenticated if TAP/tcpdump will be recorded
No passwords, tokens or private keys are visible on screen
```

For the final video, prefer TAP mode so tcpdump captured/drop counters are
visible. If TAP is unavailable during a rehearsal, use hub mode only as a
clearly labelled fallback; hub mode does not replace TAP/tcpdump evidence.

## Claims To Keep Conservative

Use these guardrails during narration and Q&A:

```text
Claim the 4-worker rows as an overcommit/stability boundary, not as the main
latency-improvement result.

Claim StarryOS as separate bonus evidence for the non-RT guest direction, not
as a full replacement for the main Linux/RTOS AxVisor closed loop.

Claim TAP/tcpdump proof from the recorded before/after matrix and current-head
long TAP rows. If the live recording falls back to hub mode, label it as a
live fallback and then show the submitted TAP summaries.

Do not claim that every contest item is 100% complete until the final
2026-08-24 video and final package are regenerated and verified.
```

## Scoring Storyboard

| Video moment | Scoring item to make visible | Required proof on screen |
| --- | --- | --- |
| Opening | Engineering completeness | Private PR `#1`, StarryOS PR `#2`, branch names, evidence index. |
| Topology | Task two network channel | Linux/RTOS IP addresses, UDP port, QCZ1 protocol fields and no shared-memory main channel. |
| Live run | Tasks two and three | Plain UDP `20/20`, QCZ1 `10/10`, AI `10/10`, RTOS state return and final `result=PASS`. |
| Realtime report | Task one | Linux `2` vCPUs, RTOS periodic PASS, Linux/RTOS p99/max latency, stress worker count, and current-head `30000`-sample long-pressure rows. |
| Before/after table | Task one improvement | pre-`#1770` versus current branch 0/1/2-worker rows, with 4-worker labelled as overcommit boundary. |
| Packet capture | Task two reliability and isolation | TAP-mode tcpdump captured packets and kernel drops `0`; if not live, show latest recorded TAP evidence separately, including the `88/0` long TAP proof. |
| StarryOS | Bonus | `REDCOLA_STARRY_QCZ1_PARITY_PASS`, `REDCOLA_STARRY_AI_CONTROL_PASS`, `REDCOLA_STARRY_AI_DONE`, and the note that it is a separate bonus PR. |

## Main Live Command

```bash
REPO=/home/kali/qc-tgoskits-final-sync-220af-20260820
cd "${REPO}/os/axvisor/contest/quancheng2026"
sudo -v

./scripts/run_axvisor_dual_guest_qcz1_ai.sh \
  --net-mode tap \
  --evidence-dir /tmp/qc_demo_final_evidence \
  --timeout 180 \
  --linux-rt-samples 3000 \
  --linux-rt-period-ns 10000000 \
  --linux-stress-workers 2 \
  --linux-stress-seconds 0 \
  --linux-rt-cpu 0 \
  --linux-stress-cpu 1 \
  --linux-quiet
```

Fast fallback rehearsal command:

```bash
./scripts/run_axvisor_dual_guest_qcz1_ai.sh \
  --net-mode hub \
  --evidence-dir /tmp/qc_demo_final_evidence \
  --timeout 120 \
  --linux-rt-samples 2000 \
  --linux-stress-workers 0 \
  --linux-stress-seconds 0
```

Post-run report commands:

```bash
./scripts/analyze_dual_guest_realtime.py /tmp/qc_demo_final_evidence --fail-on-missing
sed -n '1,180p' /tmp/qc_demo_final_evidence/realtime-report.md
cat /tmp/qc_demo_final_evidence/realtime-summary.json
```

## 0:00-0:30 Opening

Narration:

大家好，我们是 redcola 队。我们的赛题是“智能化工控中基于虚拟化的混合系统部署及联动实现”。本演示展示一个基于 AxVisor 的混合系统：在同一个 QEMU AArch64 平台中同时运行 Linux Guest 和 Zephyr RTOS Guest，通过 IPv4/UDP 网络完成客户机间通信，并把 Linux 侧 AI 推理结果发送给 RTOS 侧，形成可观察的控制闭环。

Screen:

- show private repository, PR `#1`, PR `#2` and branch names;
- show `docs/evidence-index.md`;
- show `docs/second-version-reviewer-quickstart.md`.

Suggested commands:

```bash
REPO=/home/kali/qc-tgoskits-final-sync-220af-20260820
cd "${REPO}"
git rev-parse --short HEAD
sed -n '1,100p' os/axvisor/contest/quancheng2026/docs/evidence-index.md
sed -n '1,120p' os/axvisor/contest/quancheng2026/docs/second-version-reviewer-quickstart.md
```

## 0:30-1:10 Task Mapping And Topology

Narration:

这套系统对应三个核心任务。任务一是实时性改造与验证：Linux Guest 使用 2 个 vCPU，Zephyr RTOS Guest 执行周期任务，并结合 Zephyr 原生 latency benchmark 做基线对照。任务二是客户机间通信：主数据通道是 IPv4/UDP，不使用共享内存、HyperCall 或裸 MMIO 作为主通道；应用层协议是 QCZ1，包含版本、消息类型、长度、序号、时间戳、状态码和校验字段。任务三是 AI 联动：Linux Guest 运行轻量神经网络推理，输出控制量；RTOS Guest 接收后更新控制状态，并回传 ACK 和 STATUS。

Screen:

- show topology, protocol and scorecard docs.

Suggested commands:

```bash
sed -n '1,100p' os/axvisor/contest/quancheng2026/docs/network-topology.md
sed -n '1,110p' os/axvisor/contest/quancheng2026/docs/protocol.md
sed -n '1,120p' os/axvisor/contest/quancheng2026/docs/scorecard-traceability.md
```

## 1:10-2:45 Live Reproduction

Narration:

现在运行复现实验脚本。脚本会检查固定版本运行时工件，启动 AxVisor 双 Guest，然后等待普通 UDP、QCZ1 可靠 UDP、AI 控制、Linux 周期探针、RTOS 周期探针和最终 Guest marker 全部通过。只有这些条件同时满足时，脚本才会输出 `result=PASS`。如果本次录制使用 TAP 模式，还会同时展示 tcpdump 抓包和内核丢包计数。

Screen:

- run the main command in the left terminal;
- keep the right terminal on `docs/scorecard-traceability.md`;
- point out Linux IP `192.0.2.10` and Zephyr RTOS IP `192.0.2.20`;
- capture plain UDP `20/20 PASS`, QCZ1 `10/10 PASS`, AI `10/10 PASS`;
- capture Linux/RTOS periodic probe summaries and final `result=PASS`;
- for TAP mode, capture tcpdump kernel drops `0`.

Suggested command:

```bash
./scripts/run_axvisor_dual_guest_qcz1_ai.sh \
  --net-mode tap \
  --evidence-dir /tmp/qc_demo_final_evidence \
  --timeout 180 \
  --linux-rt-samples 3000 \
  --linux-rt-period-ns 10000000 \
  --linux-stress-workers 2 \
  --linux-stress-seconds 0 \
  --linux-rt-cpu 0 \
  --linux-stress-cpu 1 \
  --linux-quiet
```

## 2:45-3:45 Evidence And Metrics

Narration:

实验结束后，我们使用分析脚本做二次校验。这里不是只看 QEMU 是否启动，而是检查完整链路：网络请求成功率、QCZ1 应答和错误路径、AI 端到端延迟、Linux 和 RTOS 两侧周期延迟、tcpdump 抓包与丢包计数，以及最终 PASS marker。已有长样本结果显示，在 0、1、2、4 个 Linux worker 压力下，普通 UDP 和 QCZ1 保持成功，AI 控制闭环保持通过。第二版还补充了当前 head 的 30000-sample TAP/tcpdump 证明；2-worker TAP 行和 4-worker TAP 行都保持 UDP 20/20、QCZ1 10/10、AI 10/10、tcpdump captured/dropped 88/0。其中 4-worker 是 2-vCPU Linux 的过载边界，只作为压力完成证据，不作为主要延迟改善结论。

Screen:

- run analyzer;
- show report, realtime CSV and stability summary.

Suggested commands:

```bash
./scripts/analyze_dual_guest_realtime.py /tmp/qc_demo_final_evidence --fail-on-missing
sed -n '1,180p' /tmp/qc_demo_final_evidence/realtime-report.md
sed -n '1,120p' results/task-one-before-after-hub-summary.md
sed -n '1,120p' results/task-one-current-head-long-tap-r30000-summary.md
sed -n '1,120p' results/task-one-current-head-long-tap4-r30000-summary.md
sed -n '1,140p' results/task-one-latestdev-isolated-p10ms-stability-3x-summary.md
column -s, -t results/realtime-comparison.csv | sed -n '1,10p'
sed -n '1,120p' results/stability/2026-07-27-stress2-3x/stability-summary.md
```

## 3:45-4:25 Realtime Baseline And Before/After Evidence

Narration:

实时性证据分两层。第一层是 Zephyr 原生 latency benchmark，它证明 RTOS 基线环境健康，并记录 47 项指标。第二层是 AxVisor-hosted 双 Guest 场景，它包含 VM exit、虚拟中断、vTimer、Linux 负载和跨 Guest 网络流量，更接近赛题目标。第二版材料补充了 pre-`#1770` 与当前分支的 10000-sample before/after hub 对比，以及当前 head 的 30000-sample hub/TAP 长压力证明。最终同步到最新 dev 后，又补充了 CPU0 周期探针、CPU1 压力线程的三轮稳定性验证，三轮均完整通过，UDP 60/60、QCZ1 30/30、AI 30/30。0-worker、1-worker、2-worker 是主要对比点；4-worker 是过载边界，用于说明压力下链路仍能完成。

Screen:

- show native baseline;
- show task-one score summary;
- show task-one second-version plan.

Suggested commands:

```bash
sed -n '1,140p' docs/realtime-evaluation.md
sed -n '1,160p' docs/task-one-score-summary.md
sed -n '1,120p' results/task-one-current-head-long-tap-r30000-summary.md
sed -n '1,120p' results/task-one-current-head-long-tap4-r30000-summary.md
sed -n '1,140p' results/task-one-latestdev-isolated-p10ms-stability-3x-summary.md
sed -n '1,220p' docs/task-one-second-version-plan.md
```

## 4:25-4:45 StarryOS Bonus Evidence

Narration:

除了标准 Linux Guest 路径，我们还准备了 StarryOS 加分项。StarryOS 作为非实时 Guest 运行同类 AI 控制程序，QEMU AArch64 串口输出 `REDCOLA_STARRY_QCZ1_PARITY_PASS`、`REDCOLA_STARRY_AI_CONTROL_PASS` 和 `REDCOLA_STARRY_AI_DONE`。这说明方案不只绑定传统 Linux，也可以迁移到组件化 OS/StarryOS 方向。该部分作为独立 bonus PR 提交，不混入主 AxVisor 交付。

Screen:

- show the StarryOS bonus PR or branch README.

Suggested command:

```bash
(git show origin/contest/starry-redcola-ai-bonus-clean-20260731:apps/starry/qemu/redcola-ai-control/README.md) | sed -n '1,120p'
```

Marker lines to capture:

```text
REDCOLA_STARRY_QCZ1_FRAME magic=QCZ1 version=1 type=CONTROL_SET
REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli=930 ai_score_milli=1000 sample_id=1
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0
REDCOLA_STARRY_AI_DONE
```

Boundary to say clearly: this is StarryOS non-RT guest bonus evidence with
QCZ1 frame-level parity and AI-control runtime markers. The full Linux/RTOS
network closed loop remains in the main AxVisor PR.

## 4:45-5:00 Closing

Narration:

总结一下，redcola 当前完成了 AxVisor 中 Linux/RTOS 双 Guest 部署，RTOS Guest 使用 Zephyr e1000 IP 网络，Linux 与 RTOS 之间使用 QCZ1 可靠 UDP 协议通信，Linux 侧 AI 推理驱动 RTOS 控制状态更新，并提供了原生 RTOS 基线、双 Guest 长样本实时性数据、压力和稳定性结果、StarryOS bonus 证据、复现脚本、核心 patch 拆分说明以及已验证的阶段性提交包。最终提交会在 2026-08-24 前使用最终录制视频重新生成 SHA256。

Screen:

- show final checklist and core patch review.

Suggested commands:

```bash
sed -n '1,160p' docs/final-submission-checklist.md
sed -n '1,140p' docs/core-patch-review.md
```

## Important Lines To Capture

Try to capture these strings in the video:

```text
result=PASS
QC_UDP_SUCCESSES=20
QC_QCZ1_RELIABLE_SUCCESSES=10
QC_QCZ1_RETRANSMITS=0
QC_AI_SUCCESSES=10
QC_AI_CONTROL_RESULT=PASS
QC_RTOS_PERIODIC_RESULT=PASS
QC_DUAL_GUEST_LINUX_INIT=PASS
TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS
tcpdump captured/dropped=88/0
tcpdump kernel drops=0
REDCOLA_STARRY_QCZ1_PARITY_PASS
REDCOLA_STARRY_AI_CONTROL_PASS
REDCOLA_STARRY_AI_DONE
```

## Final Video Acceptance Checklist

Before submitting the video, verify that the recording clearly shows:

| Scoring area | Must be visible in the video |
| --- | --- |
| System deployment | AxVisor starts Linux and Zephyr/RTOS guests in one run, and Linux reports `2` vCPUs. |
| IP communication | Linux/RTOS path uses IPv4/UDP and shows plain UDP `20/20 PASS`. |
| Application protocol | QCZ1 reliable UDP shows `10/10 PASS`, retransmit/duplicate-ACK counters or status validation. |
| AI closed loop | AI inference sends control output to RTOS and returns `QC_AI_CONTROL_RESULT=PASS`. |
| Realtime evidence | Linux and RTOS periodic probe summaries are shown, including p99/max or report output, plus the `30000`-sample long TAP row. |
| Packet capture | For final TAP video, tcpdump captured packets and kernel drops `0` are shown; if using the submitted long TAP proof, show captured/dropped `88/0`. |
| Baselines | Native Zephyr latency baseline and 0/1/2/4-worker stress table are briefly shown from docs/results. |
| StarryOS bonus | StarryOS QEMU output or validation file shows `REDCOLA_STARRY_QCZ1_PARITY_PASS`, `REDCOLA_STARRY_AI_CONTROL_PASS` and `REDCOLA_STARRY_AI_DONE`. |
| Reproducibility | Evidence directory, analyzer output and key docs are visible so the run is repeatable. |

If a live TAP run is not possible during recording, use the latest recorded TAP
evidence for the packet-capture segment and explicitly label any hub-mode run
as a rehearsal or fallback. Do not present hub mode as a replacement for
TAP/tcpdump evidence.
