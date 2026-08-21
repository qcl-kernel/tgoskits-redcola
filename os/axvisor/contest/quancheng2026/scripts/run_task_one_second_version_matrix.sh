#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
contest_dir="$(cd "${script_dir}/.." && pwd)"
repo="$(cd "${script_dir}/../../../../.." && pwd)"
net_mode="tap"
linux_rt_samples=10000
linux_rt_period_ns=1000000
linux_stress_workers_csv="0,2"
linux_rt_cpu=-1
linux_stress_cpu=-1
linux_quiet=0
qemu_timeout_seconds=900
label_prefix="after"
stamp="$(date +%Y%m%d_%H%M%S)"
evidence_root="/home/kali/qc-evidence/t1-matrix-${stamp}"

usage() {
    cat <<'EOF'
Usage: run_task_one_second_version_matrix.sh [options]

Options:
  --repo PATH              tgoskits repository root.
  --evidence-root PATH     Directory that will contain all matrix evidence.
  --net-mode MODE          Network backend: tap or hub. Default: tap.
  --linux-rt-samples N     Linux guest periodic sample count. Default: 10000.
  --linux-rt-period-ns N   Linux guest periodic interval in ns. Default: 1000000.
  --workers CSV            Linux stress worker counts, for example 0,2,4. Default: 0,2.
  --linux-rt-cpu CPU       Pin the periodic probe to guest CPU 0 or 1. Default: -1 (unbound).
  --linux-stress-cpu CPU   Pin stress workers to guest CPU 0 or 1. Default: -1 (unbound).
  --linux-quiet            Add quiet/loglevel=3 to the Linux guest command line.
  --timeout SECONDS        Timeout per AxVisor/QEMU run. Default: 900.
  --label-prefix LABEL     Prefix for summary labels, for example before or after. Default: after.
  -h, --help               Show this help.

This script runs the task-one second-version matrix for one repo/commit. Use it
once on the current branch with --label-prefix after, and once on the baseline
worktree with --label-prefix before. It writes per-run analysis plus a summary
CSV/Markdown table under --evidence-root.

TAP mode uses sudo for bridge/tap/tcpdump setup. The caller must authenticate
normally before or during this script, for example with sudo -v.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --repo)
            repo="$2"
            shift 2
            ;;
        --evidence-root)
            evidence_root="$2"
            shift 2
            ;;
        --net-mode)
            net_mode="$2"
            shift 2
            ;;
        --linux-rt-samples)
            linux_rt_samples="$2"
            shift 2
            ;;
        --linux-rt-period-ns)
            linux_rt_period_ns="$2"
            shift 2
            ;;
        --workers)
            linux_stress_workers_csv="$2"
            shift 2
            ;;
        --linux-rt-cpu)
            linux_rt_cpu="$2"
            shift 2
            ;;
        --linux-stress-cpu)
            linux_stress_cpu="$2"
            shift 2
            ;;
        --linux-quiet)
            linux_quiet=1
            shift
            ;;
        --timeout)
            qemu_timeout_seconds="$2"
            shift 2
            ;;
        --label-prefix)
            label_prefix="$2"
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

for numeric_value in "${linux_rt_samples}" "${linux_rt_period_ns}" "${qemu_timeout_seconds}"; do
    if [[ ! "${numeric_value}" =~ ^[0-9]+$ ]]; then
        echo "numeric argument expected, got: ${numeric_value}" >&2
        exit 3
    fi
done
for cpu_value in "${linux_rt_cpu}" "${linux_stress_cpu}"; do
    if [[ ! "${cpu_value}" =~ ^-?[0-9]+$ ]] || [[ "${cpu_value}" -lt -1 || "${cpu_value}" -gt 1 ]]; then
        echo "Linux guest CPU must be -1, 0, or 1; got: ${cpu_value}" >&2
        exit 3
    fi
