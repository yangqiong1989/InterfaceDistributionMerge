local tools = require('tools')
local constant = require('constant')
local http = require('http')
local httpc = http.new()
local _M = {}

--http request
function _M.http_request(url)
  httpc:set_timeout(500)
  local res, err = httpc:request_uri(url, {
    method = "GET",
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
      ["Connection"] = 'Keep-Alive',
    },constant.http_max_conn,constant.http_max_expires
  })
  if not res then 
    return nil
  else
    return res
  end
end

return _M