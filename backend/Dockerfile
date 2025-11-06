# ----- Estágio 1: Puxar o código do Git -----
# Usamos uma imagem que tenha 'git' instalado
FROM alpine/git:latest AS cloner

# Define o diretório de trabalho
WORKDIR /app

# (OBRIGATÓRIO) Truque para invalidar o cache
# Passamos um argumento (ex: a data ou o hash do commit) para que esta camada
# seja sempre "diferente" e o Docker re-execute o git pull.
# Se o argumento não mudar, o cache será usado.
ARG CACHE_BUSTER=default

# (OPCIONAL) Para repositórios privados, montamos a chave SSH secreta
# O BuildKit garante que esta chave SÓ exista durante este comando e não seja salva na imagem
RUN git clone https://github.com/PTAIM/backend.git .
RUN git checkout fix/rotas

RUN git pull

# ----- Estágio 2: Iniciar o Backend (Ex: Python/Flask) -----
FROM python:3.12-alpine AS backend

WORKDIR /app

# Copia o código-fonte do estágio 'cloner'
COPY --from=cloner /app .

ENV PYTHONUNBUFFERED=1

RUN chmod +x /app/install-packages.sh
RUN sh /app/install-packages.sh || true

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

RUN cat /app/entrypoint.sh | head -n 1 | od -c

RUN sed -i 's/\r$//' /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
