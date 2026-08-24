# Latest-Dev Final Demo Validation

- Validation date: `2026-08-21`
- Official `upstream/dev`: `8e39cbd586a4a34ab9f522931ca4b1e7523709c7`
- Runtime source head: `17ee96b89fd2e4c441a44dd5c1893f63ee5e77db`
- Evidence directory: `/home/kali/qc-evidence/final-demo-latestdev8e39-head17ee-20260821`
- Network mode: QEMU hub (non-privileged final compatibility run)
- Final markers: `result=PASS`, `analysis_result=PASS`, `REDCOLA_FINAL_DEMO_RECORDING=PASS`

## Integrated Result

| Gate | Result |
| --- | --- |
| Linux guest topology | `2` vCPUs online (`0-1`) |
| CPU placement | periodic probe on vCPU 0; two stress workers on vCPU 1 |
| Linux periodic probe | `3000/3000`, 10 ms period, PASS |
| RTOS periodic probe | `1000/1000`, 1 ms period, PASS |
| Plain IPv4/UDP | `20/20 PASS`, byte-exact payload validation |
| QCZ1 reliable UDP | `10/10 PASS`, duplicate ACKs `2`, retransmits `0` |
| AI control loop | `10/10 PASS`, status return validated |
| AI vs manual error | mean absolute error `207` vs `240` |
| AI inference | mean `38 us` |
| AI end-to-end | mean `16507 us`, max `27136 us` |

This run validates that the submitted AxVM PCI interrupt-map candidate, Linux
guest, Zephyr RTOS guest, QCZ1 protocol and AI control loop remain operational
after the final sync to official `dev`. Long TAP/tcpdump and before/after rows
remain the primary realtime and packet-capture evidence.
