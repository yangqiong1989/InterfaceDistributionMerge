local tools = require('tools')
local constant = require('constant')
local http = require('http')
local _M = {}

--http external request
function _M.http_external_request(url)
  local httpc = http.new()
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

--http internal request
function _M.http_internal_request(urls)
  local res = ngx.location.capture(urls)
  if not res then
    return nil
  else
    return res
  end
end

return _M
