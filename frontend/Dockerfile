FROM node:22-alpine AS builder

ARG VITE_API_URL
ENV VITE_API_URL=${VITE_API_URL}

WORKDIR /app

# Copia o código-fonte do estágio 'cloner'
COPY /app .

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