#!/bin/bash
# Espera a rede ficar pronta
sleep 10

# Atualiza o gerenciador de pacotes (apt)
apt-get update -y

# Instala pré-requisitos (Git e curl)
apt-get install -y git curl

# Instala o Docker (o script get.docker.com funciona perfeitamente no Ubuntu)
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# --- MUDANÇA IMPORTANTE ---
# Adiciona o usuário 'ubuntu' (padrão da OCI) ao grupo docker
usermod -aG docker ubuntu

# Ativa o Docker na inicialização
systemctl enable docker
systemctl start docker

# Instala o Docker Compose v2 (O comando é o mesmo, é um binário)
curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-aarch64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose