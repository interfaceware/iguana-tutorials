-- ## Add required modules needed to support interface
local mapDB = require 'demo.lookups.db.procedures'


-- The main function is the first function called from Iguana.
-- The Data argument will contain the message to be processed.
function main(Data)

   -- ## Initiate database
   local conn = mapDB.init()
   trace(conn:check())
   
   -- ## Log request so it shows up in Iguana logs
   --    to aid in troubleshooting.
   iguana.logInfo(Data)
   
   -- ## Parse request
   -- Get method, uri, body
   local R = net.http.parseRequest{data=Data}
   
   
   -- ## Parse URI/Location
   local path = string.split(R.location,'/')
   -- Or you can use: R.location:split('/')
   
   local apiVersion = path[3]
   local resource = path[4]
   local id = path[5]
   
   trace(resource)
   
   
   
   
   -- ## Route and execute the request
   local result
   local status
   
   if resource == 'indications' then 
   
      local myQuery = [[SELECT * FROM procedures WHERE IndicationID = ]] 
      .. conn:quote(id)
      result = conn:query{sql=myQuery,live=true}
      status = 200
      
      elseif resource == 'procedures' then
      local myQuery = [[SELECT * FROM procedures WHERE ProcedureID = ]] 
      .. conn.quote(id)
      result = conn:query{sql=myQuery,live=true}
      status = 200
      
      else
      -- "Sorry, the resource requested does not exist"
      status = 404
      
   end
   
   trace(result)
   
   
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

   
   -- ## Build the response
   -- Convert body to JSON
   local response = json.serialize{data=resultTable}

   -- Build headers. 
   -- These are examples to help client determine
   -- caching options. Probably not needed for this application. 
   local digest = filter.base64.enc(crypto.digest{data=response,algorithm='sha1'})
   local expires = os.time()
   
   local headers = {Etag=digest,Expires=expires}

   
   -- ## Return response
   net.http.respond{body=response,
      headers=headers,
      entity_type='application/json',
      code=status}
   
end