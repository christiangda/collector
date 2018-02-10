#!/usr/bin/env bash
set -e

/usr/bin/redis-server /etc/redis.conf &
/usr/local/openresty/bin/openresty -g "daemon off;" &