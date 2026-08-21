# Task-One Evidence Summary

This latest exact private PR `#1` head proof was collected from:

```text
source_head=b706a02cdbf9e4688edc3def932ea4ae5159bbcd
evidence_root=/home/kali/qc-evidence/t1-headb706-full-hub-r30000-20260815_022916
net_mode=hub
linux_rt_samples=30000
linux_stress_workers=0,1,2,4
matrix_result=PASS
```

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| latestb706-hub-0w-r30000-20260815_022916 | `PASS` | `hub` | `0` | `2` | `80860 / 1372496 / 3525056` | `880011 / 2906144 / 14887408` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1755 / 2567` | `n/a/n/a` |
| latestb706-hub-1w-r30000-20260815_023052 | `PASS` | `hub` | `1` | `2` | `79733 / 1073280 / 10214304` | `941472 / 2946416 / 13479120` | `20/20` | `10/10` | `0` | `2` | `10/10` | `4268 / 26773` | `n/a/n/a` |
| latestb706-hub-2w-r30000-20260815_023225 | `PASS` | `hub` | `2` | `2` | `68059 / 820064 / 3563856` | `1145602 / 6140688 / 41388576` | `20/20` | `10/10` | `0` | `2` | `10/10` | `3299 / 9299` | `n/a/n/a` |
| latestb706-hub-4w-r30000-20260815_023400 | `PASS` | `hub` | `4` | `2` | `56586 / 931056 / 2066960` | `6957097 / 233632240 / 308771040` | `20/20` | `10/10` | `0` | `2` | `10/10` | `8600 / 53677` | `n/a/n/a` |

## Evidence Hashes

| Label | Evidence dir | Summary SHA256 | QEMU log SHA256 | Missing markers |
| --- | --- | --- | --- | --- |
| latestb706-hub-0w-r30000-20260815_022916 | `/home/kali/qc-evidence/t1-headb706-full-hub-r30000-20260815_022916/latestb706-hub-0w-r30000-20260815_022916` | `21aad3b4649d21c8975e378b189af52a10740201a8f85bd6513fbda58cc38f45` | `f6fba287905f4f424c57da455090d9018046e9f970c9a94f8e4b3380c31f271a` | `none` |
| latestb706-hub-1w-r30000-20260815_023052 | `/home/kali/qc-evidence/t1-headb706-full-hub-r30000-20260815_022916/latestb706-hub-1w-r30000-20260815_023052` | `bd1512ab638150c45d05ab699c35ccd88e6aa3aa9771856e1c5c8e05e1d8781e` | `852bba53a735e9a8571376d508ebd132004d992f2304e6c90d7711175daff3f5` | `none` |
| latestb706-hub-2w-r30000-20260815_023225 | `/home/kali/qc-evidence/t1-headb706-full-hub-r30000-20260815_022916/latestb706-hub-2w-r30000-20260815_023225` | `7583ac41fe77d372c206e6c32b30c5d4e51e86845621171bc979c06203ae90d4` | `f371bf2971e700167827a99dacab38ca12c3772403b7e567d057b88d06e96f9b` | `none` |
| latestb706-hub-4w-r30000-20260815_023400 | `/home/kali/qc-evidence/t1-headb706-full-hub-r30000-20260815_022916/latestb706-hub-4w-r30000-20260815_023400` | `571bc8ddf42ea5853c6397f6544b17e803d850acb058a6cd037d3e172f106596` | `7eec4438b7b9530cbfb98d57b0dabccf5f38ca8a4e15212a801edec576928e1d` | `none` |
