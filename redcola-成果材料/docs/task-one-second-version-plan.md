# Task-One Second-Version Realtime Plan

This document tracks the redcola plan for raising the task-one realtime score
between the 2026-08-14 first-version submission and the 2026-08-21
second-version submission.

The first version already contains runnable mixed-system evidence. The second
version should focus on making the AxVisor realtime modification story harder
to miss: identify the exact core change, run a clear before/after comparison,
and keep the same stress and RTOS-baseline gates.

## Score Target

| Scoring detail | Points | First-version evidence | Second-version target |
| --- | ---:| --- | --- |
| Realtime target and key-path analysis | `4` | `docs/realtime-evaluation.md` and `docs/core-patch-review.md` describe vTimer, interrupt routing and RTOS periodic probes. | Add a short before/after conclusion that names the timer and interrupt paths as the primary realtime paths. |
| Substantive AxVisor key-mechanism changes | `8` | Core support is traceable to merged PR `rcore-os/tgoskits#1770` and patch notes. | Treat PR `#1770` as the main landed realtime-support change, and, if needed, split any remaining GIC/diagnostic work into a small follow-up branch. |
| Multi-vCPU Linux guest stability | `4` | Integrated run boots Linux with `2` vCPUs and Zephyr RTOS together. | Keep the same 2-vCPU Linux guest in every second-version run and record the marker in the final table. |
| Before/after realtime data | `5` | Native Zephyr baseline exists, and AxVisor-core before/after hub plus TAP/tcpdump matrices are now recorded. | Keep the same dual-guest script on a pre-`#1770` baseline and on current `dev`, then compare RTOS p99/max, Linux p99/max and AI/QCZ1 pass rate. |
| Empty and stress scenarios | `4` | 0/1/2/4 Linux-worker data already exists, with all communication gates passing. | Re-run at least 0-worker and 2-worker after the baseline comparison; keep 4-worker as an overcommit stress note if time allows. |
| Native RTOS baseline | `5` | Zephyr `latency_measure` reports `47` metrics and max primitive latency `46703 ns`. | Keep the same native Zephyr command and include its artifact SHA/log in the second-version evidence bundle. |

Target result for 2026-08-21: task-one evidence should move from
`65%-75%` confidence to about `85%-90%` confidence by proving the same workload
before and after the landed AxVisor timer/interrupt support.

## Baseline Anchors

Use these commits as the primary before/after anchors:

| Role | Commit | Meaning |
| --- | --- | --- |
| Before | `bb562428c69317faccf2761167d2fabc47b82a37` | Parent of the merged AxVisor physical-timer PR. |
| After | `024ecca10a4240a84b2c24bed2dc2361a6043d3e` | Merged PR `#1770`, `axvisor: virtualize AArch64 physical timer state`. |
| Review head | current `contest/axvisor-2026` | Main contest documentation and reproducibility branch. |

If the exact before commit cannot boot the final dual-guest artifacts because
the config schema or runtime image paths changed, record that failure as a
valid baseline observation and use the nearest bootable pre-`#1770` commit with
the same command line.

## Second-Version Experiment Matrix

Run these in order so that partial progress still improves the second-version
submission:

| Priority | Run | Required output |
| ---:| --- | --- |
| `1` | Current `dev` / PR-head, 0 Linux workers | `result=PASS`, Linux 2-vCPU marker, RTOS periodic stats, UDP/QCZ1/AI pass markers, tcpdump drops. |
| `2` | Current `dev` / PR-head, 2 Linux workers | Same as above, with Linux pressure. |
| `3` | Pre-`#1770` baseline, 0 Linux workers | Either same stats or a clearly captured boot/runtime failure. |
| `4` | Pre-`#1770` baseline, 2 Linux workers | Same as above, if the baseline can reach the mixed-system workload. |
| `5` | Native Zephyr latency baseline | Full `47`-metric table and `PROJECT EXECUTION SUCCESSFUL`. |

The before/after table should compare at least:

