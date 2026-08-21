# AI Control Evaluation

This note records the task-three AI control scenario, measurement method and
manual baseline comparison.

## Reviewer Quick Evidence

| Contest requirement | redcola evidence |
| --- | --- |
| Neural-network inference in non-RT guest | The Linux guest runs a deterministic fixed-weight neural-network controller. |
| Model output sent through task-two protocol | The Linux client sends `CONTROL_SET` through QCZ1 over IPv4/UDP to the RTOS guest. |
| RTOS observable control action | The Zephyr RTOS guest applies `output_milli` and logs the applied control state. |
| Closed-loop response | The RTOS guest returns `ACK` and `STATUS`, and the analyzer records success, latency and control error. |
| Integrated dual-guest PASS | `QC_AI_SUCCESSES=10`, `QC_AI_FAILURES=0`, `QC_AI_CONTROL_RESULT=PASS`. |
| End-to-end latency | Representative integrated mean/max: `2186 us` / `3389 us`; short final-demo rehearsal mean/max: `1.563 ms` / `1.754 ms`; latest 4-worker overcommit boundary after-side mean/max: `5.475 ms` / `18.573 ms`. |
| Manual baseline comparison | Integrated mean control error: AI `207` versus manual `240`; native smoke: AI `129.003` versus manual `204.640`. |

This places the task-three evidence on top of the document; the rest of this
file explains the closed-loop design, model payload and measurement method.

## Closed Loop

The integrated demo uses this closed loop:

```text
Linux guest input sample
  -> lightweight neural-network inference
  -> QCZ1 CONTROL_SET over IPv4/UDP
  -> Zephyr RTOS guest applies output_milli
  -> QCZ1 ACK/STATUS returns applied state
  -> analyzer records latency and control error
```

The Linux side runs the AI controller inside the Linux guest, not on the Kali
host. The RTOS side receives only the model output and control fields through
the QCZ1 protocol. The observable RTOS action is the updated control state and
serial log line containing `output_milli`.

## Model and Payload

The model is a small fixed-weight neural network implemented without dynamic
runtime dependencies in the guest demo program. Inputs are deterministic sample
features:

```text
error_milli
velocity_milli
load_milli
```

The model produces:

```text
ai_score_milli
```

The Linux client sends:

```text
setpoint_milli
ai_score_milli
client_sample_id
```

The RTOS guest applies:

```text
output_milli = setpoint_milli * ai_score_milli / 1000
```

This keeps the demo deterministic and easy to reproduce while still containing
a neural-network inference step and a real cross-guest control message.

## Manual Baseline

The manual baseline is a fixed control gain:

```text
manual_score_milli = 800
manual_output = setpoint_milli * manual_score_milli / 1000
```

The AI run is compared with this fixed-gain baseline by the same sample table.
The reported control-error metric is the absolute distance between the setpoint
and the output:

```text
control_error = abs(setpoint_milli - output_milli)
```

The integrated analyzer also reports end-to-end latency from the Linux-side
request to the returned RTOS ACK/STATUS observation.

## Known Passing Metrics

Representative integrated dual-guest run:

```text
QC_AI_REQUESTS=10
QC_AI_SUCCESSES=10
QC_AI_FAILURES=0
QC_AI_INFER_MEAN_US=66
QC_AI_E2E_MEAN_US=2186
QC_AI_E2E_MAX_US=3389
QC_AI_CONTROL_ERROR_MEAN=207
QC_MANUAL_CONTROL_ERROR_MEAN=240
QC_AI_CONTROL_RESULT=PASS
```

Representative native smoke run:

```text
AI control messages: 20/20
end-to-end mean: 1.118 ms
AI mean error: 129.003
manual mean error: 204.640
```

The two quantitative comparison dimensions are:

- control quality: AI mean control error versus fixed manual-gain error;
- timing: AI inference latency and end-to-end Linux/RTOS control latency.

Under the 0/1/2/4-worker AxVisor long-sample runs, the AI control transaction
success rate remained `10/10` in each run. The 4-worker run intentionally
overcommits the 2-vCPU Linux guest; it raises AI end-to-end latency relative to
the clean run but does not break the closed loop.

Latest 4-worker overcommit boundary:

```text
evidence: /home/kali/qc-evidence/t1w4-hub-before-after-recovered-20260814_020210
before4 AI: 10/10 PASS, e2e mean/max 5.510 ms / 25.233 ms
after4  AI: 10/10 PASS, e2e mean/max 5.475 ms / 18.573 ms
```
