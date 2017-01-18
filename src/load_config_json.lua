local json = require('cjson')
local constant = require('constant')
local tools = require('tools')
local dogs = ngx.shared.dogs

local _M = {}

--load config
function _M.load_config_json(file_name)
  local result = dogs:get(file_name)
  if  result then
    return result
  else
    local config_file_name = constant.config_path..file_name
    result = tools.read_file(config_file_name)
    dogs:set(file_name,result,60)
    return result
  end
end
--get external
function _M.get_external(file_name)
  local result = _M.load_config_json(file_name)
--  ngx.log(ngx.ERR,'get_external result:',result)
  local jsontable = json.decode(result)
  local external = jsontable['external']
  return external
end
--get internal
function _M.get_internal(file_name)
  local result = _M.load_config_json(file_name)
--  ngx.log(ngx.ERR,'get_internal result:',result)
  local jsontable = json.decode(result)
  local internal = jsontable['internal']
  return internal
end
--get need delete_key
function _M.get_need_delete_key(file_name)
  local result = _M.load_config_json(file_name)
  local jsontable = json.decode(result)
  local delete_key = jsontable['delete_key']
  return delete_key
end
--get relational_mapping
function _M.get_relational_mapping(file_name)
  local result = _M.load_config_json(file_name)
  local jsontable = json.decode(result)
  local relational_mapping = jsontable['relational_mapping']
  return relational_mapping
end


return _M
