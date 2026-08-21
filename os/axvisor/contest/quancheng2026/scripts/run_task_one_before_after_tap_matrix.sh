#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
contest_dir="$(cd "${script_dir}/.." && pwd)"
current_repo="$(cd "${script_dir}/../../../../.." && pwd)"
baseline_repo="/home/kali/qc-task1-before-1770-20260813"
linux_rt_samples=10000
linux_stress_workers_csv="0,2"
qemu_timeout_seconds=900
stamp="$(date +%Y%m%d_%H%M%S)"
evidence_root="/home/kali/qc-evidence/t1-before-after-tap-${stamp}"

usage() {
    cat <<'EOF'
Usage: run_task_one_before_after_tap_matrix.sh [options]

Options:
  --current-repo PATH      Current/private-PR tgoskits repository root.
  --baseline-repo PATH     Pre-#1770 baseline tgoskits repository root.
  --evidence-root PATH     Directory that will contain all matrix evidence.
  --linux-rt-samples N     Linux guest 1 ms periodic samples. Default: 10000.
  --workers CSV            Linux stress worker counts, for example 0,2. Default: 0,2.
  --timeout SECONDS        Timeout per AxVisor/QEMU run. Default: 900.
  -h, --help               Show this help.

This wrapper runs the task-one TAP/tcpdump before/after matrix in a consistent
shape:

  1. current branch, TAP, selected worker counts;
  2. pre-#1770 baseline branch, TAP, selected worker counts.

TAP mode creates bridge/TAP devices and tcpdump captures, so the caller must
authenticate sudo normally. No sudo password is stored or passed by this repo.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --current-repo)
            current_repo="$2"
            shift 2
            ;;
        --baseline-repo)
            baseline_repo="$2"
            shift 2
            ;;
        --evidence-root)
            evidence_root="$2"
            shift 2
            ;;
        --linux-rt-samples)
            linux_rt_samples="$2"
            shift 2
            ;;
        --workers)
            linux_stress_workers_csv="$2"
            shift 2
            ;;
        --timeout)
            qemu_timeout_seconds="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

for numeric_value in "${linux_rt_samples}" "${qemu_timeout_seconds}"; do
    if [[ ! "${numeric_value}" =~ ^[0-9]+$ ]]; then
        echo "numeric argument expected, got: ${numeric_value}" >&2
        exit 3
    fi
done

if [[ "${linux_rt_samples}" -lt 1 ]]; then
    echo "linux_rt_samples must be at least 1" >&2
    exit 3
fi

current_repo="$(cd "${current_repo}" && pwd)"
baseline_repo="$(cd "${baseline_repo}" && pwd)"
matrix_script="${contest_dir}/scripts/run_task_one_second_version_matrix.sh"

if [[ ! -x "${matrix_script}" ]]; then
    echo "matrix script is not executable: ${matrix_script}" >&2
    exit 4
fi

for repo in "${current_repo}" "${baseline_repo}"; do
    if [[ ! -d "${repo}/os/axvisor/contest/quancheng2026" ]]; then
        echo "contest directory not found in repo: ${repo}" >&2
        exit 4
    fi
done

echo "TAP before/after matrix selected; authenticating sudo with caller credentials."
sudo -v

mkdir -p "${evidence_root}"

after_root="${evidence_root}/after"
before_root="${evidence_root}/before"

"${matrix_script}" \
    --repo "${current_repo}" \
    --net-mode tap \
    --linux-rt-samples "${linux_rt_samples}" \
    --workers "${linux_stress_workers_csv}" \
    --timeout "${qemu_timeout_seconds}" \
    --label-prefix after \
    --evidence-root "${after_root}"

"${matrix_script}" \
    --repo "${baseline_repo}" \
    --net-mode tap \
    --linux-rt-samples "${linux_rt_samples}" \
    --workers "${linux_stress_workers_csv}" \
    --timeout "${qemu_timeout_seconds}" \
    --label-prefix before \
    --evidence-root "${before_root}"

cat <<EOF
TASK_ONE_BEFORE_AFTER_TAP_MATRIX=PASS
evidence_root=${evidence_root}
after_summary_csv=${after_root}/task-one-second-version-summary.csv
after_summary_md=${after_root}/task-one-second-version-summary.md
before_summary_csv=${before_root}/task-one-second-version-summary.csv
before_summary_md=${before_root}/task-one-second-version-summary.md
EOF
