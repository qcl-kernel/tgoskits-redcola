# Latest-Dev CPU-Isolated Periodic Matrix

This matrix validates the Linux guest CPU-affinity path on official `dev`
`220af445bbfa2a360b96efc968e76b2383f5b658` plus the locally recorded PCI
`interrupt-map` passthrough-IRQ candidate. It is a same-head no-load versus
pressure comparison, not an AxVisor before/after claim.

The Linux guest has two vCPUs. The periodic probe is pinned to guest CPU 0;
both stress workers in the pressure row are pinned to guest CPU 1. Each Linux
row uses 3000 samples at a 10 ms period. The 10 ms period is used because nested
QEMU/TCG cannot sustain the 1 ms Linux workload without accumulating scheduler
backlog; the earlier 1 ms and long TAP rows remain available as stress-boundary
evidence.

| Workers | Result | Linux mean / p99 / max | UDP | QCZ1 | AI | AI e2e mean / max |
| ---: | --- | --- | --- | --- | --- | --- |
| 0 | `PASS` | `2.808 / 9.620 / 118.127 ms` | `20/20` | `10/10` | `10/10` | `7.865 / 13.209 ms` |
| 2 | `PASS` | `2.166 / 4.615 / 73.587 ms` | `20/20` | `10/10` | `10/10` | `8.165 / 14.554 ms` |

Both rows report Linux `2` vCPUs, QCZ1 retransmits `0`, duplicate ACKs `2`, and
all required Linux/RTOS communication and AI closed-loop markers. The pressure
row therefore demonstrates that isolating the periodic probe from the stress
workers preserves the full control chain under load. The lower pressure-row
latency is reported as observed and is not generalized beyond these two runs.

Raw evidence:

```text
/home/kali/qc-evidence/t1-latestdev220-isolated-p10ms-20260821
/home/kali/qc-evidence/t1-latestdev220-isolated-p10ms-20260821.tar.gz
archive SHA256: 17f300e8d14a445fda0d1b727dd0c5a332716576683ac61006bde5274bad1163
TASK_ONE_SECOND_VERSION_MATRIX=PASS
```
