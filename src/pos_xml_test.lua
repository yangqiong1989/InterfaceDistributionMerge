local tools = require('tools')
local xml = require("xml_simple").newParser()

local config_file_name = 'E:/pom.xml'
local result = tools.read_file(config_file_name)

local parsedXml = xml:ParseXmlText(result) 
print(parsedXml.dependencyManagement.dependencies[1].artifactId[1]:value())
