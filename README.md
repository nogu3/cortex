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

## 起動するモデル

| モデル | ランタイム | 用途 | 状態 |
|--------|-----------|------|------|
| bonSAI | Ollama on Docker | 汎用・日本語 | 試験中 |

## クイックスタート

### 前提

- Docker & Docker Compose
- GPU: NVIDIA (CUDA) または Apple Silicon (Metal) 推奨

### bonSAI を起動する

```bash
# リポジトリをクローン
git clone https://github.com/nogu3/cortex.git
cd cortex

# bonSAI コンテナを起動
docker compose -f models/bonsai/docker-compose.yml up -d

# 動作確認
curl http://localhost:11434/api/generate \
  -d '{"model":"bonsai","prompt":"こんにちは"}'
```

### OpenAI 互換エンドポイント

Ollama は OpenAI 互換 API を提供するため、既存のクライアントをそのまま向け先変更できる。

```python
from openai import OpenAI

client = OpenAI(base_url="http://localhost:11434/v1", api_key="ollama")
response = client.chat.completions.create(
    model="bonsai",
    messages=[{"role": "user", "content": "今日の天気は？"}],
)
print(response.choices[0].message.content)
```

## 外部システムとの連携

### n8n

n8n の `HTTP Request` ノードまたは `Ollama` ノードで `http://cortex:11434` を指定する。

### zeroclaw

zeroclaw の設定ファイルで LLM エンドポイントを cortex に向ける。

```yaml
llm:
  provider: ollama
  base_url: http://cortex:11434
  model: bonsai
```

## ディレクトリ構成

```
cortex/
├── models/
│   └── bonsai/
│       └── docker-compose.yml   # bonSAI 起動定義
├── configs/                     # モデル別パラメータ設定
└── README.md
```

## モデルを追加する

```bash
# 新しいモデルのディレクトリを作成
mkdir -p models/<model-name>

# docker-compose.yml を追加して起動
docker compose -f models/<model-name>/docker-compose.yml up -d
```

## ライセンス

MIT
