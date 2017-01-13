local json = require('json')
local constant = require('constant')
local tools = require('tools')
local dogs = ngx.shared.dogs

local _M = {}

--load config
function _M.load_config(file_name)
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
--get distribute
function _M.get_distribute(file_name)
  local result = _M.load_config(file_name)
  local jsontable = json.decode(result)
  local distribute = jsontable['distribute']
  return distribute
end
--get need delete_key
function _M.get_need_delete_key(file_name)
  local result = _M.load_config(file_name)
  local jsontable = json.decode(result)
  local delete_key = jsontable['delete_key']
  return delete_key
end
--get relational_mapping
function _M.get_relational_mapping(file_name)
  local result = _M.load_config(file_name)
  local jsontable = json.decode(result)
  local relational_mapping = jsontable['relational_mapping']
  return relational_mapping
end


return _M
