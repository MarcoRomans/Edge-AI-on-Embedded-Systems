#!/bin/bash
set -e

PROJECT_DIR="/mnt/i1data/i1-edge-ai-slm"
SCRIPT="$PROJECT_DIR/scripts/run_qwen_benchmark_final.py"

QWEN05="$PROJECT_DIR/models/qwen2.5-0.5b-instruct-q4_k_m.gguf"
QWEN15="$PROJECT_DIR/models/qwen2.5-1.5b-instruct-q4_k_m.gguf"
QWEN3B="$PROJECT_DIR/models/qwen2.5-3b-instruct-q4_k_m.gguf"

cd "$PROJECT_DIR"

for TEMP in 0.5 0.7 1.0; do
  python3 "$SCRIPT" --model-label qwen05 --model-path "$QWEN05" --temperature "$TEMP"
done

for TEMP in 0.5 0.7 1.0; do
  python3 "$SCRIPT" --model-label qwen15 --model-path "$QWEN15" --temperature "$TEMP"
done

for TEMP in 0.5 0.7 1.0; do
  python3 "$SCRIPT" --model-label qwen25_3b --model-path "$QWEN3B" --temperature "$TEMP"
done
