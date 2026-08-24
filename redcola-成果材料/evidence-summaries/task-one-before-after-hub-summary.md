# Task-One Before/After Hub Summary

This file is the compact result table for the 2026-08-21 task-one realtime
follow-up. It summarizes the pre-`#1770` baseline and the current redcola
runtime evidence in the same dual-guest hub-mode shape.

Hub mode does not create host TAP devices or tcpdump captures, so packet
capture counters are `n/a` in this table. The TAP/tcpdump matrix remains the
next privileged runtime gate.

## Summary Table

| Role | Source | Workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | AI mean/max us | Evidence root |
| --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| --- |
| before | `bb562428c` | `0` | `2` | `80937 / 1322960 / 8054832` | `794758 / 2166768 / 7016816` | `20/20` | `10/10` | `2416 / 6551` | `/home/kali/qc-evidence/t1-before1770-hub-r10000-20260814_011825` |
| after | `760e253e` | `0` | `2` | `50391 / 761312 / 1773024` | `948824 / 5220048 / 27038432` | `20/20` | `10/10` | `2322 / 3769` | `/home/kali/qc-evidence/t1-head760-hub-r10000-20260814_010458` |
| before | `bb562428c` | `1` | `2` | `74750 / 1123872 / 5085392` | `875693 / 4034768 / 25984544` | `20/20` | `10/10` | `3622 / 19762` | `/home/kali/qc-evidence/t1w1-hub-before-after-20260814_030333` |
| after | `aa9657ad3` | `1` | `2` | `58311 / 782080 / 4966544` | `820334 / 2898192 / 13186032` | `20/20` | `10/10` | `2405 / 5829` | `/home/kali/qc-evidence/t1w1-hub-before-after-20260814_030333` |
| before | `bb562428c` | `2` | `2` | `89005 / 1453600 / 4347168` | `958411 / 4704416 / 11699344` | `20/20` | `10/10` | `3406 / 7781` | `/home/kali/qc-evidence/t1-before1770-hub-r10000-20260814_011825` |
| after | `760e253e` | `2` | `2` | `72076 / 993408 / 6933952` | `1151354 / 7175200 / 39208656` | `20/20` | `10/10` | `1902 / 4202` | `/home/kali/qc-evidence/t1-head760-hub-r10000-20260814_010458` |
| before | `bb562428c` | `4` | `2` | `68513 / 1067280 / 6420496` | `3350749 / 46688208 / 69122784` | `20/20` | `10/10` | `5510 / 25233` | `/home/kali/qc-evidence/t1w4-hub-before-after-recovered-20260814_020210` |
| after | `6dddec6dc` | `4` | `2` | `75941 / 1506224 / 6999824` | `343967173 / 1099832160 / 1118971392` | `20/20` | `10/10` | `5475 / 18573` | `/home/kali/qc-evidence/t1w4-hub-before-after-recovered-20260814_020210` |

## Reviewer Notes

- 0 workers: RTOS p99/max improves from `1.323 ms / 8.055 ms` to
  `0.761 ms / 1.773 ms`.
- 1 worker: RTOS p99/max improves from `1.124 ms / 5.085 ms` to
  `0.782 ms / 4.967 ms`; Linux p99/max also improves from
  `4.035 ms / 25.985 ms` to `2.898 ms / 13.186 ms`.
- 2 workers: RTOS p99 improves from `1.454 ms` to `0.993 ms`; the after-side
  RTOS max has a larger outlier (`4.347 ms` to `6.934 ms`).
- 4 workers: this row is an overcommit boundary on a 2-vCPU Linux guest. It is
  kept as stability pressure evidence, not as a latency-improvement claim.
- Every row keeps Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, AI `10/10`,
  duplicate ACK coverage and no missing final markers.
