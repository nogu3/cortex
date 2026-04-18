FROM nvidia/cuda:12.8.0-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates libgomp1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download PrismML's pre-built llama.cpp binary (CUDA 12.8 build)
RUN wget -q "https://github.com/PrismML-Eng/llama.cpp/releases/download/prism-b8796-e2d6742/llama-prism-b8796-e2d6742-bin-linux-cuda-12.8-x64.tar.gz" \
    -O llama.tar.gz \
    && tar -xf llama.tar.gz \
    && rm llama.tar.gz \
    && find . -name "llama-server" -exec cp {} /usr/local/bin/ \;

ENV LD_LIBRARY_PATH=/app/llama-prism-b8796-e2d6742

EXPOSE 8080

CMD ["llama-server", \
     "--model", "/models/Bonsai-8B.gguf", \
     "--host", "0.0.0.0", \
     "--port", "8080", \
     "-ngl", "99", \
     "--ctx-size", "4096"]
