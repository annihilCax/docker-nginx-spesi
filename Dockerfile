# Строим образ для клиента (nginx)
FROM nginx:alpine AS client
WORKDIR /usr/share/nginx/html
COPY ./client/index.html ./

# Строим образ для сервера (Python)
FROM python:3.9-slim AS server
WORKDIR /app
COPY ./server/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY ./server /app

# Основной контейнер
FROM python:3.9-alpine
WORKDIR /app

# Установка зависимостей для сервера
RUN apk add --no-cache nginx
COPY --from=server /app /app
COPY --from=client /usr/share/nginx/html /usr/share/nginx/html
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Установка зависимостей сервера
RUN pip install --no-cache-dir -r /app/requirements.txt

EXPOSE 80

CMD ["sh", "-c", "python3 /app/server.py & nginx -g 'daemon off;'"]
