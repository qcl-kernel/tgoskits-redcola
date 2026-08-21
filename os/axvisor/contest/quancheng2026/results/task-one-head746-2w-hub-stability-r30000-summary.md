# Task-One Head 746 2-Worker Hub Stability Summary

This summary records a three-run stability repeat on the private PR `#1` head:

```text
source_head=746042293ac61bc5cb894c6c470ae76fdc02674a
evidence_root=/home/kali/qc-evidence/t1-head746-2w-hub-stability-r30000-20260815_031511
net_mode=hub
linux_stress_workers=2
linux_rt_samples=30000
repeat_count=3
repeat_result=3/3 PASS
```

All three rows keep Linux at `2` vCPUs and keep the full mixed workload active:
Linux periodic probe, Zephyr RTOS periodic probe, plain UDP, QCZ1 reliable UDP
and AI control loop.

| Run | Result | Linux mean/p99/max ns | RTOS mean/p99/max ns | UDP | QCZ1 | AI | AI e2e mean/max us |
| ---:| --- | ---:| ---:| ---:| ---:| ---:| ---:|
| 1 | `PASS` | `1540933 / 17031408 / 46716464` | `72252 / 1015776 / 3080560` | `20/20` | `10/10` | `10/10` | `3057 / 5780` |
| 2 | `PASS` | `1321127 / 12056832 / 42801392` | `72798 / 1040304 / 2043904` | `20/20` | `10/10` | `10/10` | `3306 / 7981` |
| 3 | `PASS` | `1076660 / 5276112 / 38843504` | `70100 / 882896 / 2598624` | `20/20` | `10/10` | `10/10` | `2829 / 5000` |

QEMU log hashes:

```text
run1 qemu.log sha256=58eda90c01cd480d5e4be011ea60e07eb48efa8582feb6505f7fb3a491fb2852
run2 qemu.log sha256=0374c86d38b41ed9df156dbfaadd991786eef84a28010105217733551a6536bd
run3 qemu.log sha256=839e46fc8d5e9f17327b4be395436b1657fd61942d892d5dd4d814fcdb89d629
```

This is a repeatability proof for the 2-worker Linux-pressure case on the exact
submitted head after the analyzer was hardened against serial-log interleaving.
Because this run uses QEMU hub networking, tcpdump counters are `n/a`; the TAP
packet-capture proof remains recorded in the TAP summaries.
