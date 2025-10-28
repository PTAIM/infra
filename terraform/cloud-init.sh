#!/bin/bash
# Espera a rede ficar pronta
sleep 10

# Instala o Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Adiciona o usuário 'opc' (padrão da OCI) ao grupo docker
usermod -aG docker opc

# Ativa o Docker na inicialização
systemctl enable docker
systemctl start docker

# Instala o Docker Compose v2 (para ARM)
curl -L "https://github.com/docker/compose/releases/download/v2.40.2/docker-compose-linux-aarch64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# (Opcional) Instala o Git
dnf install -y git