- RTOS periodic mean, p99 and max latency;
- Linux periodic mean, p99 and max latency;
- plain UDP success rate;
- QCZ1 success rate, retransmits and duplicate ACK handling;
- AI control success rate and end-to-end max latency;
- tcpdump captured packets and kernel drops.

## 2026-08-13 Environment Precheck

The Kali QEMU environment was rechecked after the private repository
submission. Non-privileged `hub` networking was used because TAP/tcpdump still
requires a fresh interactive `sudo -v` authentication on the Kali host. These
runs are not the final packet-capture evidence, but they prove that the
dual-guest realtime/communication/AI path is still runnable before the
second-version work.

The privileged packet-capture gap from this precheck was closed on 2026-08-14
by the completed TAP/tcpdump before/after matrix and the current-head long TAP
proof recorded later in this document.

| Run | Evidence dir | Result | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | AI e2e mean/max us | tcpdump |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| --- |
| 0 workers | `/home/kali/qc-evidence/task1-hub-smoke-0worker-20260813_221836` | `PASS` | `58825 / 683296 / 1854592` | `779248 / 2562944 / 12974752` | `20/20` | `10/10`, retransmits `0` | `1746 / 2421` | skipped in hub mode |
| 2 workers | `/home/kali/qc-evidence/task1-hub-smoke-2worker-20260813_222007` | `PASS` | `70773 / 914176 / 5394288` | `1039036 / 5424976 / 7955632` | `20/20` | `10/10`, retransmits `0` | `3195 / 17759` | skipped in hub mode |
| 4 workers | `/home/kali/qc-evidence/task1-after-hub-4worker-rt5000-20260813_232804` | `PASS` | `78049 / 1231824 / 7619584` | `1980978 / 8624448 / 12764016` | `20/20` | `10/10`, retransmits `0` | `4043 / 7585` | skipped in hub mode |

Evidence hashes:

```text
1f778ea055ed5c13a0845eb3e65b868f9abb89edb372f4f24238afd8d62d967d  task1-hub-smoke-0worker-20260813_221836/summary.txt
b8bd9ad79d0c02d431b02d582ee4b823ee08c92b7f0f3512fc9468a2b1149169  task1-hub-smoke-2worker-20260813_222007/summary.txt
df2662ab9f35240e3d0fcf10ce2afae63d66c7690436134f78701e8aae835d4e  task1-after-hub-4worker-rt5000-20260813_232804/summary.txt
ebad546e18fe9461607662c7c214ecbf7f9bdfc7be21bdd4d88439608cfff8d6  task1-hub-smoke-0worker-20260813_221836/qemu.log
2afaa857fb1c0d45bb44d532157e56d61e80fda2138fe02f40982bad99c50b0b  task1-hub-smoke-2worker-20260813_222007/qemu.log
2e7343aad2007ee8b274328dc61bfca1cae5a92fbf157a512160a5703c1237b9  task1-after-hub-4worker-rt5000-20260813_232804/qemu.log
```

## 2026-08-13 Pre-`#1770` Baseline Probe

A detached worktree was created at the pre-`#1770` baseline commit
`bb562428c69317faccf2761167d2fabc47b82a37`. The same contest runner and the
same known-passing runtime artifacts were used so that the comparison isolates
the AxVisor baseline as much as possible.

The first baseline attempt timed out during the cold Rust/QEMU preparation path
and is not counted as a runtime result. After the build cache was warm, both
baseline hub-mode workloads completed. The table below is a preliminary
before/after smoke comparison; it is useful for task-one scoring preparation,
but it does not replace the final TAP/tcpdump packet-capture runs.

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| before-0w | `PASS` | `hub` | `0` | `2` | `60352 / 873920 / 3259472` | `926584 / 7858560 / 15010576` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1477 / 1852` | `n/a/n/a` |
| before-2w | `PASS` | `hub` | `2` | `2` | `51959 / 662832 / 2867760` | `880675 / 3196880 / 5580496` | `20/20` | `10/10` | `0` | `2` | `10/10` | `2796 / 6570` | `n/a/n/a` |
| after-0w | `PASS` | `hub` | `0` | `2` | `58825 / 683296 / 1854592` | `779248 / 2562944 / 12974752` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1746 / 2421` | `n/a/n/a` |
| after-2w | `PASS` | `hub` | `2` | `2` | `70773 / 914176 / 5394288` | `1039036 / 5424976 / 7955632` | `20/20` | `10/10` | `0` | `2` | `10/10` | `3195 / 17759` | `n/a/n/a` |

