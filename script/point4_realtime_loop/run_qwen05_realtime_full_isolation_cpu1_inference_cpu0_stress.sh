#!/usr/bin/env bash
set -euo pipefail

# Qwen 0.5B real-time: stress + full kernel isolation
# Correct configuration:
#   CPU1 = inference
#   CPU0 = stress-ng + housekeeping
#
# Kernel boot parameters expected:
#   isolcpus=1 nohz_full=1 rcu_nocbs=1 irqaffinity=0
#
# This script mirrors the modified real-time wrapper used in the session:
#   original: scripts/run_qwen05_realtime_loop_temp07.sh
#   modified: INFERENCE_CORE=1, STRESS_CORE=0
#
# On the board, if the original script exists, create the isolated version with:
#   sudo cp scripts/run_qwen05_realtime_loop_temp07.sh scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh
#   sudo sed -i 's/INFERENCE_CORE="0"/INFERENCE_CORE="1"/g' scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh
#   sudo sed -i 's/STRESS_CORE="1"/STRESS_CORE="0"/g' scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh
#   sudo chmod +x scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh
#   sudo ./scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh isolation

cd /mnt/i1data/i1-edge-ai-slm

echo "Verifica parametri kernel:"
cat /proc/cmdline
echo ""
echo "CPU isolate:"
cat /sys/devices/system/cpu/isolated || true

sudo pkill stress-ng || true

sudo cp scripts/run_qwen05_realtime_loop_temp07.sh scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh
sudo sed -i 's/INFERENCE_CORE="0"/INFERENCE_CORE="1"/g' scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh
sudo sed -i 's/STRESS_CORE="1"/STRESS_CORE="0"/g' scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh
sudo chmod +x scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh

sudo ./scripts/run_qwen05_realtime_loop_temp07_isolated_cpu1.sh isolation
