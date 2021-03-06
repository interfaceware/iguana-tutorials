local mapDB = {}


-- CHANGE CONNECTION SETTINGS HERE
function mapDB.init() 

   -- Defines connection. Will create new one if it doesn't exist
   local conn = db.connect{
      api=db.SQLITE,
      name='Training/mappingsDB.sqlite'}


   -- Checks to see if tables exist. 
   -- If not, will create database tables.
   local tables, err = pcall(checkTables,conn)
   trace(tables)
   
   if tables == false then 
      
      trace (err) 
   
      -- Create table
      conn:execute{sql=createProcedures(),live=true}
         
   end

   return conn

end





function checkTables(conn)  

   local tables = conn:query{sql=[[SELECT * FROM 'procedures']]}
   return tables

end

function createProcedures()  

   local sql = [[CREATE TABLE `procedures` (
	`ProcedureID`	INTEGER,
	`ProcedureDescription`	TEXT,
	`IndicationID`	INTEGER,
	`IndicationDescription`	TEXT,
	PRIMARY KEY(IndicationID)
);]]
   
   return sql

end

return mapDB