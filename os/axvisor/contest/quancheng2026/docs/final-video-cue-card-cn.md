# Final Video Cue Card (Chinese)

这份提示卡用于最终 5 分钟演示视频录制。它比
`docs/demo-video-script.md` 更短，适合录屏时放在右侧终端照着讲。

## 录制前确认

```text
主交付 PR: https://github.com/qcl-kernel/tgoskits-redcola/pull/1
StarryOS 加分 PR: https://github.com/qcl-kernel/tgoskits-redcola/pull/2
主分支: contest/axvisor-2026
不要录到密码、token、SSH key、个人聊天窗口
如果录 TAP/tcpdump，先在录屏前完成 sudo -v
```

推荐录制顺序：先打开两个终端，左边跑实验，右边显示文档和结果。

## 评委必须看清的 5 个画面

录制时每个画面至少停 3 秒，不要一闪而过：

| 顺序 | 画面 | 对应得分点 |
| --- | --- | --- |
| 1 | 私有仓库、PR `#1`、PR `#2`、主分支或 source head | 工程完整性、提交边界 |
| 2 | Linux/RTOS IP、UDP `4242`、QCZ1 字段说明 | 任务二网络通信 |
| 3 | live run 的 `UDP 20/20`、`QCZ1 10/10`、`AI 10/10`、`result=PASS` | 任务二/三闭环 |
| 4 | 任务一 p99/max、before/after、30000-sample TAP/tcpdump、`88/0` | 任务一实时性 |
| 5 | StarryOS `PARITY_PASS`、`AI_CONTROL_PASS`、最终包 `VERIFY=PASS` | 加分项、工程完整性 |

## 话术红线

必须说清楚：

```text
4-worker 是 2-vCPU Linux guest 的过载边界证据，用来证明重压下链路仍能完成，
不是主要延迟改善结论。

StarryOS 是独立加分 PR，用来证明非实时侧向 StarryOS 迁移的可行性；
主 PR 的完整 Linux/RTOS 网络闭环仍然是主要交付。

TAP/tcpdump 证据以已提交的 before/after 矩阵和当前 head 长压力证明为准；
如果现场 live run 用 hub fallback，要明确说这是现场演示 fallback。
```

不要说：

```text
不要说“三个任务 100% 完成”。
不要说“4-worker 证明实时性全面变好”。
不要说“StarryOS 已完整替代 Linux 完成全部三任务”。
不要说 GitHub mirror CI 红叉代表实验失败；它只是私有组织 CI/runner 限制，不是 runtime proof。
```

## 0:00-0:30 开场

照读：

```text
大家好，我们是 redcola 队。本演示展示一个基于 AxVisor 的混合系统：
在同一个 QEMU AArch64 平台中同时运行 Linux Guest 和 Zephyr RTOS Guest。
Linux 侧负责 AI 推理和非实时控制逻辑，RTOS 侧负责周期任务和控制状态更新。
两个 Guest 之间通过 IPv4/UDP 网络和 QCZ1 应用层协议通信，形成 AI 输入、
模型推理、网络发送、RTOS 控制输出、状态回传的完整闭环。
```

右侧显示：

```bash
sed -n '1,90p' docs/evidence-index.md
sed -n '1,90p' docs/scorecard-traceability.md
```

## 0:30-1:10 三个任务怎么对应

照读：

```text
任务一对应实时性验证。我们记录了 AxVisor 定时器和中断路径的核心支撑 PR，
并用 Linux 2 vCPU 加 Zephyr RTOS 的双 Guest 场景做周期延迟、压力和长样本测试。
任务二对应客户机间通信。主数据通道是 IPv4/UDP，不使用共享内存或 HyperCall
作为主通道；QCZ1 协议包含版本、类型、长度、序号、时间戳、状态码和校验字段。
任务三对应 AI 控制闭环。Linux 侧 AI 输出通过 QCZ1 发给 RTOS，RTOS 更新控制状态
并回传 ACK 和 STATUS。
```

右侧显示：

```bash
sed -n '1,100p' docs/network-topology.md
sed -n '1,120p' docs/protocol.md
```

## 1:10-2:45 现场运行

左侧运行：

```bash
./scripts/run_final_demo_recording.sh
```

脚本内部使用以下固定配置，便于评审复核：

```bash
./scripts/run_axvisor_dual_guest_qcz1_ai.sh \
  --net-mode tap \
  --evidence-dir "/tmp/redcola-final-tap-<timestamp>" \
  --timeout 180 \
  --linux-rt-samples 3000 \
  --linux-rt-period-ns 10000000 \
  --linux-stress-workers 2 \
  --linux-stress-seconds 0 \
  --linux-rt-cpu 0 \
  --linux-stress-cpu 1 \
  --linux-quiet
```

照读：

```text
现在运行完整复现实验。这个脚本会启动 AxVisor 双 Guest，等待 Linux Guest
和 Zephyr RTOS Guest 完成启动，然后依次验证普通 UDP、QCZ1 可靠 UDP、
AI 控制闭环、Linux 周期探针、RTOS 周期探针和最终 PASS marker。只有这些
条件全部满足，脚本才会输出 result=PASS。
```

