#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="$(cd "${script_dir}/../../../../.." && pwd)"
stamp="$(date +%Y%m%d_%H%M%S)"
linux_rt_samples=30000
linux_stress_workers_csv="2"
linux_rt_cpu=-1
linux_stress_cpu=-1
linux_quiet=0
qemu_timeout_seconds=1800
evidence_root="/tmp/t1ltap-${stamp}"
persist_root="/home/kali/qc-evidence/t1-current-head-long-tap-${stamp}"

usage() {
    cat <<'EOF'
Usage: run_task_one_current_head_long_tap_proof.sh [options]

Options:
  --repo PATH              Current/private-PR tgoskits repository root.
  --evidence-root PATH     Short runtime evidence root. Default: /tmp/t1ltap-<timestamp>.
  --persist-root PATH      Persistent evidence root copied after PASS.
                           Default: /home/kali/qc-evidence/t1-current-head-long-tap-<timestamp>.
  --linux-rt-samples N     Linux guest 1 ms periodic samples. Default: 30000.
  --workers CSV            Linux stress worker counts. Default: 2.
  --linux-rt-cpu CPU       Pin the periodic probe to guest CPU 0 or 1.
                           Default: -1 (unbound).
  --linux-stress-cpu CPU   Pin stress workers to guest CPU 0 or 1.
                           Default: -1 (unbound).
  --linux-quiet            Add quiet/loglevel=3 to the Linux guest command line.
  --timeout SECONDS        Timeout per AxVisor/QEMU run. Default: 1800.
  --no-persist             Do not copy the /tmp evidence tree after PASS.
  -h, --help               Show this help.

This wrapper records the redcola task-one current-head long TAP proof:

  - current/private PR source tree;
  - TAP/tcpdump networking;
  - long Linux periodic sample window;
  - Linux pressure;
  - UDP, QCZ1 and AI closed-loop markers.

TAP mode creates bridge/TAP devices and tcpdump captures, so the caller must
authenticate sudo normally, for example with `sudo -v`. This repository does
not store, pass or prompt for a sudo password.
EOF
}

no_persist=0

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
        --persist-root)
            persist_root="$2"
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
        --no-persist)
            no_persist=1
            shift
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

for cpu_value in "${linux_rt_cpu}" "${linux_stress_cpu}"; do
    if [[ ! "${cpu_value}" =~ ^-?[0-9]+$ ]] || (( cpu_value < -1 || cpu_value > 1 )); then
        echo "CPU argument must be -1, 0 or 1, got: ${cpu_value}" >&2
        exit 3
    fi
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

repo="$(cd "${repo}" && pwd)"
contest_dir="${repo}/os/axvisor/contest/quancheng2026"
matrix_script="${contest_dir}/scripts/run_task_one_second_version_matrix.sh"

if [[ ! -x "${matrix_script}" ]]; then
    echo "matrix script is not executable: ${matrix_script}" >&2
    exit 4
fi

source_head="$(cd "${repo}" && git rev-parse HEAD)"
source_branch="$(cd "${repo}" && git branch --show-current || true)"

echo "TAP current-head long proof selected; authenticating sudo with caller credentials."
sudo -v

if [[ -e "${evidence_root}" ]]; then
    echo "evidence root already exists: ${evidence_root}" >&2
    exit 5
fi
if [[ "${no_persist}" -eq 0 && -e "${persist_root}" ]]; then
    echo "persist root already exists: ${persist_root}" >&2
    exit 5
fi

matrix_args=(
    --repo "${repo}" \
    --net-mode tap \
    --linux-rt-samples "${linux_rt_samples}" \
    --workers "${linux_stress_workers_csv}" \
    --linux-rt-cpu "${linux_rt_cpu}" \
    --linux-stress-cpu "${linux_stress_cpu}" \
    --timeout "${qemu_timeout_seconds}" \
    --label-prefix current-head-long \
    --evidence-root "${evidence_root}"
)
if [[ "${linux_quiet}" -eq 1 ]]; then
    matrix_args+=(--linux-quiet)
fi
"${matrix_script}" "${matrix_args[@]}"

manifest="${evidence_root}/current-head-long-tap-proof.txt"
{
    echo "TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS"
    echo "source_branch=${source_branch}"
    echo "source_head=${source_head}"
    echo "linux_rt_samples=${linux_rt_samples}"
    echo "linux_stress_workers=${linux_stress_workers_csv}"
    echo "linux_rt_cpu=${linux_rt_cpu}"
    echo "linux_stress_cpu=${linux_stress_cpu}"
    echo "linux_quiet=${linux_quiet}"
    echo "net_mode=tap"
    echo "evidence_root=${evidence_root}"
    echo "summary_csv=${evidence_root}/task-one-second-version-summary.csv"
    echo "summary_md=${evidence_root}/task-one-second-version-summary.md"
    sha256sum "${evidence_root}/task-one-second-version-summary.csv"
    sha256sum "${evidence_root}/task-one-second-version-summary.md"
} >"${manifest}"

if [[ "${no_persist}" -eq 0 ]]; then
    mkdir -p "$(dirname "${persist_root}")"
    cp -a "${evidence_root}" "${persist_root}"
    persisted_manifest="${persist_root}/current-head-long-tap-proof.txt"
    {
        echo "persisted_evidence_root=${persist_root}"
        sha256sum "${persist_root}/task-one-second-version-summary.csv"
        sha256sum "${persist_root}/task-one-second-version-summary.md"
    } >>"${persisted_manifest}"
fi

cat <<EOF
TASK_ONE_CURRENT_HEAD_LONG_TAP_PROOF=PASS
source_branch=${source_branch}
source_head=${source_head}
linux_rt_cpu=${linux_rt_cpu}
linux_stress_cpu=${linux_stress_cpu}
linux_quiet=${linux_quiet}
evidence_root=${evidence_root}
persisted_evidence_root=$([[ "${no_persist}" -eq 0 ]] && echo "${persist_root}" || echo "disabled")
summary_csv=${evidence_root}/task-one-second-version-summary.csv
summary_md=${evidence_root}/task-one-second-version-summary.md
EOF
