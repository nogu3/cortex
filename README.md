# cortex

家の中枢知能。ローカルLLMをDockerで手軽に起動し、プライベートなAIシステムの頭脳として機能させるためのプロジェクト。

## コンセプト

新しいローカルLLMが出るたびに試せる環境を整え、自宅サーバー上でAIが常時動作する状態を目指す。  
zeroclaw、n8nなどのAIシステムの推論エンジンとして接続することが最終ゴール。

```
[n8n / zeroclaw / その他エージェント]
            |
            v
         cortex  <-- ここ
     (local LLM on Docker)
            |
            v
  [Ollama / llama.cpp / vLLM ...]
```

## モデル

| モデル | サイズ | 用途 | 状態 |
|--------|--------|------|------|
| [Bonsai 8B (1-bit)](https://ollama.com/digitsflow/bonsai-8b) | 1.15 GB | 超軽量・汎用 | 試験中 |

## クイックスタート

### 前提

- Docker
- NVIDIA GPU + nvidia-container-toolkit

### Bonsai 8B を起動する

```bash
# コンテナ起動
docker run -d --gpus all \
  -v ollama_data:/root/.ollama \
  -p 11434:11434 \
  --name cortex-bonsai \
  ollama/ollama

# モデルをpull
docker exec cortex-bonsai ollama pull digitsflow/bonsai-8b

# 動作確認
curl http://localhost:11434/api/generate \
  -d '{"model":"digitsflow/bonsai-8b","prompt":"こんにちは"}'
```

## 外部システムとの連携

OpenAI互換APIとして動くので、既存クライアントの向き先を変えるだけで使える。

### Python

```python
from openai import OpenAI

client = OpenAI(base_url="http://localhost:11434/v1", api_key="ollama")
response = client.chat.completions.create(
    model="digitsflow/bonsai-8b",
    messages=[{"role": "user", "content": "今日の天気は？"}],
)
print(response.choices[0].message.content)
```

### n8n

`HTTP Request` ノードまたは `Ollama` ノードで `http://cortex:11434` を指定する。

### zeroclaw

```yaml
llm:
  provider: ollama
  base_url: http://cortex:11434
  model: digitsflow/bonsai-8b
```

## ライセンス

MIT
