#!/usr/bin/env bash
set -euo pipefail

# Qwen 0.5B non-real-time: stress + full kernel isolation
# Correct configuration:
#   CPU1 = inference
#   CPU0 = stress-ng + housekeeping
#
# Kernel boot parameters expected:
#   isolcpus=1 nohz_full=1 rcu_nocbs=1 irqaffinity=0

cd /mnt/i1data/i1-edge-ai-slm

echo "Verifica parametri kernel:"
cat /proc/cmdline
echo ""
echo "CPU isolate:"
cat /sys/devices/system/cpu/isolated || true

sudo pkill stress-ng || true

START_TS=$(date +%s)

cd /tmp
taskset -c 0 stress-ng --cpu 1 --cpu-method matrixprod --metrics-brief > /tmp/stress_ng_nonrt_full_isolation_qwen05.log 2>&1 &
STRESS_PID=$!

cd /mnt/i1data/i1-edge-ai-slm

echo "Stress PID: $STRESS_PID"
echo "Avvio inferenza Qwen0.5B su CPU1..."

sudo taskset -c 1 python3 scripts/run_qwen_benchmark_final.py \
  --model-label qwen05 \
  --model-path models/qwen2.5-0.5b-instruct-q4_k_m.gguf \
  --temperature 0.7 \
  --repeats 3

sudo kill "$STRESS_PID" || true
sudo pkill stress-ng || true

echo ""
echo "CSV generati dopo l'avvio della run:"
find results -type f -name "*.csv" -newermt "@$START_TS" -printf "%TY-%Tm-%Td %TH:%TM %p\n" | sort
