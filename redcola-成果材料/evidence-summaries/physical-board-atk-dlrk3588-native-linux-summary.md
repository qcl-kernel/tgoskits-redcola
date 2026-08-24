# ATK-DLRK3588 Native Linux Cyclictest Summary

## Scope

This is a physical-board **native Linux baseline**, not an AxVisor-on-RK3588 result.
The board is an ALIENTEK ATK-DLRK3588B V1.1 (RK3588, 8 GiB) running its
factory Buildroot image and Linux 5.10.160. The current tgoskits supported-board
list does not include this exact board. AxVisor mixed-guest results remain the
separate version-pinned QEMU evidence; the native Zephyr baseline also remains separate.

## Method

- `cyclictest` 2.20, `SCHED_FIFO` priority 95, 1 ms interval.
- Measurement thread pinned to CPU7; cyclictest main thread pinned to CPU6.
- 300,000 cycles per scenario (approximately five minutes), 900,000 cycles total.
- Idle: no synthetic stress workload.
- Isolated stress: stress workers on CPUs 0-6 while cyclictest remains on CPU7.
- Full stress: stress workers cover CPUs 0-7, including the measurement CPU.
- Percentiles use the deterministic nearest-rank definition over the JSON histogram.
- All three runs returned zero and the histogram sample count equals the cycle count.

## Results

| Scenario | Cycles | Min us | Avg us | P50 | P90 | P99 | P99.9 | P99.99 | P99.999 | Max us | >50 us ppm | >100 us ppm | >500 us ppm | >1000 us ppm |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Idle | 300000 | 1 | 7.41 | 8 | 10 | 17 | 20 | 38 | 50 | 95 | 10 | 0 | 0 | 0 |
| Isolated stress | 300000 | 1 | 2.4 | 2 | 3 | 8 | 15 | 30 | 62 | 76 | 23.333333 | 0 | 0 | 0 |
| Full stress | 300000 | 1 | 9.3 | 9 | 18 | 26 | 30 | 41 | 1068 | 1338 | 76.666667 | 73.333333 | 66.666667 | 13.333333 |

## Interpretation

- Full stress raised the maximum from 95 us to 1338 us (14.08x) and the average by 25.5%.
- Keeping stress off CPU7 reduced the maximum by 20.0% and the average by 67.6% relative to idle in this run.
- The isolated result is consistent with CPU affinity reducing contention, but the
  CPU6/CPU7 shared frequency policy and other platform effects prevent attributing
  the improvement to affinity alone.
- Full stress produced 4 samples above 1000 us (13.333333 ppm); idle and isolated stress produced none.
- The board clock was not initialized and reported 1970. Evidence directory dates
  are host-side collection labels rather than trusted board wall-clock timestamps.

## Reproduction

Regenerate this summary from the committed JSON files:

```bash
python3 scripts/analyze_physical_board_cyclictest.py \
  results/physical-board-atk-dlrk3588-native-linux \
  --csv-output results/physical-board-atk-dlrk3588-native-linux-summary.csv \
  --markdown-output results/physical-board-atk-dlrk3588-native-linux-summary.md
```
