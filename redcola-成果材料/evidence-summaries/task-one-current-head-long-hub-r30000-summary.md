# Task-One Evidence Summary

Persisted evidence root:

```text
/home/kali/qc-evidence/t1-current-head-long-hub-2w-r30000-20260814_161251
/home/kali/qc-evidence/t1-head8984-long-hub-2w-r30000-20260814_173833
```

The latest current-head long run was collected from private PR `#1` runtime
source head `8984bd23dbb27b091aaa120020f0ac9eff59226d`. It keeps the full
dual-guest communication and AI loop active while extending the Linux periodic
probe to `30000` samples under `2` Linux stress workers. The older
`aa7a8c97fd3291769119c47f3623c70ca7c4ce31` row is retained above as historical
continuity, but the table below records the newest PR-head proof.

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| head8984-hub-2w-r30000-20260814_173833 | `PASS` | `hub` | `2` | `2` | `51404 / 685872 / 2001840` | `1258737 / 9481712 / 37442704` | `20/20` | `10/10` | `0` | `2` | `10/10` | `3441 / 5529` | `n/a/n/a` |

## Evidence Hashes

| Label | Evidence dir | Summary SHA256 | QEMU log SHA256 | Missing markers |
| --- | --- | --- | --- | --- |
| head8984-hub-2w-r30000-20260814_173833 | `/home/kali/qc-evidence/t1-head8984-long-hub-2w-r30000-20260814_173833/head8984-hub-2w-r30000-20260814_173833` | `e21a6caaaddf9ea2540f705bb668226c8a9c16acdbb7e55a5adf237b386a78e7` | `9c7ce4a55868d004fc964ff8f4af1873fda20bb8f483fdccbca955a9a6453869` | `none` |
