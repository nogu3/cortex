#!/bin/bash
set -e

MODEL_PATH="/models/gemma-4-E4B-it-Q4_K_M.gguf"
MODEL_URL="https://huggingface.co/unsloth/gemma-4-E4B-it-GGUF/resolve/main/gemma-4-E4B-it-Q4_K_M.gguf"

if [ ! -f "$MODEL_PATH" ]; then
    echo "Downloading Gemma 4 E4B model (~4.98GB)..."
    mkdir -p /models
    wget -q --show-progress "$MODEL_URL" -O "$MODEL_PATH"
    echo "Download complete."
fi

exec llama-server \
    --model "$MODEL_PATH" \
    --host 0.0.0.0 \
    --port 8080 \
    -ngl 99 \
    --ctx-size 16384
