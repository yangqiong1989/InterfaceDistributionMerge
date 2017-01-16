local json = require('json')
local tools = require('tools')
local constant = require('constant')
local args = {roomid=69590,matchid=12345}
--load config
local function load_config_json(file_name)
  local result = tools.read_file(file_name)
  return result
end
--get distribute
local function get_distribute(file_name)
  local result = load_config_json(file_name)
  local jsontable = json.decode(result)
  local distribute = jsontable['distribute']
  return distribute
end

local distributes = get_distribute('E:/123.json')
local  resolved_distribute_args = {}
--for i=1,#distributes,1 do
for k,v in pairs(distributes) do
  local distributestring = json.encode(distributes[k])
  print(k..'==============='..distributestring)
  for key, val in pairs(args) do
    if string.find(distributestring,'$'..key) then
      distributestring = tools.replace(distributestring,'$'..key,val)
    end
  end
  print(k..'==============='..distributestring)
  table.insert(resolved_distribute_args,distributestring)
end

local function http_req(url) 
  httpc:set_timeout(500)--设置超时时间
  local res, err = httpc:request_uri(url, {
    method = "GET",
    --body = bodyStr,
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
      ["Connection"] = 'Keep-Alive',
    },constant.http_max_conn,constant.http_max_expires
  })  
end 

http_req('http://data.live.126.net/liveAll/69590.json')


