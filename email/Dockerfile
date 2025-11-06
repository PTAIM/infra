# ----- Estágio 2: Iniciar o Backend (Ex: Python/Flask) -----
FROM python:3.12-alpine AS email
WORKDIR /app

# Copia o código-fonte do estágio 'cloner'
COPY /app .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 9000

CMD ["faststream", "run", "app.main:app", "--host", "0.0.0.0", "--port", "9000"]
