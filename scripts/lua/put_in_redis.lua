local redis = require "resty.redis"
local pb = require "pb"
local protoc = require "protoc"

local CHANNEL = "raw_data"
local remote_addr = ngx.var.remote_addr

local sock, err = ngx.req.socket(true)
if not sock then
    ngx.log(ngx.ERR, "failed to get socket connection: ", err)
    local ok, err = sock.close()
    if not ok then
        ngx.log(ngx.ERR, "failed to close socket connection: ", err)
    end
end

local red = redis:new()
red:set_timeout(1000) -- 1 sec
local ok, err = red:connect("unix:/tmp/redis.sock")
if not ok then
    ngx.log(ngx.ERR, "failed to connect to redis: ", err)
    
    -- close conection to avoid data loss
    local ok, err = sock:shutdown("send")
    if not ok then
        ngx.log(ngx.ERR, "failed to shutdown: ", err)
        return
    end
end

-- Data block
-- read a line from downstream
local data = sock:receive()

ok, err = red:publish(CHANNEL, data)
if not ok then
    ngx.log(ngx.ERR, "failed on redis to publish in clannel: ", err)
    return
elseif ok == 0 then
    ngx.log(ngx.ERR, "no susbcriber exist on channel: ", CHANNEL)
    
    -- close conection to avoid data loss
    local ok, err = sock:shutdown("send")
    if not ok then
        ngx.log(ngx.ERR, "failed to shutdown: ", err)
        return
    end
end


-- or just close the connection right away:
--local ok, err = red:close()
--if not ok then
--    ngx.say("failed to close: ", err)
--    return
--end