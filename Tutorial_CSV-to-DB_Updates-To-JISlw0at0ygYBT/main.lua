 
-- ## Add required modules needed to support interface
local mapDB = require 'demo.lookups.db.procedures'
local parseCSV = require 'csv'




-- The main function is the first function called from Iguana.
-- The Data argument will contain the message to be processed.
function main(Data)

   -- ## Initialize DB connection. If no DB, create schema.
   --    This is already implemented in From Translator, 
   --    but it will be useful if you convert that component
   --    into From File.

   local conn = mapDB.init()
   mapDB.createDB(conn)

   
   -- Parse CSV file
   local mappings = parseCSV(Data)
   -- Remove header
   table.remove(mappings,1)
   trace(mappings)
   
   -- Create staging table that mirrors our database table
   local dbTable = dbs.init{filename='mappings.dbs'}
   local M = dbTable:tables()
   
   -- Map from CSV file into table
   for i=1, #mappings do 
      M.procedures[i].ProcedureID = mappings[i][1]
      M.procedures[i].ProcedureDescription = mappings[i][2]
      M.procedures[i].IndicationID = mappings[i][3]
      M.procedures[i].IndicationDescription = mappings[i][4]   
   end
   
   -- Merge into DB. If live=false, sample data won't overwrite DB.
   conn:merge{data=M,live=true}
   -- Let's confirm our result in the database
   trace(conn:query{sql=[[SELECT * FROM procedures]],live=true})

   conn:close()
   
end