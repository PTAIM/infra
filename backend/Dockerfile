# ----- Estágio 2: Iniciar o Backend (Ex: Python/Flask) -----
FROM python:3.12-alpine AS backend

WORKDIR /app

# Copia o código-fonte do estágio 'cloner'
COPY /app .

ENV PYTHONUNBUFFERED=1

RUN chmod +x /app/install-packages.sh
RUN sh /app/install-packages.sh || true

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

RUN cat /app/entrypoint.sh | head -n 1 | od -c

RUN sed -i 's/\r$//' /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
