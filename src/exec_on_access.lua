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
local threads_internals = {}
local internals_table = {}
for k,v in pairs(internals) do
  local internal = internals[k]
  for key, val in pairs(args) do
    if string.find(internal,'$'..key) then
      internal = tools.replace(internal,'$'..key,val)
    end
  end
  --ngx.log(ngx.ERR,'internal *********************'..internal)
  --table.insert(threads_internals,ngx.thread.spawn(http.http_request,internal))
  table.insert(internals_table,internal)
end
table.insert(threads_internals,internals_table)
local internals_responses = {}
internals_responses = http.http_internal_request(threads_internals)
 
local response  = {}
if internals_responses then
  for i=1,#internals_responses,1 do
    local res = internals_responses[i]
    ngx.log(ngx.ERR,res.status..'*********************'..res.body)
    table.insert(response,json.decode(res.body))
  end
end

--internals http request
local threads_externals = {}
for k,v in pairs(externals) do
  local external = externals[k]
  for key, val in pairs(args) do
    if string.find(external,'$'..key) then
      external = tools.replace(external,'$'..key,val)
    end
  end
  table.insert(threads_externals,ngx.thread.spawn(http.http_external_request,external))
end

local externals_responses = {}
for i=1,#threads_externals,1 do
  local ok,res = ngx.thread.wait(threads_externals[i])
  if ok then
    ngx.log(ngx.ERR,res.status..'*********************'..res.body)
    table.insert(externals_responses,json.decode(res.body))
  else
    ngx.log(ngx.ERR,res.status..'*********************'..res.body)
  end
end

local xxx = response[1]
for i=1,#externals_responses,1 do
  table.insert(xxx,externals_responses[i])
end

ngx.say(json.encode(xxx))


