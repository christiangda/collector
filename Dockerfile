FROM openresty/openresty:alpine-fat

ENV APP_PORT=12345

RUN apk add --no-cache --update --virtual \
        redis \
    && /usr/local/openresty/luajit/bin/luarocks install \
        lua-protobuf \
    && mkdir -p /etc/nginx/lua \
    && mkdir -p /var/log/nginx \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*
 
# Copy configuration files
COPY conf/redis/redis.conf /etc/redis.conf
COPY scripts/lua/put_in_redis.lua /etc/nginx/lua/put_in_redis.lua
COPY conf/nginx/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

# Copy provisioning files
COPY scripts/bash/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE ${APP_PORT}

CMD ["/usr/local/bin/docker-entrypoint.sh"]