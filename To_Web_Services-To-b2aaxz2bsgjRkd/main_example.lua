-- In this script, we are building a basic web client.
-- We are going to parse patient demographic info from an incoming HL7 message
-- and pass that data to a web service.
-- Follow our tutorial at:
-- http://training.interfaceware.com/course/connecting-to-web-services


-- Import local module that has mapping details
local map = require 'mappings'


function main(Data)
   
   
   -- 1. PREPARE OUR REQUEST
   
   -- Parse our incoming HL7 message
   local MsgIn, Name, Error = hl7.parse{vmd='demo.vmd',data=Data}
   

   -- Handle message types. (Not covered in tutorial.)
   -- Filter out all messages that are NOT ADT
   -- and log the discarded messages
   if Name ~= 'ADT' then
      print('Discarding ' .. Name .. ' message')
      return
      end

   -- Log all validation errors on incoming message. (Not covered in tutorial.)
   trace(#Error)
   for i=1, #Error do
      iguana.logInfo(Error[i].description)   
      end
   
   -- Define the body of our web service request.
   -- Make sure we have required the mappings module at the top of this script.
   local JSONTemplate = map.template()
   
   -- Parse our JSON body to enable mapping.
   local MsgOut = json.parse{data=JSONTemplate}

   -- Call a function in the mappings.lua local module
   -- to map to the JSON message.
   -- Assign sending application from incoming message to outgoing message
   map.mapPID(MsgIn.PID,MsgOut)
   -- MsgOut.patient.sender = MsgIn.MSH[3][1]:nodeValue()

   
   -- Serialize from node tree to JSON string
   local MsgBody = json.serialize{data=MsgOut}
   
   
   -- 2. SENDING OUR REQUEST 
   local response, status, headers = 
   net.http.post{url='http://target.interfaceware.com:6544/tutorial', body = MsgBody, live=true}
   

   -- 3. HANDLING OUR RESPONSE
  
   
   -- Log the response and status code
   if status == 200 then
      iguana.logDebug("Request successful: " .. response .. " (" .. status .. ")")    
      else
      iguana.logDebug("Request unsuccessful: " .. response .. " (" .. status .. ")")      
      end
   
end

   