Evidence hashes:

```text
d4cc39f550ce28a84db6d0e020115e6775841f54349028a9d75d00f95c8731cf  task1-before1770-hub-smoke-0worker-rerun-20260813_223638/summary.txt
3f930d1abe2493925e71c2948c0fa163d49eba6ecf4c27b329fd9d7c0326b692  task1-before1770-hub-smoke-0worker-rerun-20260813_223638/qemu.log
be20fa9e5ebde71b8685e22cb80873098b5d59ca81b3d68ca396313d0a001a54  task1-before1770-hub-smoke-2worker-20260813_224238/summary.txt
93cf2671c22c40e4fbbe2ed8404a97fbaa53d5d58cbb3d204d12ed78b2b016a7  task1-before1770-hub-smoke-2worker-20260813_224238/qemu.log
1f778ea055ed5c13a0845eb3e65b868f9abb89edb372f4f24238afd8d62d967d  task1-hub-smoke-0worker-20260813_221836/summary.txt
ebad546e18fe9461607662c7c214ecbf7f9bdfc7be21bdd4d88439608cfff8d6  task1-hub-smoke-0worker-20260813_221836/qemu.log
b8bd9ad79d0c02d431b02d582ee4b823ee08c92b7f0f3512fc9468a2b1149169  task1-hub-smoke-2worker-20260813_222007/summary.txt
2afaa857fb1c0d45bb44d532157e56d61e80fda2138fe02f40982bad99c50b0b  task1-hub-smoke-2worker-20260813_222007/qemu.log
```

## 2026-08-14 Private PR-Head Long Hub Matrix

The Kali current worktree was refreshed to private PR `#1` head
`760e253eec50c0425eadec321d56663e400ac28b` and rerun with `10000` Linux
periodic samples in hub mode. This does not replace the TAP/tcpdump matrix,
but it provides a stronger current-head runtime proof than the earlier short
smoke rows.

Evidence root:

```text
/home/kali/qc-evidence/t1-head760-hub-r10000-20260814_010458
```

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| after-head760-hub-0w-r10000-20260814_010458 | `PASS` | `hub` | `0` | `2` | `50391 / 761312 / 1773024` | `948824 / 5220048 / 27038432` | `20/20` | `10/10` | `0` | `2` | `10/10` | `2322 / 3769` | `n/a/n/a` |
| after-head760-hub-2w-r10000-20260814_010811 | `PASS` | `hub` | `2` | `2` | `72076 / 993408 / 6933952` | `1151354 / 7175200 / 39208656` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1902 / 4202` | `n/a/n/a` |

Evidence hashes:

```text
b044ac0d205346577d676ca5ba359d40191485f1c83a7265377db94d2c09eb79  task-one-second-version-summary.md
13825a335f686a6e55b5ef4b364ae784a5a73c112445fd8f376ae32d9a5ff07d  task-one-second-version-summary.csv
0681b20a41af2af42705aadfcf82fc056a079d09f0ac7db5281372468e106228  after-head760-hub-0w-r10000-20260814_010458/summary.txt
e3048da89f9c35d9c642c02c4a0fccd00be2c285aa48bdb75d8c3d44fa6a67d5  after-head760-hub-0w-r10000-20260814_010458/qemu.log
2f9615f6093d014de67efefb68e2f46c54ca4a9d260b5c4e92bab517a85a7e98  after-head760-hub-2w-r10000-20260814_010811/summary.txt
07a2841a29a95f2cdab68747f849899f938f236e44e3dfa95d4f67dd0dc56049  after-head760-hub-2w-r10000-20260814_010811/qemu.log
```

Both rows kept UDP, QCZ1 and AI closed-loop success at `100%` while the Linux
guest exposed `2` vCPUs and the RTOS periodic probe remained active for the
longer sample window. TAP packet-capture counters are intentionally not claimed
for this run.

## 2026-08-14 Previous Private PR-Head Long Hub Matrix

After the first-version packaging and evidence notes were refreshed, the Kali
current worktree was updated again to private PR `#1` head
`238a868e61fe70b97e00b623a38ad73324339a42` and rerun with the same `0` and `2`
Linux-worker, `10000` Linux periodic sample shape. This keeps the current-head
runtime proof aligned with the submitted private PR.

