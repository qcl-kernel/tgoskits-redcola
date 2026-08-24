# Physical-Board Native Linux Baseline

## Claim Boundary

This evidence is a native-Linux pressure baseline collected on an
ATK-DLRK3588B V1.1 board. It is not AxVisor running on RK3588, it is not a
Linux/RTOS mixed-guest result, and it does not replace the version-pinned QEMU
evidence. The exact board is outside the current tgoskits supported-board list.

## Platform

| Item | Value |
| --- | --- |
| Board | ALIENTEK ATK-DLRK3588B V1.1 |
| SoC | Rockchip RK3588 |
| CPU/RAM | 8 AArch64 CPUs / 7.7 GiB |
| OS | Buildroot 2021.11 native Linux |
| Kernel | Linux 5.10.160, `CONFIG_PREEMPT_VOLUNTARY=y`, `CONFIG_HZ=300` |
| Tools | cyclictest 2.20, stress-ng 0.13.01 |

## Method

`cyclictest` ran with FIFO priority 95, a 1 ms interval, the measurement
thread pinned to CPU 7, and the main thread pinned to CPU 6. Each scenario ran
for 300,000 cycles, for 900,000 measured cycles in total. All three histograms
reported zero overflows and every run returned exit status zero.

The scenarios were:

- Idle: no explicit stress workload.
- Isolated stress: stress workers constrained away from the measurement CPU.
- Full stress: CPU pressure allowed across the full system.

## Results

| Scenario | Cycles | Min (us) | Avg (us) | p99 (us) | p99.9 (us) | Max (us) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Idle | 300000 | 1 | 7.41 | 17 | 20 | 95 |
| Isolated stress | 300000 | 1 | 2.40 | 8 | 15 | 76 |
| Full stress | 300000 | 1 | 9.30 | 26 | 30 | 1338 |

Under full-system pressure, the maximum latency was 14.08 times the idle
maximum and the average latency increased by 25.5 percent. The isolated-stress
run had lower average and maximum values than the idle run. That improvement is
reported as an observed result, not as a universal isolation guarantee, because
frequency policy, workload placement, and background activity also affect it.

## Evidence And Reproduction

- Raw JSON and platform records:
  `results/physical-board-atk-dlrk3588-native-linux/`
- Machine-readable summary:
  `results/physical-board-atk-dlrk3588-native-linux-summary.csv`
- Human-readable analysis:
  `results/physical-board-atk-dlrk3588-native-linux-summary.md`
- Archive digest:
  `results/physical-board-atk-dlrk3588-native-linux-archive.sha256`
- Analyzer:
  `scripts/analyze_physical_board_cyclictest.py`

Recreate the checked-in summaries with:

```bash
python3 scripts/analyze_physical_board_cyclictest.py \
  results/physical-board-atk-dlrk3588-native-linux \
  --csv-output results/physical-board-atk-dlrk3588-native-linux-summary.csv \
  --markdown-output results/physical-board-atk-dlrk3588-native-linux-summary.md
```

The original archive SHA-256 is
`7af6beee3ef1ad2b041d25073a7df2a24e5ddca87d76d5e0bada46c0b5b6b974`.

## Limitations

- The board RTC was unset, so the captured files show a 1970 device timestamp;
  the `20260824` label records the host-side collection date.
- AxVisor and an RTOS were not deployed on this exact board in this evidence.
- The result is a physical-platform Linux pressure reference for interpreting
  the virtualized experiments, not a certified hard-real-time claim.
