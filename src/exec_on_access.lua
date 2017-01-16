local tools = require('tools')
local config = require('load_config_json')
local json = require('cjson')
local constant = require('constant')
local http = require('http_client')
--get ngx parameter to load config file
local config_file_name = tostring(ngx.var.config_file_name)
--get api uri args
local args = ngx.req.get_uri_args()

local distributes = config.get_distribute(config_file_name)
--get config's url and replace $arg,then build a new table
--local  resolved_distribute_args = {}
local threads = {}
for k,v in pairs(distributes) do
  local distributestring = json.encode(distributes[k])
  ngx.log(ngx.INFO,k..'==============='..distributestring)
  for key, val in pairs(args) do
    if string.find(distributestring,'$'..key) then
      distributestring = tools.replace(distributestring,'$'..key,val)
    end
  end
  ngx.log(ngx.INFO,k..'==============='..distributestring)
  --table.insert(resolved_distribute_args,distributestring)
  local http_thread = http.http_request(distributestring)
  table.insert(threads,ngx.thread.spaw(http_thread))
  --threads[k] = ngx.thread.spawn(http_thread) 
end

for i=1,#threads do
  local ok,res = ngx.thread.wait(threads[i])
  if ok then
    ngx.log(ngx.INFO,res.status..''..res.body)
  else
    ngx.log(ngx.INFO,res.status..''..res.body)
  end
end
