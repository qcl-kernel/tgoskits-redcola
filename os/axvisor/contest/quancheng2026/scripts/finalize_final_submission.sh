#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="$(cd "${script_dir}/../../../../.." && pwd)"
out_dir=""
video=""
presentation=""
narration_script=""
starry_dir=""
starry_latest_validation=""
evidence_dir=""
submission_branch="contest/axvisor-2026"

usage() {
    cat <<'EOF'
Usage: finalize_final_submission.sh --out PATH --video PATH \
  --presentation PATH --narration-script PATH --starry-dir PATH [options]

Options:
  --repo PATH
  --out PATH
  --video PATH
  --presentation PATH
  --narration-script PATH
  --starry-dir PATH
  --starry-latest-validation PATH
  --evidence-dir PATH
  --submission-branch NAME
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --repo) repo="$2"; shift 2 ;;
        --out) out_dir="$2"; shift 2 ;;
        --video) video="$2"; shift 2 ;;
        --presentation) presentation="$2"; shift 2 ;;
        --narration-script) narration_script="$2"; shift 2 ;;
        --starry-dir) starry_dir="$2"; shift 2 ;;
        --starry-latest-validation) starry_latest_validation="$2"; shift 2 ;;
        --evidence-dir) evidence_dir="$2"; shift 2 ;;
        --submission-branch) submission_branch="$2"; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
    esac
done

for value in out_dir video presentation narration_script starry_dir starry_latest_validation; do
    if [[ -z "${!value}" ]]; then
        echo "missing_required_argument=--${value//_/-}" >&2
        exit 2
    fi
done

repo="$(cd "${repo}" && pwd)"
mkdir -p "${out_dir}"
out_dir="$(cd "${out_dir}" && pwd)"
package_name="redcola-final-submission"
package_dir="${out_dir}/${package_name}"
archive="${out_dir}/${package_name}.zip"
fresh_dir="${out_dir}/fresh-unzip-check"
video_metadata="${out_dir}/final-video-metadata.txt"

python3 "${script_dir}/verify_demo_video.py" "${video}" --output "${video_metadata}"

build_args=(
    --repo "${repo}"
    --out "${out_dir}"
    --package-name "${package_name}"
    --starry-dir "${starry_dir}"
    --starry-latest-validation "${starry_latest_validation}"
    --video "${video}"
    --video-metadata "${video_metadata}"
    --presentation "${presentation}"
    --narration-script "${narration_script}"
    --submission-branch "${submission_branch}"
)
if [[ -n "${evidence_dir}" ]]; then
    build_args+=(--evidence-dir "${evidence_dir}")
fi
"${script_dir}/build_final_submission_package.sh" "${build_args[@]}"

verify_args=(--require-video --require-starry --require-presentation)
python3 "${script_dir}/verify_final_submission_package.py" \
    "${package_dir}" "${verify_args[@]}"

rm -f "${archive}" "${archive}.sha256"
python3 - "${package_dir}" "${archive}" <<'PY'
import sys
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

source = Path(sys.argv[1]).resolve()
archive = Path(sys.argv[2]).resolve()
with ZipFile(archive, "w", compression=ZIP_DEFLATED, compresslevel=9) as output:
    for path in sorted(source.rglob("*")):
        if path.is_file():
            output.write(path, Path(source.name) / path.relative_to(source))
PY
(
    cd "${out_dir}"
    sha256sum "$(basename "${archive}")"
) >"${archive}.sha256"

rm -rf "${fresh_dir}"
mkdir -p "${fresh_dir}"
python3 - "${archive}" "${fresh_dir}" <<'PY'
import sys
from pathlib import Path
from zipfile import ZipFile

with ZipFile(Path(sys.argv[1]).resolve()) as archive:
    archive.extractall(Path(sys.argv[2]).resolve())
PY
python3 "${script_dir}/verify_final_submission_package.py" \
    "${fresh_dir}/${package_name}" "${verify_args[@]}"

echo "FINAL_SUBMISSION_PACKAGE=${package_dir}"
echo "FINAL_SUBMISSION_ARCHIVE=${archive}"
echo "FINAL_SUBMISSION_ARCHIVE_SHA256_FILE=${archive}.sha256"
echo "FINAL_SUBMISSION_FRESH_UNZIP_VERIFY=PASS"
echo "FINAL_SUBMISSION_FINALIZE=PASS"
