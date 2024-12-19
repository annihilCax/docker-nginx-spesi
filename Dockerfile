# для клиента (nginx)
FROM nginx:alpine AS client
WORKDIR /usr/share/nginx/html
COPY ./client/index.html ./

# для сервера (Python)
FROM python:3.9-slim AS server
WORKDIR /app
COPY ./server/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY ./server /app

# основной контейнер
FROM python:3.9-alpine
WORKDIR /app

RUN apk add --no-cache nginx
COPY --from=server /app /app 
COPY --from=client /usr/share/nginx/html /usr/share/nginx/html
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
RUN pip install --no-cache-dir -r /app/requirements.txt

EXPOSE 80

CMD ["sh", "-c", "python3 /app/server.py & nginx -g 'daemon off;'"]
