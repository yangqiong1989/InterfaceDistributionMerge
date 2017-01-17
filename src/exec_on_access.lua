local tools = require('tools')
local config = require('load_config_json')
local json = require('cjson')
local constant = require('constant')
local http = require('http_client')
--get ngx parameter to load config file
local config_file_name = tostring(ngx.var.config_file_name)
--get api uri args
--local args = ngx.var.args
local args = {roomid=69590,matchid=69590}

local distributes = config.get_distribute(config_file_name)
--get config's url and replace $arg,then build a new table
local threads = {}
for k,v in pairs(distributes) do
  local distributestring = distributes[k]
  for key, val in pairs(args) do
    if string.find(distributestring,'$'..key) then
      distributestring = tools.replace(distributestring,'$'..key,val)
    end
  end
  table.insert(threads,ngx.thread.spawn(http.http_request,distributestring))
end

local responses = {}
for i=1,#threads,1 do
  local ok,res = ngx.thread.wait(threads[i])
  if ok then
    ngx.log(ngx.ERR,res.status..'*********************'..res.body)
    table.insert(responses,res.body)
  else
    ngx.log(ngx.ERR,res.status..'*********************'..res.body)
  end
end
