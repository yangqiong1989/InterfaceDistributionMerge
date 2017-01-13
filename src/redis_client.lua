local redis = require("resty.redis")
local _M = {}

--redis connect and author
function _M.get_redis_client(redis_server,redis_port,redis_passwd)
  local cache = redis.new()
  cache:set_timeout(2000)
  local res, err = cache:connect(redis_server, redis_port)
  if not res then
    return nil
  end
  if redis_passwd then
    res, err=cache:auth(redis_passwd)
    if not res then
      return nil
    end
  end
  return cache
end

return _M