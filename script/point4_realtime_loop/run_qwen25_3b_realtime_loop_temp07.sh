#!/bin/bash
set -e

PROJECT_DIR="/mnt/i1data/i1-edge-ai-slm"
MODEL="$PROJECT_DIR/models/qwen2.5-3b-instruct-q4_k_m.gguf"

N_RUNS=3
TEMP=0.7
N_TOKENS=4
CTX=256
DEADLINE_1_MS=60000
DEADLINE_2_MS=90000

cd "$PROJECT_DIR"

# Qwen2.5-3B was tested as a feasibility case.
# The model did not produce valid real-time loop results on the BeagleBone AI-64
# due to memory allocation errors.
python3 scripts/realtime_loop.py \
  --model-label qwen25_3b \
  --model-path "$MODEL" \
  --temperature "$TEMP" \
  --runs "$N_RUNS" \
  --n-tokens "$N_TOKENS" \
  --ctx "$CTX" \
  --deadline-1-ms "$DEADLINE_1_MS" \
  --deadline-2-ms "$DEADLINE_2_MS" \
  --scenario baseline
