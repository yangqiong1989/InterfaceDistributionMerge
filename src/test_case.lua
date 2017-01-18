local json = require('json')
local tools = require('tools')

local str = 'sports@http://nba.sports.163.com/flag/$roomid.json'
local table = tools.split(str,'@')
print(table[2])
print(type(table[2]))
local args = {roomid=114126,matchid=114126}
local externals = {"sports@http://nba.sports.163.com/flag/$roomid.json","usercount@http://data.live.126.net/partake/usercount/$roomid.json"}
local threads_externals = {}
local external_keys = {}
for k,v in pairs(externals) do
  local table = tools.split(v,'@')
  local external_key = table[1]
  local external = table[2]
  local ext = ''
--  local external = v
  --ngx.log(ngx.ERR,external_key..'*********************'..external)
  for key, val in pairs(args) do
    if string.find(external,'$'..key) then
      ext = tools.replace(external,'$'..key,val)
    end
  end
  print(ext)
  --ngx.log(ngx.ERR,'******222***************'..ext)
  --table.insert(threads_externals,ngx.thread.spawn(http.http_external_request,ext))
  --table.insert(external_keys,external_key)
end