#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="$(cd "${script_dir}/../../../../.." && pwd)"
out_dir=""
package_name="redcola-final-submission"
starry_dir=""
starry_latest_validation=""
evidence_dir=""
video_path=""
video_metadata_path=""
presentation_path=""
narration_script_path=""
submission_branch=""

usage() {
    cat <<'EOF'
Usage: build_final_submission_package.sh [options]

Options:
  --repo PATH         tgoskits repository root. Default: auto-detected.
  --out PATH          Output directory. Default: <repo>/tmp/redcola-final-submission.
  --package-name NAME Package directory name. Default: redcola-final-submission.
  --starry-dir PATH   Optional StarryOS bonus demo directory containing README.md and VALIDATION.md.
  --starry-latest-validation PATH
                      Optional latest-dev StarryOS validation record.
  --evidence-dir PATH Optional final-video rehearsal evidence directory.
  --video PATH        Optional final demo video file to include.
  --video-metadata PATH
                      Optional output from verify_demo_video.py.
  --presentation PATH Optional final presentation (.pptx) to include.
  --narration-script PATH
                      Optional final narration script (.docx) to include.
  --submission-branch NAME
                      Branch reviewers should use for the submitted PR. By
                      default the current local branch is recorded.
  -h, --help          Show this help.

The package intentionally includes source-facing docs, small summaries, links
and hashes. It excludes raw logs, pcaps, QEMU images, kernels, caches and
credentials.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --repo)
            repo="$2"
            shift 2
            ;;
        --out)
            out_dir="$2"
            shift 2
            ;;
        --package-name)
            package_name="$2"
            shift 2
            ;;
        --starry-dir)
            starry_dir="$2"
            shift 2
            ;;
        --starry-latest-validation)
            starry_latest_validation="$2"
            shift 2
            ;;
        --evidence-dir)
            evidence_dir="$2"
            shift 2
            ;;
        --video)
            video_path="$2"
            shift 2
            ;;
        --video-metadata)
            video_metadata_path="$2"
            shift 2
            ;;
        --presentation)
            presentation_path="$2"
            shift 2
            ;;
        --narration-script)
            narration_script_path="$2"
            shift 2
            ;;
        --submission-branch)
            submission_branch="$2"
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

repo="$(cd "${repo}" && pwd)"
contest_dir="${repo}/os/axvisor/contest/quancheng2026"
if [[ -z "${out_dir}" ]]; then
    out_dir="${repo}/tmp/${package_name}"
fi
package_dir="${out_dir%/}/${package_name}"

if [[ ! -d "${contest_dir}" ]]; then
    echo "missing_contest_dir=${contest_dir}" >&2
    exit 10
fi

need_tool() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "missing_required_tool=$1" >&2
        exit 11
    fi
}

need_file() {
    if [[ ! -f "$1" ]]; then
        echo "missing_required_file=$1" >&2
        exit 12
    fi
}

copy_file() {
    local src="$1"
    local dst="$2"
    need_file "${src}"
    mkdir -p "$(dirname "${dst}")"
    cp "${src}" "${dst}"
}

need_tool sha256sum
need_tool git

rm -rf "${package_dir}"
mkdir -p \
    "${package_dir}/docs" \
    "${package_dir}/evidence-summaries" \
    "${package_dir}/presentation" \
    "${package_dir}/starryos-bonus" \
    "${package_dir}/video"

main_head="$(cd "${repo}" && git rev-parse HEAD)"
main_branch="$(cd "${repo}" && git branch --show-current || true)"
if [[ -n "${submission_branch}" ]]; then
    main_branch="${submission_branch}"
fi

cat >"${package_dir}/README.txt" <<EOF
redcola final submission package

Private repository:
https://github.com/qcl-kernel/tgoskits-redcola

Main PR:
https://github.com/qcl-kernel/tgoskits-redcola/pull/1

StarryOS bonus PR:
https://github.com/qcl-kernel/tgoskits-redcola/pull/2

Main branch:
${main_branch}

Main head:
${main_head}

This package contains source-facing documents, small result summaries, optional
video/evidence summaries and SHA256 hashes. It intentionally excludes raw QEMU
logs, pcaps, runtime images, kernels, build caches and credentials.
EOF

cat >"${package_dir}/PR-LINKS.txt" <<'EOF'
Private repository:
https://github.com/qcl-kernel/tgoskits-redcola

Main AxVisor contest PR:
https://github.com/qcl-kernel/tgoskits-redcola/pull/1

StarryOS bonus PR:
https://github.com/qcl-kernel/tgoskits-redcola/pull/2

Merged AxVisor core support:
https://github.com/rcore-os/tgoskits/pull/1770
EOF

copy_file "${contest_dir}/docs/final-submission-message.md" "${package_dir}/SUBMISSION-MESSAGE.txt"

doc_files=(
    design.md
    test-report.md
    reproduce.md
    evidence-index.md
    scorecard-traceability.md
    reviewer-defense-qna.md
    engineering-innovation-20-point-checklist.md
    first-version-submission-status.md
    first-version-submission-message.md
    second-version-reviewer-quickstart.md
    second-version-submission-status.md
    second-version-submission-message.md
    realtime-evaluation.md
    task-one-realtime-core-claim.md
    task-one-reviewer-defense-qna.md
    task-one-30-point-checklist.md
    task-one-second-version-plan.md
    task-one-score-summary.md
    task-two-three-score-summary.md
    task-two-three-50-point-checklist.md
    protocol.md
    network-topology.md
    ai-control-evaluation.md
    starryos-bonus.md
    starryos-bonus-scorecard.md
    core-patch-review.md
    final-submission-checklist.md
    final-submission-message.md
    final-defense-brief-cn.md
    demo-video-script.md
    final-demo-acceptance-checklist.md
    final-video-proof.md
    final-video-cue-card-cn.md
    final-demo-recording-runbook.md
)

for doc in "${doc_files[@]}"; do
    copy_file "${contest_dir}/docs/${doc}" "${package_dir}/docs/${doc}"
done

summary_files=(
    "results/task-one-second-version-summary.csv"
    "results/task-one-second-version-summary.md"
    "results/task-one-before-after-hub-summary.csv"
    "results/task-one-before-after-hub-summary.md"
    "results/task-one-before-after-tap-summary.csv"
    "results/task-one-before-after-tap-summary.md"
    "results/task-one-current-head-long-hub-r30000-summary.csv"
    "results/task-one-current-head-long-hub-r30000-summary.md"
    "results/task-one-current-head-long-hub4-r30000-summary.csv"
    "results/task-one-current-head-long-hub4-r30000-summary.md"
    "results/task-one-current-head-long-hub4-r30000-proof.txt"
    "results/task-one-current-head-long-tap-r30000-summary.csv"
    "results/task-one-current-head-long-tap-r30000-summary.md"
    "results/task-one-current-head-long-tap4-r30000-summary.csv"
    "results/task-one-current-head-long-tap4-r30000-summary.md"
    "results/task-one-current-head-long-tap4-r30000-proof.txt"
    "results/task-one-head746-2w-hub-stability-r30000-summary.csv"
    "results/task-one-head746-2w-hub-stability-r30000-summary.md"
    "results/task-one-latestdev-isolated-p10ms-summary.csv"
    "results/task-one-latestdev-isolated-p10ms-summary.md"
    "results/task-one-latestdev-isolated-p10ms-stability-3x-summary.csv"
    "results/task-one-latestdev-isolated-p10ms-stability-3x-summary.md"
    "results/task-one-latestdev0340-long-hub-r30000-summary.csv"
    "results/task-one-latestdev0340-long-hub-r30000-summary.md"
    "results/axvm-host-test-latestdev0340-summary.txt"
    "results/axvm-host-test-latestdev8e39-summary.txt"
    "results/final-demo-latestdev8e39-head17ee-summary.md"
    "results/task-three-second-metric-latestdev-summary.md"
    "results/realtime-comparison.csv"
    "results/stability/2026-07-27-stress2-3x/stability-summary.md"
)

for rel in "${summary_files[@]}"; do
    src="${contest_dir}/${rel}"
    if [[ -f "${src}" ]]; then
        dst_name="$(basename "${rel}")"
        copy_file "${src}" "${package_dir}/evidence-summaries/${dst_name}"
    else
        echo "missing_optional_summary=${rel}" >>"${package_dir}/README.txt"
    fi
done

if [[ -n "${evidence_dir}" ]]; then
    evidence_dir="$(cd "${evidence_dir}" && pwd)"
    report_src=""
    summary_src=""
    if [[ -f "${evidence_dir}/realtime-report.md" ]]; then
        report_src="${evidence_dir}/realtime-report.md"
    elif [[ -f "${evidence_dir}/analysis.md" ]]; then
        report_src="${evidence_dir}/analysis.md"
    fi
    if [[ -f "${evidence_dir}/realtime-summary.json" ]]; then
        summary_src="${evidence_dir}/realtime-summary.json"
    elif [[ -f "${evidence_dir}/analysis.json" ]]; then
        summary_src="${evidence_dir}/analysis.json"
    fi
    if [[ -n "${report_src}" ]]; then
        copy_file "${report_src}" \
            "${package_dir}/evidence-summaries/demo-hub-rehearsal-analysis.md"
    fi
    if [[ -n "${summary_src}" ]]; then
        copy_file "${summary_src}" \
            "${package_dir}/evidence-summaries/demo-hub-rehearsal-analysis.json"
    fi
    if [[ -f "${evidence_dir}/runner.log" ]]; then
        sha256sum "${evidence_dir}/runner.log" >"${package_dir}/evidence-summaries/demo-hub-rehearsal-runner-log.sha256"
    fi
