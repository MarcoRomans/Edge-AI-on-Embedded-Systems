#!/bin/bash
set -e

PROJECT_DIR="/mnt/i1data/i1-edge-ai-slm"
SCRIPT="$PROJECT_DIR/scripts/run_qwen_benchmark_final.py"
MODEL="$PROJECT_DIR/models/qwen2.5-1.5b-instruct-q4_k_m.gguf"

cd "$PROJECT_DIR"

stress-ng --cpu 2 --cpu-method matrixprod --metrics-brief &
STRESS_PID=$!

sleep 2

python3 "$SCRIPT" \
  --model-label qwen15_stress_cpu_matrix \
  --model-path "$MODEL" \
  --temperature 0.7

kill $STRESS_PID || true
