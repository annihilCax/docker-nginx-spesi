FROM nginx:alpine AS client
WORKDIR /usr/share/nginx/html
COPY ./client/index.html ./

FROM python:3.9-slim AS server
WORKDIR /app
COPY ./server/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY ./server /app

FROM python:3.9-alpine
WORKDIR /app

RUN apk add --no-cache nginx

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=client /usr/share/nginx/html /usr/share/nginx/html
COPY --from=server /app /app

EXPOSE 80

CMD ["sh", "-c", "python3 /app/server.py & nginx -g 'daemon off;'"]
