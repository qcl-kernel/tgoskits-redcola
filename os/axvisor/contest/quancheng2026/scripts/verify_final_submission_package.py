#!/usr/bin/env python3
"""Verify the redcola final-submission package layout.

The verifier is intentionally conservative: it checks that required small
documents are present, generated/runtime artifacts are absent, and SHA256SUMS
covers each submitted file.
"""

from __future__ import annotations

import argparse
import hashlib
import re
import sys
from pathlib import Path


REQUIRED_FILES = [
    "README.txt",
    "PR-LINKS.txt",
    "SUBMISSION-MESSAGE.txt",
    "SHA256SUMS.txt",
    "docs/design.md",
    "docs/test-report.md",
    "docs/reproduce.md",
    "docs/evidence-index.md",
    "docs/scorecard-traceability.md",
    "docs/engineering-innovation-20-point-checklist.md",
    "docs/first-version-submission-status.md",
    "docs/first-version-submission-message.md",
    "docs/second-version-reviewer-quickstart.md",
    "docs/second-version-submission-status.md",
    "docs/second-version-submission-message.md",
    "docs/realtime-evaluation.md",
    "docs/task-one-realtime-core-claim.md",
    "docs/task-one-30-point-checklist.md",
    "docs/task-one-second-version-plan.md",
    "docs/task-one-score-summary.md",
    "docs/task-two-three-score-summary.md",
    "docs/task-two-three-50-point-checklist.md",
    "docs/protocol.md",
    "docs/network-topology.md",
    "docs/ai-control-evaluation.md",
    "docs/starryos-bonus.md",
    "docs/starryos-bonus-scorecard.md",
    "docs/core-patch-review.md",
    "docs/final-submission-checklist.md",
    "docs/final-submission-message.md",
    "docs/final-defense-brief-cn.md",
    "docs/reviewer-defense-qna.md",
    "docs/task-one-reviewer-defense-qna.md",
    "docs/demo-video-script.md",
    "docs/final-demo-acceptance-checklist.md",
    "docs/final-video-proof.md",
    "docs/final-video-cue-card-cn.md",
    "docs/final-demo-recording-runbook.md",
    "evidence-summaries/realtime-comparison.csv",
    "evidence-summaries/stability-summary.md",
    "evidence-summaries/task-one-before-after-hub-summary.csv",
    "evidence-summaries/task-one-before-after-hub-summary.md",
    "evidence-summaries/task-one-before-after-tap-summary.csv",
    "evidence-summaries/task-one-before-after-tap-summary.md",
    "evidence-summaries/task-one-current-head-long-hub-r30000-summary.csv",
    "evidence-summaries/task-one-current-head-long-hub-r30000-summary.md",
    "evidence-summaries/task-one-current-head-long-tap-r30000-summary.csv",
    "evidence-summaries/task-one-current-head-long-tap-r30000-summary.md",
    "evidence-summaries/task-one-current-head-long-tap4-r30000-summary.csv",
    "evidence-summaries/task-one-current-head-long-tap4-r30000-summary.md",
    "evidence-summaries/task-one-current-head-long-tap4-r30000-proof.txt",
    "evidence-summaries/task-one-latestdev-isolated-p10ms-summary.csv",
    "evidence-summaries/task-one-latestdev-isolated-p10ms-summary.md",
    "evidence-summaries/task-one-latestdev-isolated-p10ms-stability-3x-summary.csv",
    "evidence-summaries/task-one-latestdev-isolated-p10ms-stability-3x-summary.md",
    "evidence-summaries/task-one-latestdev0340-long-hub-r30000-summary.csv",
    "evidence-summaries/task-one-latestdev0340-long-hub-r30000-summary.md",
    "evidence-summaries/axvm-host-test-latestdev0340-summary.txt",
    "evidence-summaries/axvm-host-test-latestdev8e39-summary.txt",
    "evidence-summaries/final-demo-latestdev8e39-head17ee-summary.md",
    "evidence-summaries/task-three-second-metric-latestdev-summary.md",
]

STARRY_REQUIRED_FILES = [
    "starryos-bonus/README.md",
    "starryos-bonus/VALIDATION.md",
    "starryos-bonus/SCORECARD.md",
    "starryos-bonus/LATESTDEV-VALIDATION.txt",
]

PRESENTATION_REQUIRED_FILES = [
    "presentation/redcola-axvisor-demo.pptx",
    "presentation/redcola-axvisor-narration.docx",
]

