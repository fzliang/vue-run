FROM nginx

WORKDIR /app

COPY . /app/

EXPOSE 80

RUN cp -r /app/dist/* /usr/share/nginx/html && \
    cp -f /app/nginx.conf /etc/nginx/nginx.conf && \
    rm -rf /app

CMD ["nginx","-g","daemon off;"]
