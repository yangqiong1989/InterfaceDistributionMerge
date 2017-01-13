local json = require('json')
local tools = require('tools')
--read file  
local function read_file(file_path)
  local file = io.open(file_path,"r")
  if(file) then
    local content = file:read("*all")
    file:close()
    return content
  else
    return nil
  end
end

--string split
local function split(str, delimiter)
  if str==nil or str=='' or delimiter==nil then
    return nil
  end
  
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

local content = read_file("E:/123.json")
print('json content is '..content..'end')
local config = json.decode(content)
local distribute = nil
local relational_mapping = nil
if config~=nil then
  distribute = config['distribute']
  relational_mapping = config['relational_mapping']
end

local first = split(relational_mapping,',')
--split by ,
for k,v in pairs(first) do
  print('first relational is :'..v)
  local second = split(v,'&')
  --split by &
  for k,v in pairs(second) do
    print('second relational is :'..v)
    local third = split(v,'>')
    --split by >
    for k,v in pairs(third) do
      print('third relational is :'..v)
      local fourth = split(v,'@')
      --split by @
      for k,v in pairs(fourth) do
        print('fourth relational is :'..v)  
      end
    end    
  end
end


--resolve distribute url
for k,v in pairs(distribute) do

end

print(tools.now())
