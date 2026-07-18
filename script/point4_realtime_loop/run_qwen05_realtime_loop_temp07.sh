#!/bin/bash
set -e

PROJECT_DIR="/mnt/i1data/i1-edge-ai-slm"
MODEL="$PROJECT_DIR/models/qwen2.5-0.5b-instruct-q4_k_m.gguf"

N_RUNS=30
TEMP=0.7
N_TOKENS=192
CTX=2048
DEADLINE_1_MS=5000
DEADLINE_2_MS=10000

cd "$PROJECT_DIR"

# Baseline real-time loop
python3 scripts/realtime_loop.py \
  --model-label qwen05 \
  --model-path "$MODEL" \
  --temperature "$TEMP" \
  --runs "$N_RUNS" \
  --n-tokens "$N_TOKENS" \
  --ctx "$CTX" \
  --deadline-1-ms "$DEADLINE_1_MS" \
  --deadline-2-ms "$DEADLINE_2_MS" \
  --scenario baseline
