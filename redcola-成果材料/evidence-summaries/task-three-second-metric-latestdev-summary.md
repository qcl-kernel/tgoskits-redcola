# Task-Three Same-Sample Two-Metric Summary

This summary records the latest-dev AxVisor dual-guest runtime proof for the
second control-quality metric required by task three.

## Runtime Boundary

```text
source_head=17ee96b89fd2e4c441a44dd5c1893f63ee5e77db
network_mode=hub
linux_vcpus=2
linux_periodic_samples=100
linux_period_ns=10000000
linux_rt_cpu=0
linux_stress_workers=0
evidence_dir=/tmp/qc-task3-second-metric-20260822
result=PASS
```

Hub mode was used for this short same-sample control-quality validation. TAP
packet-capture evidence is recorded separately in the task-one TAP summaries.

## Closed-Loop Result

```text
QC_UDP_SUCCESSES=20
QC_UDP_FAILURES=0
QC_QCZ1_RELIABLE_SUCCESSES=10
QC_QCZ1_RELIABLE_FAILURES=0
QC_QCZ1_RETRANSMITS=0
QC_QCZ1_STATUS_VALIDATION=OK
QC_AI_REQUESTS=10
QC_AI_SUCCESSES=10
QC_AI_FAILURES=0
QC_AI_INFER_MEAN_US=27
QC_AI_E2E_MEAN_US=10625
QC_AI_E2E_MAX_US=18961
QC_AI_CONTROL_RESULT=PASS
```

## Same-Sample Policy Comparison

The neural-network policy and fixed-gain policy use the same ten deterministic
input samples and the same setpoints.

| Control-quality metric | AI policy | Fixed-gain baseline |
| --- | ---: | ---: |
| Mean absolute control error | `207` milliunits | `240` milliunits |
| Samples within `+/-200` milliunits | `6/10` | `0/10` |

Runtime markers:

```text
QC_AI_CONTROL_ERROR_MEAN=207
QC_MANUAL_CONTROL_ERROR_MEAN=240
QC_CONTROL_TOLERANCE_MILLI=200
QC_AI_WITHIN_TOLERANCE_COUNT=6
QC_MANUAL_WITHIN_TOLERANCE_COUNT=0
```

The first metric measures average control error. The second measures tolerance
accuracy on the identical sample sequence, so the task-three comparison does
not rely on timing as a substitute for a second control-effect metric.