done
if [[ "${linux_rt_samples}" -lt 1 ]]; then
    echo "linux_rt_samples must be at least 1" >&2
    exit 3
fi
if [[ "${linux_rt_period_ns}" -lt 100000 ]]; then
    echo "linux_rt_period_ns must be at least 100000" >&2
    exit 3
fi
case "${net_mode}" in
    tap|hub)
        ;;
    *)
        echo "net_mode must be tap or hub, got: ${net_mode}" >&2
        exit 3
        ;;
esac

repo="$(cd "${repo}" && pwd)"
target_contest_dir="${repo}/os/axvisor/contest/quancheng2026"
runner="${target_contest_dir}/scripts/run_axvisor_dual_guest_qcz1_ai.sh"
analyzer="${script_dir}/analyze_dual_guest_realtime.py"
summarizer="${script_dir}/summarize_task_one_evidence.py"

if [[ ! -x "${runner}" ]]; then
    echo "dual-guest runner is not executable: ${runner}" >&2
    exit 4
fi
for required in "${analyzer}" "${summarizer}"; do
    if [[ ! -f "${required}" ]]; then
        echo "required script not found: ${required}" >&2
        exit 4
    fi
done

if [[ "${net_mode}" == "tap" ]]; then
    echo "TAP mode selected; authenticating sudo with caller credentials."
    sudo -v
fi

mkdir -p "${evidence_root}"

IFS=',' read -r -a worker_values <<<"${linux_stress_workers_csv}"
summary_inputs=()

for worker in "${worker_values[@]}"; do
    worker="${worker//[[:space:]]/}"
    if [[ ! "${worker}" =~ ^[0-9]+$ ]]; then
        echo "worker count must be numeric, got: ${worker}" >&2
        exit 3
    fi

    run_stamp="$(date +%Y%m%d_%H%M%S)"
    label="${label_prefix}-${net_mode}-${worker}w-r${linux_rt_samples}-p${linux_rt_period_ns}-${run_stamp}"
    evidence_dir="${evidence_root}/${label}"
    monitor_path="${evidence_dir}/monitor.sock"
    if [[ "${#monitor_path}" -ge 108 ]]; then
        echo "evidence path is too long for QEMU monitor UNIX socket: ${monitor_path}" >&2
        echo "Use a shorter --evidence-root, for example /tmp/t1-${stamp}" >&2
        exit 5
    fi

    echo "--- TASK_ONE_MATRIX_RUN label=${label} ---"
    runner_args=(
        --repo "${repo}" \
        --net-mode "${net_mode}" \
        --linux-rt-samples "${linux_rt_samples}" \
        --linux-rt-period-ns "${linux_rt_period_ns}" \
        --linux-stress-workers "${worker}" \
        --linux-rt-cpu "${linux_rt_cpu}" \
        --linux-stress-cpu "${linux_stress_cpu}" \
        --timeout "${qemu_timeout_seconds}" \
        --evidence-dir "${evidence_dir}"
    )
    if [[ "${linux_quiet}" -eq 1 ]]; then
        runner_args+=(--linux-quiet)
    fi
    "${runner}" "${runner_args[@]}"

    python3 "${analyzer}" \
        --fail-on-missing \
        --json-out "${evidence_dir}/analysis.json" \
        --md-out "${evidence_dir}/analysis.md" \
        "${evidence_dir}"

    summary_inputs+=("${label}=${evidence_dir}")
done

python3 "${summarizer}" \
    --csv-out "${evidence_root}/task-one-second-version-summary.csv" \
    --md-out "${evidence_root}/task-one-second-version-summary.md" \
    "${summary_inputs[@]}"

cat <<EOF
TASK_ONE_SECOND_VERSION_MATRIX=PASS
evidence_root=${evidence_root}
summary_csv=${evidence_root}/task-one-second-version-summary.csv
summary_md=${evidence_root}/task-one-second-version-summary.md
EOF
