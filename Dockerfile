
FROM ubuntu:14.04

RUN apt-get update && apt-get install -y nginx

WORKDIR /app

COPY ./dist/ /app/

EXPOSE 80


RUN cp -r /app/* /usr/share/nginx/html && rm -rf /app

CMD ["nginx","-g","daemon off;"]