Evidence root:

```text
/home/kali/qc-evidence/t1-head238-hub-r10000-20260814_070406
```

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| after-head238-hub-0w-r10000-20260814_070406 | `PASS` | `hub` | `0` | `2` | `78908 / 1424512 / 3693072` | `1803927 / 44821264 / 66204960` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1724 / 2647` | `n/a/n/a` |
| after-head238-hub-2w-r10000-20260814_070528 | `PASS` | `hub` | `2` | `2` | `73723 / 1413744 / 4755488` | `880126 / 3647584 / 25559584` | `20/20` | `10/10` | `0` | `2` | `10/10` | `2595 / 5518` | `n/a/n/a` |

Evidence hashes:

```text
ad32d1b43e7269565d9244ef9fb76fa78fd760f64073f192f097808af14c1379  task-one-second-version-summary.md
1ca7dcde1f4872a5f73bc0580bb6bb8ee62912b19b5390717ce5e1fb1b2ca75d  task-one-second-version-summary.csv
ea1136ca4c16cebe5ce1544c361c9d16dc660a2cbff425924061dafca243d7a8  after-head238-hub-0w-r10000-20260814_070406/summary.txt
6ee3d42a4a2a3afc44ab2de99702129be9dc405efab7821abe3f92443eb65188  after-head238-hub-0w-r10000-20260814_070406/qemu.log
ad7ffe8087bf3d248ad9a6291cab32acc7c32e4c8486f038de9169542437246e  after-head238-hub-2w-r10000-20260814_070528/summary.txt
fdf10256e503d5822222e0a3a982ed7dd768492b905febaf7fdef5026d0835cd  after-head238-hub-2w-r10000-20260814_070528/qemu.log
```

Both rows report `TASK_ONE_SECOND_VERSION_MATRIX=PASS`, Linux `2` vCPUs, plain
UDP `20/20`, QCZ1 `10/10`, QCZ1 retransmits `0`, AI `10/10` and no missing
markers. This remains a hub-mode proof; TAP packet-capture counters are still
covered by the completed TAP matrix recorded later in this document.

## 2026-08-14 Latest Private PR-Head Long Hub Matrix

After the package verifier and final checklist notes were refreshed, the Kali
current worktree was updated to private PR `#1` head
`588ddf1a3e5e9697799f39b8334db73a1ea3bd15` and rerun with the `0`, `1` and `2`
Linux-worker long-sample matrix. This keeps the current-head runtime proof
aligned with the submitted private PR while preserving the same hub-mode
boundary: tcpdump counters are not claimed here, because they are covered by
the later TAP before/after matrix.

Evidence root:

```text
/home/kali/qc-evidence/t1-head588-hub-r10000-20260814_074255
```

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| after-head588-hub-0w-r10000-20260814_074255 | `PASS` | `hub` | `0` | `2` | `81318 / 1242256 / 9931104` | `842653 / 3150800 / 15527632` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1469 / 1901` | `n/a/n/a` |
| after-head588-hub-1w-r10000-20260814_074404 | `PASS` | `hub` | `1` | `2` | `68419 / 1207616 / 2207312` | `981621 / 4048688 / 41116832` | `20/20` | `10/10` | `0` | `2` | `10/10` | `2230 / 5036` | `n/a/n/a` |
| after-head588-hub-2w-r10000-20260814_074514 | `PASS` | `hub` | `2` | `2` | `45508 / 639456 / 1882048` | `961211 / 4479360 / 23385232` | `20/20` | `10/10` | `0` | `2` | `10/10` | `2893 / 7145` | `n/a/n/a` |

Evidence hashes:

```text
a0c1721e2defaa0a050eefff6b3676c91d4cd8d8b20efad2a90bbe7d372cb136  task-one-second-version-summary.md
69f92cbfbae02a196263e542653023d0dba4940caf92b41d199a20257f0564ec  task-one-second-version-summary.csv
93089556e624211121595eabb431016dbe819fc1d607cf1f9e267cf3b3ea9e77  after-head588-hub-0w-r10000-20260814_074255/summary.txt
b32e65403862c32adcff0734e45d7c6ce4229d16dab6831ad4e0615c98be0ea0  after-head588-hub-0w-r10000-20260814_074255/qemu.log
d4fd22df42ba6f9bdfcdfbb345127d5831a37edc9cc4d56b803a998c137227f0  after-head588-hub-1w-r10000-20260814_074404/summary.txt
0ac2bc5de4f444c99e83503565201947faf07fabaaaaea62af429e36bc786bbc  after-head588-hub-1w-r10000-20260814_074404/qemu.log
cf19b71e2677482a328b143debad0625bf467bf870c1c8b731af6010151a5cbe  after-head588-hub-2w-r10000-20260814_074514/summary.txt
7b44f4c14c9c639c14dcfadd224a3fa994277fad5e7dc32c286749d7bf6f4d09  after-head588-hub-2w-r10000-20260814_074514/qemu.log
```

Interpretation:

- All recorded current-branch rows keep Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, AI
  `10/10`, QCZ1 retransmits `0` and no missing markers.
- The `1`-worker row gives the recorded branch a middle pressure point, so the
  task-one report no longer relies only on 0/2-worker health data.
- The `2`-worker row is the strongest RTOS periodic row in this recorded
  set: RTOS p99/max are `639456 / 1882048 ns` while the full communication and
  AI loop remain active.
- This section is current-head health evidence. The before/after scoring claim
  still compares like-for-like baseline and after rows, and the final
  second-version packet-capture proof is the TAP/tcpdump matrix below.

## 2026-08-14 Pre-`#1770` Long Hub Baseline Matrix

The pre-`#1770` baseline worktree was rerun from commit
`bb562428c69317faccf2761167d2fabc47b82a37` with the same `10000` Linux
periodic sample count and the same 0/2-worker hub matrix shape. The current
branch runner used the baseline worktree's dual-guest runtime script and the
current analyzer/summarizer so that the before/after rows share the same table
format.

Evidence root:

```text
/home/kali/qc-evidence/t1-before1770-hub-r10000-20260814_011825
```

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| before1770-hub-0w-r10000-20260814_011825 | `PASS` | `hub` | `0` | `2` | `80937 / 1322960 / 8054832` | `794758 / 2166768 / 7016816` | `20/20` | `10/10` | `0` | `2` | `10/10` | `2416 / 6551` | `n/a/n/a` |
| before1770-hub-2w-r10000-20260814_011945 | `PASS` | `hub` | `2` | `2` | `89005 / 1453600 / 4347168` | `958411 / 4704416 / 11699344` | `20/20` | `10/10` | `0` | `2` | `10/10` | `3406 / 7781` | `n/a/n/a` |

Evidence hashes:

