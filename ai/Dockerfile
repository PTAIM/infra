# ----- Estágio 1: Puxar o código do Git -----
# Usamos uma imagem que tenha 'git' instalado
FROM alpine/git:latest AS cloner

# Define o diretório de trabalho
WORKDIR /app

ARG CACHE_BUSTER=default

# (OPCIONAL) Para repositórios privados, montamos a chave SSH secreta
# O BuildKit garante que esta chave SÓ exista durante este comando e não seja salva na imagem
RUN git clone https://github.com/ricardovinicius/medical-service .
RUN git checkout rabbit

# (OBRIGATÓRIO) Truque para invalidar o cache
# Passamos um argumento (ex: a data ou o hash do commit) para que esta camada
# seja sempre "diferente" e o Docker re-execute o git pull.
# Se o argumento não mudar, o cache será usado.
RUN git pull

# ----- Estágio 2: Iniciar o Backend (Ex: Python/Flask) -----
FROM python:3.12-alpine AS email
WORKDIR /app

# Copia o código-fonte do estágio 'cloner'
COPY --from=cloner /app .

RUN pip install --no-cache-dir uv
RUN uv sync

EXPOSE 9001

CMD ["uv", "run", "faststream", "run", "main:app", "--host", "0.0.0.0", "--port", "9001"]
