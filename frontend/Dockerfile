# ----- Estágio 1: Puxar o código do Git -----
# Usamos uma imagem que tenha 'git' instalado
FROM alpine/git:latest AS cloner

# Define o diretório de trabalho
WORKDIR /app

# (OPCIONAL) Para repositórios privados, montamos a chave SSH secreta
# O BuildKit garante que esta chave SÓ exista durante este comando e não seja salva na imagem
RUN git clone https://github.com/PTAIM/frontend.git .

# (OBRIGATÓRIO) Truque para invalidar o cache
# Passamos um argumento (ex: a data ou o hash do commit) para que esta camada
# seja sempre "diferente" e o Docker re-execute o git pull.
# Se o argumento não mudar, o cache será usado.
ARG CACHE_BUSTER=default
RUN git pull

# ----- Estágio 2: Construir o App (Ex: React/Vue/Node) -----
FROM node:22-alpine AS builder

ARG VITE_API_URL
ENV VITE_API_URL=${VITE_API_URL}

WORKDIR /app

# Copia o código-fonte do estágio 'cloner'
COPY --from=cloner /app .

# Instala dependências e faz o build
RUN npm install
RUN npm run build

# ----- Estágio 3: Servidor Final (Ex: Nginx) -----
FROM nginx:latest AS final

# Copia apenas os arquivos estáticos construídos do estágio 'builder'
COPY --from=builder /app/build/client /usr/share/nginx/html

# (Opcional) Copia sua configuração personalizada do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]