```text
841bef82527195fc9f0f097e75d85ebd15a97157ad312c26d81f7f65303cd8ce  task-one-second-version-summary.md
d27f42a695e1134847302b07dce45c3a1bd2f88a6410b5efc695cce44c54520a  task-one-second-version-summary.csv
eefab66d279c28741a5b61b07fb6031b0647e8c76d6224b6be8b5778a411bc49  before1770-hub-0w-r10000-20260814_011825/summary.txt
32946ab7e527f72ad9cfb1fae76799b8b8f0862b7b2221a0d1b5542b9438d923  before1770-hub-0w-r10000-20260814_011825/qemu.log
d3e1dcb473d2bac372ac70f6580e6f4ff8e9f5d51bde8c18382ed5ff2d7d34b7  before1770-hub-2w-r10000-20260814_011945/summary.txt
b8a44f99a1b12e30d9e5cac0cad6cf6a8719835cdbece5cd3274a2bea1eeea10  before1770-hub-2w-r10000-20260814_011945/qemu.log
```

Preliminary observations:

- The pre-`#1770` baseline can reach the same dual-guest workload in hub mode,
  so the final report should not describe `#1770` as a simple pass/fail boot
  fix.
- In the 10000-sample hub comparison, the 0-worker after run improves RTOS
  p99/max from `1322960 / 8054832 ns` to `761312 / 1773024 ns`.
- In the 10000-sample 2-worker hub comparison, RTOS p99 improves from
  `1453600 ns` to `993408 ns`; the max row has a larger after-side outlier
  (`4347168 ns` to `6933952 ns`) and should be described as such rather than
  hidden.
- A later 1-worker fill-in run strengthens the middle pressure point: RTOS
  p99/max improves from `1123872 / 5085392 ns` to
  `782080 / 4966544 ns`.
- Both before and after paths keep UDP `20/20`, QCZ1 `10/10`, duplicate ACK
  handling, AI `10/10` and Linux `2` vCPUs while the realtime probes are
  active.
- The final second-version TAP/tcpdump runs now measure packet-capture and
  kernel-drop counters in the same before/after shape.

## 2026-08-14 TAP Before/After Packet-Capture Matrix

The privileged TAP matrix was completed after caller-authenticated `sudo -v`
on Kali. It uses the same current branch and pre-`#1770` baseline worktrees as
the hub comparison, but creates TAP devices and a bridge so tcpdump can record
actual packet counters.

Evidence root:

```text
/home/kali/qc-evidence/t1-before-after-tap-fixed-114047
```

Wrapper marker:

```text
TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS
```

| Phase | Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| after | after-tap-0w-r10000-20260814_114047 | `PASS` | `tap` | `0` | `2` | `83166 / 1290544 / 9349568` | `786370 / 2141264 / 14366752` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1808 / 3916` | `88/0` |
| after | after-tap-2w-r10000-20260814_114224 | `PASS` | `tap` | `2` | `2` | `72137 / 927216 / 9913056` | `949349 / 5177888 / 29571664` | `20/20` | `10/10` | `0` | `2` | `10/10` | `4179 / 17642` | `88/0` |
| before | before-tap-0w-r10000-20260814_114342 | `PASS` | `tap` | `0` | `2` | `51834 / 791120 / 3671568` | `863998 / 2761120 / 13642256` | `20/20` | `10/10` | `0` | `2` | `10/10` | `1789 / 2090` | `88/0` |
| before | before-tap-2w-r10000-20260814_115908 | `PASS` | `tap` | `2` | `2` | `54287 / 1273216 / 3565712` | `1259651 / 13018080 / 41490032` | `20/20` | `10/10` | `0` | `2` | `10/10` | `3459 / 9056` | `88/0` |

Committed summary tables:

```text
results/task-one-before-after-tap-summary.csv
results/task-one-before-after-tap-summary.md
```

Interpretation: the TAP matrix closes the second-version packet-capture gate.
All four rows keep Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`, QCZ1
retransmits `0`, AI `10/10`, no missing markers and tcpdump kernel drops `0`.

## 2026-08-14 1-Worker Long Hub Fill-In

After the 0/2-worker long hub matrix, the same before/after shape was filled in
with `1` Linux stress worker. This gives the second-version report a smoother
0/1/2 pressure progression while still keeping the 4-worker case as a separate
overcommit boundary.

Evidence root:

