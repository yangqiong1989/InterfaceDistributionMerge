local tools = require('tools')
local config = require('load_config_json')
local json = require('cjson')
local constant = require('constant')
local http = require('http_client')
--get ngx parameter to load config file
local config_file_name = tostring(ngx.var.config_file_name)
--get api uri args
--local args = ngx.var.argss
local args = {roomid=ngx.var.roomid,matchid=ngx.var.matchid}
--ngx.log(ngx.ERR,'********************'..args)

local internals = config.get_internal(config_file_name)
local check_key = config.get_check_key(config_file_name)
local externals = config.get_external(config_file_name)


local url_split = tools.split(internals,'@')
local internal_key = url_split[1]
local internal_url = url_split[2]
--internals capture request
for key, val in pairs(args) do
  if string.find(internal_url,'$'..key) then
    internal_url = tools.replace(internal_url,'$'..key,val)
  end
end
local res = http.http_internal_request(internal_url)
local internals_responses = {}
if res then
  internals_responses = json.decode(res.body)
end

--check internal key to confirm continue external
--get key-param@key 
local check_key_split = tools.split(check_key[1],'@')
local internal_check_key_parameter = check_key_split[1]
local external_check_key = check_key_split[2]
--get key-param
local internal_check_key_split = tools.split(internal_check_key_parameter,'-')
local internal_check_key = internal_check_key_split[1]
local internal_check_parameter = internal_check_key_split[2]

--externals http request
local threads_externals = {}
local external_keys = {}
for k,v in pairs(externals) do
  repeat
    local url_split = tools.split(v,'@')
    local external_key = url_split[1]
    local external_url = url_split[2]
    if not internals_responses[internal_check_parameter] and external_key==external_check_key then
      break
    end
    if string.find(external_url,'http') then
      for key, val in pairs(args) do
        if string.find(external_url,'$'..key) then
          external_url = tools.replace(external_url,'$'..key,val)
        end
      end
    else 
      local rule = tools.split(external_url,'-')
      local rule_key = rule[1]
      local rule_parameter = rule[2]
      if rule_key==internal_key then
        external_url = internals_responses[rule_parameter]
      end
    end
    table.insert(threads_externals,ngx.thread.spawn(http.http_external_request,external_url))
    table.insert(external_keys,external_key)
  until true
end

local externals_responses = {}
for k,v in pairs(threads_externals) do
  local ok,res = ngx.thread.wait(v)
  if ok and res then
    ngx.log(ngx.INFO,'【'..external_keys[k]..'】'..'********************'..res.body)
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
ngx.exit(200)

