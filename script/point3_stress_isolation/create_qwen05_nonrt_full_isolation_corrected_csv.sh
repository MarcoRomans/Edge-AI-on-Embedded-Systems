#!/usr/bin/env bash
set -euo pipefail

# Create metadata-corrected CSV after the non-real-time full-isolation run.
# Replace SRC if your generated raw CSV name is different.

cd /mnt/i1data/i1-edge-ai-slm

SRC="${1:-results/qwen05_baseline_cpu_final_temp_07_20250924_125354.csv}"
DST="${2:-results/qwen05_stress_cpu_matrix_full_isolation_temp_07_20260831_corrected.csv}"

sudo python3 - <<PY
import csv
from pathlib import Path

src = Path("$SRC")
dst = Path("$DST")

with src.open(newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    fields = list(reader.fieldnames)

extra_fields = [
    "stressor",
    "stressor_workers",
    "stressor_log",
    "inference_core",
    "stress_core",
    "isolation_strategy"
]

for field in extra_fields:
    if field not in fields:
        fields.append(field)

for row in rows:
    row["scenario"] = "stress_cpu_matrix_full_isolation"
    row["stressor"] = "stress-ng cpu matrixprod pinned"
    row["stressor_workers"] = "1"
    row["stressor_log"] = "/tmp/stress_ng_nonrt_full_isolation_qwen05.log"
    row["inference_core"] = "1"
    row["stress_core"] = "0"
    row["isolation_strategy"] = "Full kernel isolation: isolcpus=1 nohz_full=1 rcu_nocbs=1 irqaffinity=0; inference pinned to CPU1, stress-ng pinned to CPU0"

with dst.open("w", newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=fields)
    writer.writeheader()
    writer.writerows(rows)

print("Creato:", dst)
print("Righe:", len(rows))
PY
