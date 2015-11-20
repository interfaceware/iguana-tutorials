-- In this script we take an incoming HL7 feed and filter out the
-- non ADT messages.  If you'd like to learn how it works, and learn
-- more about Iguana, take our first steps course at:
-- http://training.interfaceware.com/course/first-steps

function main(Data)
   -- Parse the HL7 message
   local Msg, Name = hl7.parse{vmd = 'example/demo.vmd', data = Data}
   local Out       = hl7.message{vmd = 'example/demo.vmd', name=Name}
   
   -- Filter messages (only include ADT messages)
   if Name == "ADT" then
      
      -- (1) Map information from the incoming to the outgoing message
      
      
      -- (2) Transform the outgoing message as needed  
      

      -- (3) Push the outgoing message into the Iguana queue
      
      
   else
      -- (4) Write a log entry when a message is filtered
      
   end
end