重点让画面停一下，显示这些 marker：

```text
QC_DUAL_GUEST_LINUX_INIT=PASS
QC_UDP_SUCCESSES=20
QC_QCZ1_RELIABLE_SUCCESSES=10
QC_QCZ1_RETRANSMITS=0
QC_AI_SUCCESSES=10
QC_AI_CONTROL_RESULT=PASS
QC_RTOS_PERIODIC_RESULT=PASS
result=PASS
TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS
tcpdump captured/dropped=88/0
packets captured
0 packets dropped by kernel
```

## 2:45-3:45 分析结果

左侧运行：

```bash
./scripts/analyze_dual_guest_realtime.py "${EVIDENCE_DIR}" --fail-on-missing
sed -n '1,180p' "${EVIDENCE_DIR}/realtime-report.md"
```

照读：

```text
实验结束后再用分析脚本做二次校验。这里不是只看 QEMU 是否启动，而是检查
完整链路：UDP 成功率、QCZ1 ACK 和 STATUS、重传次数、AI 端到端延迟、
Linux 和 RTOS 周期延迟、tcpdump 抓包和丢包计数。当前长 TAP 结果中，
2-worker 和 4-worker 两组都保持普通 UDP 20/20、QCZ1 10/10、AI 控制
10/10，tcpdump captured/dropped 都是 88/0。2-worker AI 端到端 mean/max
是 2501/5014 us，4-worker AI 端到端 mean/max 是 5277/15431 us。
```

右侧显示：

```bash
sed -n '1,120p' results/task-one-second-version-summary.md
sed -n '1,140p' results/task-one-latestdev-isolated-p10ms-stability-3x-summary.md
sed -n '1,120p' results/task-one-current-head-long-tap4-r30000-summary.md
```

## 3:45-4:25 实时性对比

照读：

```text
实时性证据分为两层。第一层是 Zephyr 原生 latency benchmark，作为 RTOS
基线环境健康检查。第二层是 AxVisor 双 Guest 场景，它包含 VM exit、虚拟中断、
vTimer、Linux 负载和跨 Guest 网络流量，更接近赛题目标。第二版补充了
pre-1770 和当前分支的 10000 样本 before/after 表，以及当前 head 的
30000 样本长压力 TAP/tcpdump 证明。2-worker 与 4-worker 长 TAP 证明都报告
TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS，并且抓包 captured/dropped 是 88/0。
最新 dev 的 CPU 隔离稳定性复测也完成 3/3 PASS，累计 UDP 60/60、QCZ1
30/30、AI 30/30，QCZ1 重传为 0。
```

右侧显示：

```bash
sed -n '1,160p' docs/task-one-30-point-checklist.md
sed -n '1,120p' results/task-one-current-head-long-tap-r30000-summary.md
sed -n '1,120p' results/task-one-current-head-long-tap4-r30000-summary.md
sed -n '1,140p' results/task-one-latestdev-isolated-p10ms-stability-3x-summary.md
```

## 4:25-4:45 StarryOS 加分

照读：

```text
除了标准 Linux Guest 路径，我们还提交了独立的 StarryOS 加分 PR。它在
StarryOS QEMU Guest 内运行同类确定性 AI 控制程序，并输出 QCZ1 frame parity
和 AI_CONTROL_PASS marker。这个部分用于证明非实时侧可以向组件化 OS /
StarryOS 方向迁移；主 Linux/RTOS 网络闭环仍由主 PR 提供。
```

右侧显示：

```bash
(git show qcl/contest/starry-redcola-ai-bonus-clean-20260731:apps/starry/qemu/redcola-ai-control/VALIDATION.md 2>/dev/null || \
 git show origin/contest/starry-redcola-ai-bonus-clean-20260731:apps/starry/qemu/redcola-ai-control/VALIDATION.md) | sed -n '1,160p'
```

必须看到：

```text
REDCOLA_STARRY_QCZ1_PARITY_PASS
REDCOLA_STARRY_AI_CONTROL_PASS
REDCOLA_STARRY_AI_DONE
```

## 4:45-5:00 收尾

照读：

```text
总结一下，redcola 当前提交包含 AxVisor 双 Guest 部署、Linux/RTOS IPv4/UDP
通信、QCZ1 可靠协议、AI 控制闭环、实时性 before/after 和长样本压力证据、
原生 Zephyr 基线、StarryOS 加分材料、复现脚本、测试文档，以及已验证的
66 文件候选最终包，并完成原目录和 fresh-unzip 双重校验。
代码和文档已提交到 qcl-kernel/tgoskits-redcola 私有仓库。
```

右侧显示：

```bash
sed -n '1,140p' docs/final-submission-checklist.md
sed -n '1,140p' docs/final-package.md
```

## 录完后

1. 保存视频为 `redcola-axvisor-demo.mp4`。
2. 用 `scripts/build_final_submission_package.sh` 重新打最终包。
3. 用 `scripts/verify_final_submission_package.py --require-video --require-starry`
   验证最终包。
4. 只提交验证通过的 zip 和对应 SHA256。
