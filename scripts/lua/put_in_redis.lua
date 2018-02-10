local redis = require "resty.redis"
local red = redis:new()
local channel = "raw_data" 

local sock = assert(ngx.req.socket(true))
local data = sock:receive()  -- read a line from downstream

-- Data block
if data == "thunder!" then
    ngx.say("flash!")  -- output data
else
    ngx.say("data = ", data)
end

-- Redis block
red:set_timeout(1000) -- 1 sec

local ok, err = red:connect("unix:/tmp/redis.sock")
if not ok then
    ngx.say("failed to connect: ", err)
    return
end

ok, err = red:publish(channel, data)
if not ok then
    ngx.say("failed to set dog: ", err)
    return
end

ngx.say("set result: ", ok)

-- or just close the connection right away:
local ok, err = red:close()
if not ok then
    ngx.say("failed to close: ", err)
    return
end