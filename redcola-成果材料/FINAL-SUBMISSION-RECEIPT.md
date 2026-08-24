# redcola 最终成果验收回执

提交日期：2026-08-24

## 1. 私有仓库与成果目录

- 私有仓库：<https://github.com/qcl-kernel/tgoskits-redcola>
- 主交付 PR：<https://github.com/qcl-kernel/tgoskits-redcola/pull/1>
- 独立成果目录：`redcola-成果材料/`
- 主源码与测例：`os/axvisor/contest/quancheng2026/`
- 最终 StarryOS PR：<https://github.com/qcl-kernel/tgoskits-redcola/pull/3>

主交付与 StarryOS 最终分支均以官方最新 `rcore-os/tgoskits` `dev`
`3a3af51675c9811dafd842db644cf915084ca9fe` 为共同基点。最终推送前执行：

```text
git merge-base upstream/dev contest/axvisor-2026
3a3af51675c9811dafd842db644cf915084ca9fe

git merge-base upstream/dev contest/starry-redcola-ai-bonus-final-20260824
3a3af51675c9811dafd842db644cf915084ca9fe
```

## 2. 公开 PR 拆分

- AxVisor 核心支撑 PR：<https://github.com/rcore-os/tgoskits/pull/1770>，已合入官方 `dev`。
- StarryOS 实现 PR：<https://github.com/rcore-os/tgoskits/pull/1813>，独立提交并保留 AI 初审记录。
- 历史竞赛材料 PR #1703 已关闭；最终竞赛材料按主办方要求转入私有仓库，不作为核心代码合入入口。

## 3. 完整材料

- 设计、协议、网络拓扑、隔离、测试与复现文档：`docs/`
- Linux/RTOS、QCZ1、AI 闭环源码和自动化测例：主源码目录
- 5 分钟演示视频：`video/redcola-axvisor-demo.mp4`
- 演示 PPT 与配音稿：`presentation/`
- QEMU/TAP/实时性证据摘要：`evidence-summaries/`
- RK3588 实体开发板原始证据：`evidence-raw/redcola-board-evidence-20260824.tar.gz`
- 全目录哈希清单：`SHA256SUMS.txt`

视频为 300.067 秒、1920x1080，SHA256：

```text
909bdc9f39527404ac12cccd9515caaf255be649a0de8e454c8541e297201bba
```

实体板证据归档 SHA256：

```text
7af6beee3ef1ad2b041d25073a7df2a24e5ddca87d76d5e0bada46c0b5b6b974
```

## 4. 关键结果

- Linux/RTOS plain UDP：20/20 PASS
- QCZ1 可靠 UDP：10/10 PASS
- AI 控制闭环：10/10 PASS
- Linux guest：2 vCPU 启动通过
- TAP/tcpdump：88 packets captured，0 packets dropped by kernel
- 任务一当前分支长压力：30,000 个 1 ms 周期样本，全链路 PASS
- RK3588 原生 Linux 基线：900,000 cycles，0 histogram overflow
- StarryOS：AI 推理与 QCZ1 parity 标记通过

实体板结果用于补充物理平台实时性基线，不宣称 AxVisor 已在该 RK3588 板运行。
