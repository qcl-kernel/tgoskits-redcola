# Task-One TAP Before/After Summary

Evidence root:

```text
/home/kali/qc-evidence/t1-before-after-tap-fixed-114047
```

Wrapper result:

```text
TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS
```

| Phase | Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| after | after-tap-0w-r10000-20260814_114047 | `PASS` | `tap` | `0` | `2` | `83166 / 1290544 / 9349568` | `786370 / 2141264 / 14366752` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1808 / 3916` | `88/0` |
| after | after-tap-2w-r10000-20260814_114224 | `PASS` | `tap` | `2` | `2` | `72137 / 927216 / 9913056` | `949349 / 5177888 / 29571664` | `20/20` | `10/10` | `0` | `2` | `10/10` | `4179 / 17642` | `88/0` |
| before | before-tap-0w-r10000-20260814_114342 | `PASS` | `tap` | `0` | `2` | `51834 / 791120 / 3671568` | `863998 / 2761120 / 13642256` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1789 / 2090` | `88/0` |
| before | before-tap-2w-r10000-20260814_115908 | `PASS` | `tap` | `2` | `2` | `54287 / 1273216 / 3565712` | `1259651 / 13018080 / 41490032` | `20/20` | `10/10` | `0` | `2` | `10/10` | `3459 / 9056` | `88/0` |

Summary file hashes:

```text
cf4df402cb0f3c2b54b84821a6a129fd3426199d9a72ed7c50a5713c8db2d0a1  after/task-one-second-version-summary.csv
6e909dfdc019e7304a1117571736ae8531308f92fefe92f9ac1c0a8fed64e67a  after/task-one-second-version-summary.md
1ebf5e5570a00f688dc14c90a9e22aaaacf97d46a1349ff20344f2011b71e187  before/task-one-second-version-summary.csv
aa69856d421dcb997bfd56f5ecf8254f8fe1faf7d102dfdb62a04ca276a29b62  before/task-one-second-version-summary.md
```

Interpretation:

- The same 0-worker and 2-worker before/after shape now has TAP/tcpdump
  packet-capture counters.
- All four rows keep Linux `2` vCPUs, plain UDP `20/20`, QCZ1 `10/10`,
  QCZ1 retransmits `0`, AI `10/10`, and tcpdump kernel drops `0`.
- The after 2-worker row gives the strongest TAP RTOS p99 value in this
  matrix: `927216 ns`, while keeping the full communication and AI loop alive.
