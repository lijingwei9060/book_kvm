

1. CPU only: docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
2. GPU: docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama

ollama run llama3:7b