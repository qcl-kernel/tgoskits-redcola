#!/usr/bin/env python3
"""Analyze the committed ATK-DLRK3588 native-Linux cyclictest evidence."""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Any


SCENARIOS = (
    ("Idle", "idle-cpu7.json"),
    ("Isolated stress", "isolated-stress-cpu7.json"),
    ("Full stress", "full-stress-cpu7.json"),
)

PERCENTILES = (
    ("p50_us", 50, 100),
    ("p90_us", 90, 100),
    ("p99_us", 99, 100),
    ("p99_9_us", 999, 1_000),
    ("p99_99_us", 9_999, 10_000),
    ("p99_999_us", 99_999, 100_000),
)

TAIL_THRESHOLDS = (50, 100, 500, 1_000)

CSV_FIELDS = (
    "scenario",
    "cycles",
    "min_us",
    "avg_us",
    "p50_us",
    "p90_us",
    "p99_us",
    "p99_9_us",
    "p99_99_us",
    "p99_999_us",
    "max_us",
    "gt50_count",
    "gt100_count",
    "gt500_count",
    "gt1000_count",
    "gt50_ppm",
    "gt100_ppm",
    "gt500_ppm",
    "gt1000_ppm",
    "histogram_overflows",
    "return_code",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("evidence_dir", type=Path)
    parser.add_argument("--csv-output", type=Path, required=True)
    parser.add_argument("--markdown-output", type=Path, required=True)
    return parser.parse_args()


def nearest_rank(histogram: dict[int, int], cycles: int, numerator: int, denominator: int) -> int:
    rank = (cycles * numerator + denominator - 1) // denominator
    cumulative = 0
    for latency_us, count in sorted(histogram.items()):
        cumulative += count
        if cumulative >= rank:
            return latency_us
    raise ValueError(f"percentile rank {rank} exceeds histogram sample count")


def format_number(value: float) -> str:
    return f"{value:.6f}".rstrip("0").rstrip(".")


def read_scenario(evidence_dir: Path, scenario: str, filename: str) -> dict[str, Any]:
    path = evidence_dir / filename
    if not path.is_file():
        raise FileNotFoundError(f"missing evidence file: {path}")

    data = json.loads(path.read_text(encoding="utf-8"))
    return_code = int(data.get("return_code", -1))
    if return_code != 0:
        raise ValueError(f"{filename}: cyclictest return_code={return_code}")

    threads = data.get("thread")
    if not isinstance(threads, dict) or len(threads) != 1:
        raise ValueError(f"{filename}: expected exactly one cyclictest thread")
    thread = next(iter(threads.values()))
    if not isinstance(thread, dict):
        raise ValueError(f"{filename}: invalid thread object")

    cycles = int(thread["cycles"])
    raw_histogram = thread.get("histogram")
    if not isinstance(raw_histogram, dict):
        raise ValueError(f"{filename}: missing histogram")
    histogram = {int(latency): int(count) for latency, count in raw_histogram.items()}
    histogram_samples = sum(histogram.values())
    histogram_overflows = cycles - histogram_samples
    if histogram_overflows != 0:
        raise ValueError(
            f"{filename}: histogram has {histogram_samples} samples for {cycles} cycles "
            f"(implied overflows={histogram_overflows})"
        )

    row: dict[str, Any] = {
        "scenario": scenario,
        "cycles": cycles,
        "min_us": int(thread["min"]),
        "avg_us": format_number(float(thread["avg"])),
        "max_us": int(thread["max"]),
        "histogram_overflows": histogram_overflows,
        "return_code": return_code,
    }
    for field, numerator, denominator in PERCENTILES:
        row[field] = nearest_rank(histogram, cycles, numerator, denominator)

    for threshold in TAIL_THRESHOLDS:
        count = sum(count for latency, count in histogram.items() if latency > threshold)
        row[f"gt{threshold}_count"] = count
        row[f"gt{threshold}_ppm"] = format_number(count * 1_000_000 / cycles)

    return row


def write_csv(rows: list[dict[str, Any]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=CSV_FIELDS, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_markdown(rows: list[dict[str, Any]], path: Path) -> None:
    idle = rows[0]
    isolated = rows[1]
    full = rows[2]
    full_max_ratio = full["max_us"] / idle["max_us"]
    full_avg_delta = (float(full["avg_us"]) / float(idle["avg_us"]) - 1) * 100
    isolated_max_delta = (isolated["max_us"] / idle["max_us"] - 1) * 100
    isolated_avg_delta = (float(isolated["avg_us"]) / float(idle["avg_us"]) - 1) * 100

    lines = [
        "# ATK-DLRK3588 Native Linux Cyclictest Summary",
        "",
        "## Scope",
        "",
        "This is a physical-board **native Linux baseline**, not an AxVisor-on-RK3588 result.",
        "The board is an ALIENTEK ATK-DLRK3588B V1.1 (RK3588, 8 GiB) running its",
        "factory Buildroot image and Linux 5.10.160. The current tgoskits supported-board",
        "list does not include this exact board. AxVisor mixed-guest results remain the",
        "separate version-pinned QEMU evidence; the native Zephyr baseline also remains separate.",
        "",
        "## Method",
        "",
        "- `cyclictest` 2.20, `SCHED_FIFO` priority 95, 1 ms interval.",
        "- Measurement thread pinned to CPU7; cyclictest main thread pinned to CPU6.",
        "- 300,000 cycles per scenario (approximately five minutes), 900,000 cycles total.",
        "- Idle: no synthetic stress workload.",
        "- Isolated stress: stress workers on CPUs 0-6 while cyclictest remains on CPU7.",
        "- Full stress: stress workers cover CPUs 0-7, including the measurement CPU.",
        "- Percentiles use the deterministic nearest-rank definition over the JSON histogram.",
        "- All three runs returned zero and the histogram sample count equals the cycle count.",
        "",
        "## Results",
        "",
        "| Scenario | Cycles | Min us | Avg us | P50 | P90 | P99 | P99.9 | P99.99 | P99.999 | Max us | >50 us ppm | >100 us ppm | >500 us ppm | >1000 us ppm |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for row in rows:
        lines.append(
            "| {scenario} | {cycles} | {min_us} | {avg_us} | {p50_us} | {p90_us} | "
            "{p99_us} | {p99_9_us} | {p99_99_us} | {p99_999_us} | {max_us} | "
            "{gt50_ppm} | {gt100_ppm} | {gt500_ppm} | {gt1000_ppm} |".format(**row)
        )

    lines.extend(
        [
            "",
            "## Interpretation",
            "",
            f"- Full stress raised the maximum from {idle['max_us']} us to {full['max_us']} us "
            f"({full_max_ratio:.2f}x) and the average by {full_avg_delta:.1f}%.",
            f"- Keeping stress off CPU7 reduced the maximum by {abs(isolated_max_delta):.1f}% "
            f"and the average by {abs(isolated_avg_delta):.1f}% relative to idle in this run.",
            "- The isolated result is consistent with CPU affinity reducing contention, but the",
            "  CPU6/CPU7 shared frequency policy and other platform effects prevent attributing",
            "  the improvement to affinity alone.",
            f"- Full stress produced {full['gt1000_count']} samples above 1000 us "
            f"({full['gt1000_ppm']} ppm); idle and isolated stress produced none.",
            "- The board clock was not initialized and reported 1970. Evidence directory dates",
            "  are host-side collection labels rather than trusted board wall-clock timestamps.",
            "",
            "## Reproduction",
            "",
            "Regenerate this summary from the committed JSON files:",
            "",
            "```bash",
            "python3 scripts/analyze_physical_board_cyclictest.py \\",
            "  results/physical-board-atk-dlrk3588-native-linux \\",
            "  --csv-output results/physical-board-atk-dlrk3588-native-linux-summary.csv \\",
            "  --markdown-output results/physical-board-atk-dlrk3588-native-linux-summary.md",
            "```",
            "",
        ]
    )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines), encoding="utf-8", newline="\n")


def main() -> int:
    args = parse_args()
    evidence_dir = args.evidence_dir.resolve()
    rows = [read_scenario(evidence_dir, scenario, filename) for scenario, filename in SCENARIOS]
    write_csv(rows, args.csv_output)
    write_markdown(rows, args.markdown_output)
    print(f"scenarios={len(rows)}")
    print(f"cycles={sum(int(row['cycles']) for row in rows)}")
    print("histogram_overflows=0")
    print(f"csv_output={args.csv_output}")
    print(f"markdown_output={args.markdown_output}")
    print("PHYSICAL_BOARD_CYCLICTEST_ANALYSIS=PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
