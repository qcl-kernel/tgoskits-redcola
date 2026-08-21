# Task-One Latest Head Long Hub Summary

This file records the 2026-08-15 long hub-mode task-one proof for private PR
`#1` head `35b65e4ba3707b235680bf382772ef9f0227c605`.

Persisted evidence root:

```text
/home/kali/qc-evidence/t1-head35b-hub-r30000-20260815_014301
```

The run keeps the full dual-guest communication and AI control loop active
while extending the Linux periodic probe to `30000` samples. It covers both
the normal 2-worker pressure row and a 4-worker overcommit boundary on a
2-vCPU Linux guest.

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| current-head35b-hub-2w-r30000-20260815_014300 | `PASS` | `hub` | `2` | `2` | `82099 / 1327104 / 4914320` | `1642979 / 23266016 / 70579920` | `20/20` | `10/10` | `0` | `2` | `10/10` | `5562 / 36520` | `n/a/n/a` |
| current-head35b-hub-4w-r30000-20260815_014437 | `PASS` | `hub` | `4` | `2` | `68206 / 1016480 / 2487776` | `7619184 / 200841712 / 223338912` | `20/20` | `10/10` | `0` | `2` | `10/10` | `3262 / 7140` | `n/a/n/a` |

## Evidence Hashes

| Label | Evidence dir | Summary SHA256 | QEMU log SHA256 | Missing markers |
| --- | --- | --- | --- | --- |
| current-head35b-hub-2w-r30000-20260815_014300 | `/home/kali/qc-evidence/t1-head35b-hub-r30000-20260815_014301/current-head35b-hub-2w-r30000-20260815_014300` | `9af0547ad674b4ac6b1024e1aded5232896353628952577f57cadededbe1149b` | `ac8c2de79e3f8931f0c6e2b3f035b9022ddc2e599a82a289ca78f97ea5f31c78` | `none` |
| current-head35b-hub-4w-r30000-20260815_014437 | `/home/kali/qc-evidence/t1-head35b-hub-r30000-20260815_014301/current-head35b-hub-4w-r30000-20260815_014437` | `27d0c9509f08dfbc0c039fa2a0a5789ec3d789ddd0a10595115fdda5491d140a` | `563997c79b945cf840d2dd862059cdf8a3daf32cf4b282684b640c1fa3fabad7` | `none` |
