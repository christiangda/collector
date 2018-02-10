FROM openresty/openresty:alpine

ENV APP_PORT=12345

RUN apk add --no-cache --update --virtual \
        redis \
    && /usr/local/openresty/luajit/bin/luarocks install \
        lua-protobuf \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*
 
# Copy configuration files
COPY conf/redis/redis.conf /etc/redis.conf
COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy provisioning files
COPY scripts/bash/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE ${APP_PORT}

CMD ["/usr/local/bin/docker-entrypoint.sh"]