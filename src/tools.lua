local _M = {}

--read file
function _M.read_file(file_path)
  local file = io.open(file_path,"r")
  if file then
    local result = file:read("*all")
    file:close()
    return result
  else
    return nil
  end
end

--string split
function _M.split(str, delimiter)
  if str==nil or str=='' or delimiter==nil then
    return nil
  end
  local result = {}
  for match in (str..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match)
  end
  return result
end

--string replace
function _M.replace(str,from,to)
  if str == nil or str == "" or from == nil or to == nil or tostring(str) == "userdata: NULL"  then
    return str
  end
  local result,count = string.gsub(str,from,to)
  if not result then
    return str;
  end
  return result
end

--now time
function _M.now()
  return os.date("%Y-%m-%d %H:%M:%S")
end

return _M