FORBIDDEN_SUFFIXES = {
    ".bin",
    ".elf",
    ".img",
    ".iso",
    ".log",
    ".o",
    ".pcap",
    ".qcow2",
}

FORBIDDEN_PARTS = {
    "__pycache__",
    ".venv",
    "build",
    "target",
}

SECRET_PATTERNS = [
    re.compile(rb"BEGIN OPENSSH", re.IGNORECASE),
    re.compile(rb"BEGIN [A-Z0-9 ]*PRIVATE KEY", re.IGNORECASE),
    re.compile(rb"github_pat_[A-Za-z0-9_]+"),
    re.compile(rb"ghp_[A-Za-z0-9_]+"),
    re.compile(rb"SUDO_PASSWORD"),
    re.compile(rb"sudo-password"),
    re.compile(rb"sudo\s+-S"),
]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Verify a redcola final-submission package directory."
    )
    parser.add_argument("package_dir", type=Path, help="Path to redcola-final-submission")
    parser.add_argument(
        "--require-video",
        action="store_true",
        help="Require video/redcola-axvisor-demo.mp4 instead of accepting video/README.txt.",
    )
    parser.add_argument(
        "--require-starry",
        action="store_true",
        help="Require copied StarryOS bonus README.md and VALIDATION.md.",
    )
    parser.add_argument(
        "--require-presentation",
        action="store_true",
        help="Require the final PPTX and narration DOCX.",
    )
    return parser.parse_args()


def relpath(path: Path, root: Path) -> str:
    return path.relative_to(root).as_posix()


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def read_sha256s(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = line.strip()
        if not line:
            continue
        parts = line.split(maxsplit=1)
        if len(parts) != 2:
            raise ValueError(f"bad SHA256SUMS line: {line}")
        digest, name = parts
        name = name.lstrip("*")
        if name.startswith("./"):
            name = name[2:]
        values[name] = digest.lower()
    return values


def scan_secret(path: Path) -> str | None:
    data = path.read_bytes()
    for pattern in SECRET_PATTERNS:
        match = pattern.search(data)
        if match:
            return match.group(0).decode("utf-8", errors="replace")
    return None


def main() -> int:
    args = parse_args()
    root = args.package_dir.resolve()
    errors: list[str] = []

    if not root.is_dir():
        print(f"package_dir_missing={root}", file=sys.stderr)
        return 2

    required = list(REQUIRED_FILES)
    if args.require_video:
        required.append("video/redcola-axvisor-demo.mp4")
        required.append("video/METADATA.txt")
    elif not (root / "video/redcola-axvisor-demo.mp4").is_file():
        required.append("video/README.txt")
    if args.require_starry:
        required.extend(STARRY_REQUIRED_FILES)
    if args.require_presentation:
        required.extend(PRESENTATION_REQUIRED_FILES)

    for rel in required:
        if not (root / rel).is_file():
            errors.append(f"missing_required_file={rel}")

    files = sorted(path for path in root.rglob("*") if path.is_file())
    for path in files:
        rel = relpath(path, root)
        lower_parts = {part.lower() for part in Path(rel).parts}
        if path.suffix.lower() in FORBIDDEN_SUFFIXES:
            errors.append(f"forbidden_file_suffix={rel}")
        if lower_parts & FORBIDDEN_PARTS:
            errors.append(f"forbidden_path_part={rel}")
        secret = scan_secret(path)
        if secret:
            errors.append(f"forbidden_secret_pattern={rel}:{secret}")

    sha_path = root / "SHA256SUMS.txt"
    if sha_path.is_file():
        try:
            recorded = read_sha256s(sha_path)
        except ValueError as exc:
            errors.append(str(exc))
            recorded = {}
        expected_files = [relpath(path, root) for path in files if path.name != "SHA256SUMS.txt"]
        for rel in expected_files:
            if rel not in recorded:
                errors.append(f"sha256_missing_entry={rel}")
                continue
            actual = sha256_file(root / rel)
            if recorded[rel] != actual:
                errors.append(f"sha256_mismatch={rel}")
        for rel in recorded:
            if rel not in expected_files:
                errors.append(f"sha256_extra_entry={rel}")

    if errors:
        for error in errors:
            print(error, file=sys.stderr)
        print("FINAL_PACKAGE_VERIFY=FAIL")
        return 1

    print(f"FINAL_PACKAGE_VERIFY_DIR={root}")
    print(f"FINAL_PACKAGE_VERIFY_FILE_COUNT={len(files)}")
    print("FINAL_PACKAGE_VERIFY=PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
