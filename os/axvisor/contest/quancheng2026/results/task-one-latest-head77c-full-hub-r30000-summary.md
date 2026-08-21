# Task-One Latest Head Full Hub Summary

This file records the 2026-08-15 full long hub-mode task-one proof for private
PR `#1` head `77c91d57642c185da7e6a6f8b408e680695de2fb`.

Persisted evidence root:

```text
/home/kali/qc-evidence/t1-head77c-full-hub-r30000-20260815_020153
```

The run keeps the full dual-guest communication and AI control loop active
while extending the Linux periodic probe to `30000` samples. It covers the
0-worker empty baseline, 1-worker light pressure, 2-worker normal pressure and
4-worker overcommit boundary on a 2-vCPU Linux guest.

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| latest77c-hub-0w-r30000-20260815_020152 | `PASS` | `hub` | `0` | `2` | `62336 / 855488 / 5211696` | `816973 / 2515344 / 13780608` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1524 / 2234` | `n/a/n/a` |
| latest77c-hub-1w-r30000-20260815_020323 | `PASS` | `hub` | `1` | `2` | `78957 / 1392224 / 3034928` | `796475 / 2715600 / 17826032` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1951 / 3282` | `n/a/n/a` |
| latest77c-hub-2w-r30000-20260815_020452 | `PASS` | `hub` | `2` | `2` | `81453 / 1156672 / 4598080` | `1277934 / 11914832 / 42321536` | `20/20` | `10/10` | `0` | `2` | `10/10` | `2620 / 5261` | `n/a/n/a` |
| latest77c-hub-4w-r30000-20260815_020627 | `PASS` | `hub` | `4` | `2` | `75499 / 1344800 / 2948256` | `2479969 / 13820912 / 34060800` | `20/20` | `10/10` | `0` | `2` | `10/10` | `8387 / 51938` | `n/a/n/a` |

## Evidence Hashes

| Label | Evidence dir | Summary SHA256 | QEMU log SHA256 | Missing markers |
| --- | --- | --- | --- | --- |
| latest77c-hub-0w-r30000-20260815_020152 | `/home/kali/qc-evidence/t1-head77c-full-hub-r30000-20260815_020153/latest77c-hub-0w-r30000-20260815_020152` | `8e4de85fad2ec72c16daed90b6730da2327c0e7fb43a709fe826684b77d3680f` | `de68f4373e207dbb065ddce99514b5bf6ca8a28f2fabf3063b8bd0d38e3c3685` | `none` |
| latest77c-hub-1w-r30000-20260815_020323 | `/home/kali/qc-evidence/t1-head77c-full-hub-r30000-20260815_020153/latest77c-hub-1w-r30000-20260815_020323` | `8f5d07fe9193d2d4ea20d2645582ca9b6df69645b467d83d343490f22a7ff38f` | `785486c3b9ba23aae5ebcfe686816411cb40b0e1bdc2227306f88efc2313de36` | `none` |
| latest77c-hub-2w-r30000-20260815_020452 | `/home/kali/qc-evidence/t1-head77c-full-hub-r30000-20260815_020153/latest77c-hub-2w-r30000-20260815_020452` | `81cd4340c04e4b5ca291f3119b91ec643aca70e41e16377c21bd35b6d6c58a2d` | `692ee89e7d0755a6453aba4141cdffff762e49ad550cc5692f0851cd81e2dcab` | `none` |
| latest77c-hub-4w-r30000-20260815_020627 | `/home/kali/qc-evidence/t1-head77c-full-hub-r30000-20260815_020153/latest77c-hub-4w-r30000-20260815_020627` | `481eb043bff218f4457e7562c2a8abe62c16e9b2a8be8876f18bc942d3f4ae2b` | `6c2e0827d64eae5e452d8d485820f977280bde7b9b850269bedee22e46b6bd65` | `none` |
