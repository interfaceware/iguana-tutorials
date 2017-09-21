local files = {}

function files.loadFile(FileName)
   local F = io.open(FileName, "r")
   local Content =  F:read('*a')
   F:close()
   return Content
end


function files.writeFile(FileName)

   local test = filter.zip.inflate(FileName)
   trace(test)
   
   local F = io.open("proceduresMappings.csv", "w")
   F:write(test["Procedures Indication Mappings.csv"])
   F:close()

end

return files
