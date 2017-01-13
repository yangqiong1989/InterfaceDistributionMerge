local json = require('json')
local tools = require('tools')
--read file
local function read_file(file_path)
  local file = io.open(file_path,"r")
  if file then
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



function getFile(file_name) 
    local f = assert(io.open(file_name, 'r'))
    local string = f:read("*all")
    f:close()
    return string
end

function writeFile(file_name,string)
 local f = assert(io.open(file_name, 'w'))
 f:write(string)
 f:close()
end


--从命令行获取参数， 如果有参数则遍历指定目录，没有参数遍历当前目录
if arg[1] ~= nil then
     cmd = "dir "..arg[1]
else
     cmd = "dir"
end
print("cmd", cmd)
--io.popen 返回的是一个FILE，跟c里面的popen一样
local s = io.popen(cmd)
local fileLists = s:read("*all")
print(fileLists)

while true do
    --从文件列表里一行一行的获取文件名
    _,end_pos, line = string.find(fileLists, "([^\n\r]+.txt)", start_pos)
        if not end_pos then 
            break
        end
--    print ("wld", line)
    local str = getFile(line)
    --把每一行的末尾 1, 替换为 0,
    local new =string.gsub(str, "1,\n", "0,\n");
    --替换后的字符串写入到文件。以前的内容会清空
    writeFile(line, new)
    start_pos = end_pos + 1
end