fi

if [[ -n "${starry_dir}" ]]; then
    starry_dir="$(cd "${starry_dir}" && pwd)"
    copy_file "${starry_dir}/README.md" "${package_dir}/starryos-bonus/README.md"
    copy_file "${starry_dir}/VALIDATION.md" "${package_dir}/starryos-bonus/VALIDATION.md"
    if [[ -f "${starry_dir}/REVIEWER-QUICKSTART.md" ]]; then
        copy_file "${starry_dir}/REVIEWER-QUICKSTART.md" "${package_dir}/starryos-bonus/REVIEWER-QUICKSTART.md"
    fi
    if [[ -f "${starry_dir}/SCORECARD.md" ]]; then
        copy_file "${starry_dir}/SCORECARD.md" "${package_dir}/starryos-bonus/SCORECARD.md"
    fi
    if [[ -f "${starry_dir}/LATESTDEV-VALIDATION.txt" ]]; then
        copy_file "${starry_dir}/LATESTDEV-VALIDATION.txt" \
            "${package_dir}/starryos-bonus/LATESTDEV-VALIDATION.txt"
    fi
else
    cat >"${package_dir}/starryos-bonus/README.txt" <<'EOF'
StarryOS bonus material is submitted separately in private PR #2:
https://github.com/qcl-kernel/tgoskits-redcola/pull/2

Pass --starry-dir <apps/starry/qemu/redcola-ai-control> to copy README.md,
VALIDATION.md and optional reviewer/scorecard notes into this final package.
EOF
fi

if [[ -n "${starry_latest_validation}" ]]; then
    starry_latest_validation="$(cd "$(dirname "${starry_latest_validation}")" && pwd)/$(basename "${starry_latest_validation}")"
    copy_file "${starry_latest_validation}" \
        "${package_dir}/starryos-bonus/LATESTDEV-VALIDATION.txt"
fi

if [[ -n "${video_path}" ]]; then
    video_path="$(cd "$(dirname "${video_path}")" && pwd)/$(basename "${video_path}")"
    copy_file "${video_path}" "${package_dir}/video/redcola-axvisor-demo.mp4"
else
    cat >"${package_dir}/video/README.txt" <<'EOF'
Final demo video is required for the 2026-08-24 final package.
Record it from docs/demo-video-script.md and rebuild this package with:

  --video /path/to/redcola-axvisor-demo.mp4
EOF
fi

if [[ -n "${video_metadata_path}" ]]; then
    video_metadata_path="$(cd "$(dirname "${video_metadata_path}")" && pwd)/$(basename "${video_metadata_path}")"
    copy_file "${video_metadata_path}" "${package_dir}/video/METADATA.txt"
fi

if [[ -n "${presentation_path}" ]]; then
    presentation_path="$(cd "$(dirname "${presentation_path}")" && pwd)/$(basename "${presentation_path}")"
    copy_file "${presentation_path}" \
        "${package_dir}/presentation/redcola-axvisor-demo.pptx"
fi

if [[ -n "${narration_script_path}" ]]; then
    narration_script_path="$(cd "$(dirname "${narration_script_path}")" && pwd)/$(basename "${narration_script_path}")"
    copy_file "${narration_script_path}" \
        "${package_dir}/presentation/redcola-axvisor-narration.docx"
fi

if [[ -z "${presentation_path}" || -z "${narration_script_path}" ]]; then
    cat >"${package_dir}/presentation/README.txt" <<'EOF'
The final presentation and narration script are required for the selected
user-narrated delivery. Rebuild with both --presentation and
--narration-script before final upload.
EOF
fi

(
    cd "${package_dir}"
    find . -type f \
        ! -name SHA256SUMS.txt \
        ! -name '*.pcap' \
        ! -name '*.log' \
        ! -name '*.img' \
        ! -name '*.qcow2' \
        ! -name '*.elf' \
        ! -name '*.bin' \
        -print0 | sort -z | xargs -0 sha256sum
) >"${package_dir}/SHA256SUMS.txt"

echo "FINAL_PACKAGE_DIR=${package_dir}"
echo "FINAL_PACKAGE_FILE_COUNT=$(find "${package_dir}" -type f | wc -l | tr -d ' ')"
echo "FINAL_PACKAGE_BUILD=PASS"
