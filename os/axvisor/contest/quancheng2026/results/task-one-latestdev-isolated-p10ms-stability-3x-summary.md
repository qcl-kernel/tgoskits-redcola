# Latest-dev CPU-isolated 10 ms stability campaign

## Scope

- Source head: `26cb43d1b219f18fd197d0f608af0da51bd8e99d`
- Official `dev` base: `220af445bbfa2a360b96efc968e76b2383f5b658`
- Network mode: QEMU hub
- Linux guest: 2 vCPUs, periodic probe pinned to guest CPU 0
- Pressure: 2 continuous workers pinned to guest CPU 1
- Periodic workload: 3,000 samples per run at a 10 ms period
- Repetitions: 3 independent dual-guest boots

## Results

| Round | Result | Linux mean / P99 / max | UDP | QCZ1 | AI | AI E2E mean / max |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | PASS | 1.893 / 6.453 / 24.794 ms | 20/20 | 10/10 | 10/10 | 6.538 / 11.434 ms |
| 2 | PASS | 2.556 / 8.753 / 127.734 ms | 20/20 | 10/10 | 10/10 | 11.689 / 49.197 ms |
| 3 | PASS | 2.001 / 4.720 / 19.240 ms | 20/20 | 10/10 | 10/10 | 8.250 / 16.322 ms |

Aggregate results:

- Stability: `3/3 PASS`
- Linux periodic samples: `9,000/9,000`
- Linux latency: mean `2.150 ms`, worst observed P99 `8.753 ms`, worst observed maximum `127.734 ms`
- Plain UDP: `60/60 PASS`, mean of run means `6.070 ms`, maximum `41.421 ms`
- QCZ1 reliable UDP: `30/30 PASS`, `0` retransmits, `6` expected duplicate probes, maximum `18.780 ms`
- AI control loop: `30/30 PASS`, mean of run E2E means `8.826 ms`, maximum `49.197 ms`
- Control error: AI `207`, fixed/manual baseline `240`, a `13.75%` reduction
- RTOS periodic marker: PASS in all three boots

## Interpretation

This campaign demonstrates repeatable dual-guest operation on the latest tested
`dev` base while separating the Linux periodic probe and pressure workers across
the two guest vCPUs. The values are measured under nested QEMU TCG and include
host scheduling noise. They are evidence of reproducibility, CPU-affinity
control, and worst-case observation in this test environment; they are not a
hardware hard-real-time guarantee.

TAP/tcpdump packet evidence is reported separately because this campaign uses
QEMU hub mode to avoid host privileged-network setup between repeated boots.
