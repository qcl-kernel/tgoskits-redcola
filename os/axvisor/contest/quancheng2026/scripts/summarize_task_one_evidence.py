#!/usr/bin/env python3
"""Summarize multiple task-one AxVisor evidence directories.

Each input can be either:

  LABEL=/path/to/evidence
  /path/to/evidence

The script reuses the single-run parser from analyze_dual_guest_realtime.py and
emits a compact reviewer-facing table for before/after and stress comparisons.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import sys
from pathlib import Path
from typing import Any

from analyze_dual_guest_realtime import (
    parse_bridge_info,
    parse_qemu_log,
    parse_tcpdump,
    read_final_result,
)


REQUIRED_MARKERS = {
    "QC_RT_PERIODIC_RESULT=PASS",
    "QC_RTOS_PERIODIC_RESULT=PASS",
    "QC_DUAL_GUEST_UDP_ECHO_RESULT=PASS",
    "QC_QCZ1_RELIABLE_RESULT=PASS",
    "QC_AI_CONTROL_RESULT=PASS",
    "QC_QCZ1_GUEST_DEMO=PASS",
    "QC_DUAL_GUEST_LINUX_INIT=PASS",
}


def parse_input(value: str) -> tuple[str, Path]:
    if "=" in value and not Path(value).exists():
        label, path = value.split("=", 1)
        return label.strip(), Path(path).expanduser().resolve()
    path = Path(value).expanduser().resolve()
    return path.name, path


def file_sha256(path: Path) -> str:
    if not path.exists():
        return "n/a"
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def metric(metrics: dict[str, str], key: str) -> str:
    return metrics.get(key, "n/a")


def fmt_value(value: Any) -> str:
    if value is None:
        return "n/a"
    if isinstance(value, float) and value.is_integer():
        return str(int(value))
    return str(value)


def latency_pair(item: dict[str, Any], *names: str) -> str:
    return " / ".join(fmt_value(item.get(name)) for name in names)


def success_text(pass_count: int, fail_count: int) -> str:
    total = pass_count + fail_count
    return f"{pass_count}/{total}" if total else "n/a"


def analyze_one(label: str, evidence_dir: Path) -> dict[str, str]:
    qemu_log = evidence_dir / "qemu.log"
    if not qemu_log.exists():
        raise SystemExit(f"missing qemu log for {label}: {qemu_log}")

    report = parse_qemu_log(qemu_log)
    metrics: dict[str, str] = report["metrics"]  # type: ignore[assignment]
    counts: dict[str, int] = report["counts"]  # type: ignore[assignment]
    latency: dict[str, dict[str, Any]] = report["latency_us"]  # type: ignore[assignment]
    bridge = parse_bridge_info(evidence_dir / "bridge.txt")
    tcpdump = parse_tcpdump(evidence_dir / "tcpdump.log")
    markers = set(report["markers"])  # type: ignore[arg-type]
    missing = sorted(REQUIRED_MARKERS - markers)
    analysis_result = "PASS" if not missing else "FAIL"
    final_result = read_final_result(evidence_dir, analysis_result)

    return {
        "label": label,
        "evidence_dir": str(evidence_dir),
        "final_result": final_result,
        "analysis_result": analysis_result,
        "missing_markers": ",".join(missing) if missing else "none",
        "net_mode": bridge.get("net_mode", "n/a"),
        "linux_workers": metric(metrics, "QC_LINUX_STRESS_CONFIG_WORKERS"),
        "linux_vcpus": metric(metrics, "QC_CPUINFO_PROCESSORS"),
        "linux_cpu_online": metric(metrics, "QC_CPU_ONLINE"),
        "linux_mean_p99_max_ns": " / ".join(
            [
                metric(metrics, "QC_RT_LATENCY_MEAN_NS"),
                metric(metrics, "QC_RT_LATENCY_P99_NS"),
                metric(metrics, "QC_RT_LATENCY_MAX_NS"),
            ]
        ),
        "rtos_mean_p99_max_ns": " / ".join(
            [
                metric(metrics, "QC_RTOS_LATENCY_MEAN_NS"),
                metric(metrics, "QC_RTOS_LATENCY_P99_NS"),
                metric(metrics, "QC_RTOS_LATENCY_MAX_NS"),
            ]
        ),
        "udp_success": success_text(counts["udp_pass"], counts["udp_fail"]),
        "udp_mean_max_us": latency_pair(latency["plain_udp_rtt"], "mean", "max"),
        "qcz1_success": success_text(counts["qcz1_ack"], counts["qcz1_fail"]),
        "qcz1_retransmits": metric(metrics, "QC_QCZ1_RETRANSMITS"),
        "qcz1_duplicate_acks": str(counts["duplicate_ack_samples"]),
        "qcz1_mean_max_us": latency_pair(latency["qcz1_ack"], "mean", "max"),
        "ai_success": success_text(counts["ai_pass"], counts["ai_fail"]),
        "ai_e2e_mean_max_us": latency_pair(latency["ai_end_to_end"], "mean", "max"),
        "tcpdump_captured": fmt_value(tcpdump.get("packets_captured")),
        "tcpdump_dropped": fmt_value(tcpdump.get("packets_dropped_by_kernel")),
        "summary_sha256": file_sha256(evidence_dir / "summary.txt"),
        "qemu_log_sha256": file_sha256(qemu_log),
    }


def write_csv(rows: list[dict[str, str]], path: Path) -> None:
    if not rows:
        path.write_text("", encoding="utf-8")
        return
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def write_markdown(rows: list[dict[str, str]], path: Path) -> None:
    lines = [
        "# Task-One Evidence Summary",
        "",
        "| Label | Result | Net | Linux workers | Linux vCPUs | RTOS mean/p99/max ns | Linux mean/p99/max ns | UDP | QCZ1 | Retransmits | Duplicate ACKs | AI | AI e2e mean/max us | tcpdump captured/dropped |",
        "| --- | --- | --- | ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:| ---:|",
    ]
    for row in rows:
        lines.append(
            "| {label} | `{final_result}` | `{net_mode}` | `{linux_workers}` | `{linux_vcpus}` | `{rtos_mean_p99_max_ns}` | `{linux_mean_p99_max_ns}` | `{udp_success}` | `{qcz1_success}` | `{qcz1_retransmits}` | `{qcz1_duplicate_acks}` | `{ai_success}` | `{ai_e2e_mean_max_us}` | `{tcpdump_captured}/{tcpdump_dropped}` |".format(
                **row
            )
        )
    lines.extend(
        [
            "",
            "## Evidence Hashes",
            "",
            "| Label | Evidence dir | Summary SHA256 | QEMU log SHA256 | Missing markers |",
            "| --- | --- | --- | --- | --- |",
        ]
    )
    for row in rows:
        lines.append(
            "| {label} | `{evidence_dir}` | `{summary_sha256}` | `{qemu_log_sha256}` | `{missing_markers}` |".format(
                **row
            )
        )
    lines.append("")
    path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("evidence", nargs="+", help="Evidence dir or LABEL=dir")
    parser.add_argument("--csv-out", type=Path)
    parser.add_argument("--md-out", type=Path)
    args = parser.parse_args()

    rows = [analyze_one(*parse_input(item)) for item in args.evidence]

    if args.csv_out:
        write_csv(rows, args.csv_out)
        print(f"csv_out={args.csv_out}")
    if args.md_out:
        write_markdown(rows, args.md_out)
        print(f"md_out={args.md_out}")
    if not args.csv_out and not args.md_out:
        writer = csv.DictWriter(sys.stdout, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
