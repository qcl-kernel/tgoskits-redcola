# Task-One Latest-Dev Long-Run Evidence

- Official `dev` base: `0340ed6bfa36cedd543d48f515e751ccc5a379bf`
- Linux guest: 2 vCPUs, periodic probe pinned to vCPU 0
- Pressure: 2 workers pinned to vCPU 1
- Periodic run: 30,000 samples at 1 ms
- Persistent evidence: `/home/kali/qc-evidence/t1-latestdev0340-long-hub-r30000-20260821`

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| latestdev0340-hub-2w-r30000-p1000000-20260821 | `PASS` | `hub` | `2` | `2` | `152776 / 2259632 / n/a` | `5692135 / 87544160 / 108110400` | `20/20` | `10/10` | `0` | `2` | `10/10` | `7222 / 12528` | `n/a/n/a` |

## Evidence Hashes

| Label | Evidence dir | Summary SHA256 | QEMU log SHA256 | Missing markers |
| --- | --- | --- | --- | --- |
| latestdev0340-hub-2w-r30000-p1000000-20260821 | `/home/kali/qc-evidence/t1-latestdev0340-long-hub-r30000-20260821/latest0340-hub-2w-r30000-p1000000-20260821_172057` | `748d1b50fc4039f7f962f50ef0de2eda9681934d319e04a03999dd51ef5cca4e` | `435b237caedf6eba51af62195888eb3e867dd31b99c8aef7cd531babfaabd08e` | `none` |

This run is the current-official-`dev` compatibility and long-pressure gate. The
separate TAP results remain the packet-capture evidence; hub mode here avoids
requiring privileged host networking while retaining the same guest binaries,
QCZ1 protocol, AI workload and vCPU affinity configuration.
