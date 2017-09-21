-- shared module
local mapDB = require 'demo.lookups.db.procedures'
-- local module
local files = require 'demo.lookups.files'




-- ## Write sample mappings.csv file to file system. 
   
-- If no DB, create it and import schema.
local conn = mapDB.init()
mapDB.createDB(conn)

-- Any rows in the database?
local result, dbrows = mapDB.checkTables(conn)
   trace(dbrows)
   
   -- If no rows, write CSV file from other folder to disk
   -- The To:Translator component will load it into the DB.
   if dbrows == 0 then 
      local mappings = files.loadFile(iguana.project.root()..
         'other/Procedures Indication Mappings.csv.zip')
      
      -- unzip
      mappings = filter.zip.inflate(mappings)
      
      -- write
      local F = io.open("proceduresMappings.csv", "w")
      F:write(mappings["Procedures Indication Mappings.csv"])
      F:close()
      
   end
   
   conn:close()




function main()
   
   -- ## Load CSV file and put it in queue. 
   local F = io.open("proceduresMappings.csv")
   local mappings = io.read("*a")
   F:close()
   
   queue.push{data=mappings}
   
end


