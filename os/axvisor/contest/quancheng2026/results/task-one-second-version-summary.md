# Task-One Second-Version Summary

This file is the compact index for the 2026-08-21 task-one realtime evidence.
It points reviewers to the committed summary files without requiring them to
open every raw evidence directory.

## Coverage

| Evidence group | Net | Phase | Workers | Samples | Result | Linux vCPUs | RTOS p99/max ns | UDP | QCZ1 | AI | tcpdump |
| --- | --- | --- | ---:| ---:| --- | ---:| ---:| ---:| ---:| ---:| ---:|
| hub before/after | hub | before | 0 | 10000 | `PASS` | 2 | `1322960 / 8054832` | `20/20` | `10/10` | `10/10` | `n/a` |
| hub before/after | hub | after | 0 | 10000 | `PASS` | 2 | `761312 / 1773024` | `20/20` | `10/10` | `10/10` | `n/a` |
| hub before/after | hub | before | 1 | 10000 | `PASS` | 2 | `1123872 / 5085392` | `20/20` | `10/10` | `10/10` | `n/a` |
| hub before/after | hub | after | 1 | 10000 | `PASS` | 2 | `782080 / 4966544` | `20/20` | `10/10` | `10/10` | `n/a` |
| hub before/after | hub | before | 2 | 10000 | `PASS` | 2 | `1453600 / 4347168` | `20/20` | `10/10` | `10/10` | `n/a` |
| hub before/after | hub | after | 2 | 10000 | `PASS` | 2 | `993408 / 6933952` | `20/20` | `10/10` | `10/10` | `n/a` |
| hub overcommit boundary | hub | before | 4 | 10000 | `PASS` | 2 | `1067280 / 6420496` | `20/20` | `10/10` | `10/10` | `n/a` |
| hub overcommit boundary | hub | after | 4 | 10000 | `PASS` | 2 | `1506224 / 6999824` | `20/20` | `10/10` | `10/10` | `n/a` |
| TAP before/after | tap | before | 0 | 10000 | `PASS` | 2 | `791120 / 3671568` | `20/20` | `10/10` | `10/10` | `88/0` |
| TAP before/after | tap | after | 0 | 10000 | `PASS` | 2 | `1290544 / 9349568` | `20/20` | `10/10` | `10/10` | `88/0` |
| TAP before/after | tap | before | 2 | 10000 | `PASS` | 2 | `1273216 / 3565712` | `20/20` | `10/10` | `10/10` | `88/0` |
| TAP before/after | tap | after | 2 | 10000 | `PASS` | 2 | `927216 / 9913056` | `20/20` | `10/10` | `10/10` | `88/0` |
| current-head long pressure | hub | after | 2 | 30000 | `PASS` | 2 | `685872 / 2001840` | `20/20` | `10/10` | `10/10` | `n/a` |
| current-head long pressure | tap | after | 2 | 30000 | `PASS` | 2 | `1961824 / 9953504` | `20/20` | `10/10` | `10/10` | `88/0` |
| latest head 35b long pressure | hub | after | 2 | 30000 | `PASS` | 2 | `1327104 / 4914320` | `20/20` | `10/10` | `10/10` | `n/a` |
| latest head 35b long pressure | hub | after | 4 | 30000 | `PASS` | 2 | `1016480 / 2487776` | `20/20` | `10/10` | `10/10` | `n/a` |
| latest head 77c full pressure | hub | after | 0 | 30000 | `PASS` | 2 | `855488 / 5211696` | `20/20` | `10/10` | `10/10` | `n/a` |
| latest head 77c full pressure | hub | after | 1 | 30000 | `PASS` | 2 | `1392224 / 3034928` | `20/20` | `10/10` | `10/10` | `n/a` |
| latest head 77c full pressure | hub | after | 2 | 30000 | `PASS` | 2 | `1156672 / 4598080` | `20/20` | `10/10` | `10/10` | `n/a` |
| latest head 77c full pressure | hub | after | 4 | 30000 | `PASS` | 2 | `1344800 / 2948256` | `20/20` | `10/10` | `10/10` | `n/a` |
| latest head b706 full pressure | hub | after | 0 | 30000 | `PASS` | 2 | `1372496 / 3525056` | `20/20` | `10/10` | `10/10` | `n/a` |
| latest head b706 full pressure | hub | after | 1 | 30000 | `PASS` | 2 | `1073280 / 10214304` | `20/20` | `10/10` | `10/10` | `n/a` |
| latest head b706 full pressure | hub | after | 2 | 30000 | `PASS` | 2 | `820064 / 3563856` | `20/20` | `10/10` | `10/10` | `n/a` |
| latest head b706 full pressure | hub | after | 4 | 30000 | `PASS` | 2 | `931056 / 2066960` | `20/20` | `10/10` | `10/10` | `n/a` |
| exact head 746 stability run 1 | hub | after | 2 | 30000 | `PASS` | 2 | `1015776 / 3080560` | `20/20` | `10/10` | `10/10` | `n/a` |
| exact head 746 stability run 2 | hub | after | 2 | 30000 | `PASS` | 2 | `1040304 / 2043904` | `20/20` | `10/10` | `10/10` | `n/a` |
| exact head 746 stability run 3 | hub | after | 2 | 30000 | `PASS` | 2 | `882896 / 2598624` | `20/20` | `10/10` | `10/10` | `n/a` |
| selected package head a9ce long pressure | hub | after | 2 | 30000 | `PASS` | 2 | `1115280 / 5921456` | `20/20` | `10/10` | `10/10` | `n/a` |

## Reviewer Notes

- Hub rows are used for comparable before/after trend analysis.
- TAP rows add packet-captured proof with tcpdump counters.
- The 4-worker rows are an overcommit boundary for a 2-vCPU Linux guest and
  should not be treated as the primary latency-improvement claim.
- The 30000-sample current-head rows are the long-pressure stability proof
  carried into the first checkpoint package and the 2026-08-21 score narrative.
  The `35b65e4ba` rows are the latest private PR-head hub validation.
  The `77c91d576` rows are a prior full private PR-head 0/1/2/4-worker
  hub validation. The `b706a02c` rows are the latest exact private PR-head
  full hub validation. The `746042293` rows are the exact submitted-head
  2-worker stability repeat after the RTOS-marker analyzer hardening.
  The `a9ceb7dc8` row is the selected package-head 2-worker long-pressure
  hub proof used for the refreshed 2026-08-15 first-version package.

## Source Files

- `task-one-before-after-hub-summary.csv`
- `task-one-before-after-tap-summary.csv`
- `task-one-current-head-long-hub-r30000-summary.csv`
- `task-one-current-head-long-tap-r30000-summary.csv`
- `task-one-latest-head35b-long-hub-r30000-summary.csv`
- `task-one-latest-head77c-full-hub-r30000-summary.csv`
- `task-one-latest-headb706-full-hub-r30000-summary.csv`
- `task-one-head746-2w-hub-stability-r30000-summary.csv`
- `task-one-head-a9ce-long-hub-r30000-summary.csv`
- `task-one-head-a9ce-long-hub-r30000-proof.txt`