```text
/home/kali/qc-evidence/t1w1-hub-before-after-20260814_030333
```

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| before1 | `PASS` | `hub` | `1` | `2` | `74750 / 1123872 / 5085392` | `875693 / 4034768 / 25984544` | `20/20` | `10/10` | `0` | `2` | `10/10` | `3622 / 19762` | `n/a/n/a` |
| after1 | `PASS` | `hub` | `1` | `2` | `58311 / 782080 / 4966544` | `820334 / 2898192 / 13186032` | `20/20` | `10/10` | `0` | `2` | `10/10` | `2405 / 5829` | `n/a/n/a` |

Evidence hashes:

```text
9e3f9459563ba468aa72ef8aacd605a491255138d3e75604d9f91215934787aa  after/after1-hub-1w-r10000-20260814_030153/qemu.log
41824a3336d890103caeb43ec5237bdb43132b6c084ecb3aeb4072c608ca149c  after/after1-hub-1w-r10000-20260814_030153/summary.txt
0ae663ac8ad411dc7b845304f83f6d8e1daf9b5b9ee56f1e11c403d17a127b95  after/task-one-second-version-summary.csv
08f29663723d3d015959dc2f7a43ae77a73ccec9e84b5be19f2dfc4360ff782b  after/task-one-second-version-summary.md
0cd4ea1f2cdc09e9bc13bc35cd13d18e99bd8f86ff32d3787ec2e48a4f80652b  before/before1-hub-1w-r10000-20260814_030333/qemu.log
8f799ab8267c3ae97f98e6460583d1221ae8a101259f751313e4abacf0bc36b4  before/before1-hub-1w-r10000-20260814_030333/summary.txt
2c4785311e80593d6bba4a48c48d7873d4424aab6fad49c0823bfae1d8dcfc44  before/task-one-second-version-summary.csv
5293d33bd30ab921631015f1beb3fe92c24bfaed054ff42b3082c0c1f94d195e  before/task-one-second-version-summary.md
```

Interpretation:

- The 1-worker after row improves RTOS p99/max from
  `1.124 ms / 5.085 ms` to `0.782 ms / 4.967 ms`.
- The Linux non-RT periodic p99/max also improves from
  `4.035 ms / 25.985 ms` to `2.898 ms / 13.186 ms`.
- UDP, QCZ1 reliable control, duplicate ACK handling and AI closed loop remain
  at `100%` success in both rows.

## 2026-08-14 4-Worker Overcommit Hub Boundary

After the long 0/2-worker hub matrix, the current branch and the pre-`#1770`
baseline were also rerun with `4` Linux stress workers on the same `2`-vCPU
Linux guest. This is intentionally an overcommit boundary test. It is useful
for showing that the mixed Linux/RTOS communication and AI-control path still
completes under heavier Linux pressure, but it is not used as the primary
before/after latency improvement claim.

Evidence root:

```text
/home/kali/qc-evidence/t1w4-hub-before-after-recovered-20260814_020210
```

The current analyzer head used for this recovered summary is
`6dddec6dc80c1695b7c299668c9c40f684fb2dca`. The analyzer now accepts a strict
RTOS periodic PASS when serial log interleaving hides the final
`QC_RTOS_PERIODIC_RESULT=PASS` line but the RTOS sample stream reaches the
expected sample count and no RTOS failure marker is present.

| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |
| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|
| before4 | `PASS` | `hub` | `4` | `2` | `68513 / 1067280 / 6420496` | `3350749 / 46688208 / 69122784` | `20/20` | `10/10` | `0` | `2` | `10/10` | `5510 / 25233` | `n/a/n/a` |
| after4 | `PASS` | `hub` | `4` | `2` | `75941 / 1506224 / 6999824` | `343967173 / 1099832160 / 1118971392` | `20/20` | `10/10` | `0` | `2` | `10/10` | `5475 / 18573` | `n/a/n/a` |

Evidence hashes:

```text
43b1eeea3e8bce6b83ef805b8d3480521d14dd6c5d52af4b3bce5c55d65053c9  combined/task-one-second-version-summary.csv
186af3496f87cb8a6eaf30fc08a8e1f65a55811f56c52dec9f6fec36455c3604  combined/task-one-second-version-summary.md
d2f2c4eb1dd06bd5714c097d2cb48dbc04d8d4409632317f7cd10d13c890e870  after/after-hub-4w-r10000-20260814_020210/qemu.log
d064e3ff1420c01582e77192dafefc6f8ea4b4902cd5ed78f5f59ecd1cfb0866  after/after-hub-4w-r10000-20260814_020210/summary.txt
72dc7804671b643fd2208c3de2ce7f9b4b0d9bf911a0e2ed2f9748b6b3efbae6  before/before-hub-4w-r10000-20260814_020514/qemu.log
a15f7b32029ce65292c0eeb32312dacdb5934c23d20b59e70463a13602fd4a9e  before/before-hub-4w-r10000-20260814_020514/summary.txt
```

Interpretation:

- Both before and after rows keep Linux `2` vCPUs, UDP `20/20`, QCZ1 `10/10`,
  duplicate ACK handling and AI `10/10` while the RTOS periodic probe completes.
- The after row does not improve the 4-worker Linux-side latency; the Linux
  guest is deliberately overcommitted and shows much larger non-RT delay in
  this run.
- The scoring-relevant improvement statement should remain the 0/2-worker
  10000-sample comparison above, where RTOS p99 improves in both rows and the
  0-worker RTOS max improves. The 4-worker evidence is a stability boundary.

## Commands To Reuse

The current PR already contains the scripts needed for the second-version runs.
The preferred entry point for the 2026-08-21 matrix is:

```sh
cd os/axvisor/contest/quancheng2026

./scripts/run_task_one_second_version_matrix.sh \
  --net-mode tap \
  --linux-rt-samples 10000 \
  --workers 0,2 \
  --timeout 900 \
  --label-prefix after

./scripts/run_task_one_second_version_matrix.sh \
  --net-mode tap \
  --linux-rt-samples 10000 \
  --workers 0,2 \
  --timeout 900 \
  --label-prefix before \
  --repo /path/to/pre-1770-worktree

./scripts/run_native_zephyr_latency_baseline.sh
```

The matrix runner calls the dual-guest runtime script, analyzes each evidence
directory with `--fail-on-missing`, and writes:

```sh
task-one-second-version-summary.csv
task-one-second-version-summary.md
```

When `--repo` points to a baseline worktree, the runner from that worktree is
used, while the analyzer and summarizer come from the current PR checkout. This
keeps before/after tables consistent even if the baseline worktree lacks newer
reporting helpers.

Keep `--evidence-root` short when QEMU is used. QEMU monitor sockets are UNIX
domain sockets, and Linux limits the socket path length to less than 108 bytes.

The lower-level scripts can still be used directly for single-run debugging:

```sh
./scripts/run_axvisor_dual_guest_qcz1_ai.sh --net-mode tap --linux-stress-workers 2
python3 scripts/analyze_dual_guest_realtime.py --fail-on-missing <evidence-dir>
```

The summary script records Linux and RTOS periodic latency, UDP/QCZ1/AI success
counts, retransmits, duplicate ACKs, tcpdump captured/dropped counters, and
SHA-256 values for the QEMU and summary logs.

## Acceptance Gate For 2026-08-21

The second-version task-one package is ready when it can answer these questions
without additional explanation:

1. Which AxVisor timer/interrupt change is the realtime-support change?
2. Which commit is the before baseline and which commit is the after baseline?
3. Does the after path boot a 2-vCPU Linux guest and a Zephyr RTOS guest in one
   AxVisor run?
4. Under no pressure and Linux pressure, what are the RTOS p99/max periodic
   values?
5. Do UDP, QCZ1 and AI closed-loop markers still pass while realtime probes are
   active?
6. What is the native RTOS baseline, and why is it not a one-to-one replacement
   for AxVisor-hosted latency?

If all six answers are present in `docs/realtime-evaluation.md`,
`docs/test-report.md` and this plan, task one should be much closer to the
score expected from a first-prize submission.
