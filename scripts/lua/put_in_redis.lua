local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000) -- 1 sec

local ok, err = red:connect("unix:/tmp/redis.sock")
if not ok then
    ngx.say("failed to connect: ", err)
    return
end

ok, err = red:set("dog", "an animal")
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