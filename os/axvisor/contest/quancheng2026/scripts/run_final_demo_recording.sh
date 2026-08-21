#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
contest_dir="$(cd "${script_dir}/.." && pwd)"
net_mode="tap"
evidence_dir=""

usage() {
    cat <<'EOF'
Usage: run_final_demo_recording.sh [options]

Options:
  --net-mode MODE     tap (preferred) or hub. Default: tap.
  --evidence-dir PATH Store the run evidence at PATH.
  -h, --help          Show this help.

Run `sudo -v` in the same terminal before using TAP mode. The helper never
accepts or stores a password.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --net-mode)
            net_mode="$2"
            shift 2
            ;;
        --evidence-dir)
            evidence_dir="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "unknown_argument=$1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

if [[ "${net_mode}" != "tap" && "${net_mode}" != "hub" ]]; then
    echo "invalid_net_mode=${net_mode}" >&2
    exit 3
fi

if [[ -z "${evidence_dir}" ]]; then
    evidence_dir="/tmp/redcola-final-${net_mode}-$(date +%Y%m%d_%H%M%S)"
fi

if [[ "${net_mode}" == "tap" ]] && ! sudo -n true >/dev/null 2>&1; then
    echo "sudo_not_ready=run sudo -v in this terminal before recording" >&2
    exit 4
fi

cd "${contest_dir}"

echo "REDCOLA_FINAL_DEMO_MODE=${net_mode}"
echo "REDCOLA_FINAL_DEMO_EVIDENCE=${evidence_dir}"

"${script_dir}/run_axvisor_dual_guest_qcz1_ai.sh" \
    --net-mode "${net_mode}" \
    --evidence-dir "${evidence_dir}" \
    --timeout 180 \
    --linux-rt-samples 3000 \
    --linux-rt-period-ns 10000000 \
    --linux-stress-workers 2 \
    --linux-stress-seconds 0 \
    --linux-rt-cpu 0 \
    --linux-stress-cpu 1 \
    --linux-quiet

python3 "${script_dir}/analyze_dual_guest_realtime.py" \
    "${evidence_dir}" \
    --fail-on-missing

sed -n '1,180p' "${evidence_dir}/realtime-report.md"
echo "REDCOLA_FINAL_DEMO_RECORDING=PASS"
echo "evidence_dir=${evidence_dir}"
