# CLAUDE.md

## プロジェクト概要

ローカルLLMをDockerで起動する自宅AI基盤。llama.cpp (PrismML pre-built binary) ベース。

## 構成

```
docker/
  bonsai/   # Bonsai 8B (llama.cpp, port 8080)
  gemma4/   # Gemma 4 E4B (llama.cpp, port 8081)
```

## モデル格納場所

- Bonsai: `~/models/bonsai/Bonsai-8B.gguf`
- Gemma 4: `~/.cache/gemma4/` (初回起動時に自動ダウンロード)

## 起動方法

```bash
# Bonsai (8080)
docker run --gpus all -p 8080:8080 \
  -v ~/models/bonsai:/models \
  --name bonsai-8b bonsai

# Gemma 4 E4B (8081) — 初回は~5GBダウンロード
docker run --gpus all -p 8081:8080 \
  -v ~/.cache/gemma4:/models \
  --name gemma4 gemma4
```

## llama.cpp バイナリ

PrismML pre-built (CUDA 12.8):
`https://github.com/PrismML-Eng/llama.cpp/releases/download/prism-b8796-e2d6742/`

新しいモデル追加時も同バイナリ使い回し可。

## 環境

- GPU: RTX 4060 (VRAM 8GB)
- RAM: 15GB
- OS: WSL2 (Ubuntu 22.04)

## 新モデル追加手順

1. `docker/<name>/Dockerfile` を既存からコピー
2. `docker/<name>/entrypoint.sh` でモデルURL・パス変更
3. モデルが8GB超の場合、WSL2共有メモリで動くが低速 → 小型モデル推奨

## API

llama.cpp OpenAI互換エンドポイント:
- `GET  /health`
- `POST /v1/chat/completions`
- `POST /completion`
