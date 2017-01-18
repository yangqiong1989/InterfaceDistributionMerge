local tools = require('tools')
local config = require('load_config_json')
local json = require('cjson')
local constant = require('constant')
local http = require('http_client')
--get ngx parameter to load config file
local config_file_name = tostring(ngx.var.config_file_name)
--get api uri args
--local args = ngx.var.args
local args = {roomid=114126,matchid=114126}

local internals = config.get_internal(config_file_name)
local externals = config.get_external(config_file_name)

--internals capture request
for key, val in pairs(args) do
  if string.find(internals,'$'..key) then
    internals = tools.replace(internals,'$'..key,val)
  end
end
local res = http.http_internal_request(internals)
local internals_responses = {}
if res then
  internals_responses = json.decode(res.body)
end

--externals http request
local threads_externals = {}
local external_keys = {}
for k,v in pairs(externals) do
  local url_split = tools.split(v,'@')
  local external_key = url_split[1]
  local external = url_split[2]
  for key, val in pairs(args) do
    if string.find(external,'$'..key) then
      external = tools.replace(external,'$'..key,val)
    end
  end
  table.insert(threads_externals,ngx.thread.spawn(http.http_external_request,external))
  table.insert(external_keys,external_key)
end

local externals_responses = {}
for k,v in pairs(threads_externals) do
  local ok,res = ngx.thread.wait(v)
  if ok then
    table.insert(externals_responses,json.decode(res.body))
  else
    
  end
end

--merage external to internal
local merge_response = internals_responses
for k,v in pairs(externals_responses) do
  merge_response[external_keys[k]] = v
end

ngx.say(json.encode(merge_response))



