-- ## Add required modules needed to support interface
local mapDB = require 'db.procedures'

-- The main function is the first function called from Iguana.
-- The Data argument will contain the message to be processed.
function main(Data)

   -- ## Initiate database
   local conn = mapDB.init()

   -- ## Parse request
   -- Get method, uri, body
   local R = net.http.parseRequest{data=Data}
   trace(R)

   -- ## Parse URI/Location
   local path = string.split(R.location,'/')
   -- Tip: You can also use:
   -- local path = R.location:split('/')
   local id = path[4]
   local resource = path[3]

   trace(resource)  
   
   
   -- ## Route and execute the request
   local result
   
   if resource == 'indications' then 
   
      result = mapDB.getI2P(id, conn)
   
      elseif resource == 'procedures' then
      
      result = mapDB.getP2I(id, conn)

   end

   trace(#result)

   -- ## Map result to a table and serialize as JSON

   resultTable = {}

   for i=1, #result do 
      resultTable[i] = {}
      resultTable[i].ProcedureID = result[i].ProcedureID
      resultTable[i].ProcedureDescription = result[i].ProcedureDescription
      resultTable[i].IndicationID = result[i].IndicationID
      resultTable[i].IndicationDescription = result[i].IndicationDescription
   end

   trace(resultTable)

   local response = json.serialize{data=resultTable}   

   -- ## Return response
   net.http.respond{body=response,entity_type='application/json'}

end