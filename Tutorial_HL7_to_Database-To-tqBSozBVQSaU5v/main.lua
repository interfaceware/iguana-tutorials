-- This short script maps specific patient data to an external SQLite database.
-- See http://help.interfaceware.com/v6/hl7-to-database
-- The same APIs can be used to write to other common database types like
-- MySQL, Microsoft SQL Server, Oracle, Maria DB etc. etc.
-- PLEASE READ THE TODO statement on line 38 and follow it.

require 'create_database'

-- This function is called by the main function lower down
function MapPatient(Patient, PID)
   Patient.Id        = PID[3][1][1]
   Patient.FirstName = PID[5][1][2]
   Patient.LastName  = PID[5][1][1][1]
   Patient.Gender    = PID[8]   
   -- Click the Patient Row to the right to see results
   return Patient
end

-- This shows how we can model a 'one to many'data relationship of a Patient to Kin.
-- This function is called in a loop from the main function

function MapKin(Kin, NK1, PatientId)
   Kin.PatientId    = PatientId
   Kin.FirstName    = NK1[2][1][2]
   Kin.LastName     = NK1[2][1][1][1]
   Kin.Relationship = NK1[3][1]
   -- Click the Kin Row to the right to see results
   return Kin
end

-- This is the main entry point in the translator, Data contains the HL7 message from sample data
function main(Data)
   -- By default the SQLite database is stored in iguana.workingDir()
   DB = db.connect{api=db.SQLITE, name='DemoDatabase.sqlite'}
   local Info = DatabaseLocation(DB)
	trace(Info)
   -- The Patient and Kin tables will be automatically created 
   -- TODO - Please comment out CreateTables(DB)
   -- after you have run the code the first time.
   CreateTables(DB)
   -- Parse incoming raw message with hl7.parse
   local MsgIn = hl7.parse{vmd='demo.vmd', data=Data}
   -- Build a table node tree structure to temporarily store 
   -- Patient and Kin data before saving it to the database 
   local TableOut = db.tables{vmd='demo_tables.vmd', name='ADT'}
   
   -- Map fields from PID segment to Patient table
   MapPatient(TableOut.Patient[1], MsgIn.PID)
   
   -- Map Kin for patient in one or more NK1 segments
   -- See how we loop through repeating data with a for loop?
   trace("We have "..#MsgIn.NK1.." kin.")
   for i=1, #MsgIn.NK1 do
      MapKin(TableOut.Kin[i],MsgIn.NK1[i],MsgIn.PID[3][1][1])
   end
   -- Insert information from TableOut into the database tables
   -- NOTE: To stop inserts being made live in the Editor set
   -- live=false
   DB:merge{data=TableOut, live=true}
   
   -- View data by clicking on Result Sets in annotations 
   DB:query{sql='Select * from Patient'}
   DB:query{sql='Select * from Kin'}
   
   -- Set live=true to clear data for the Patient and/or Kin table
   DB:execute{sql='Delete from Patient', live=false}   
   DB:execute{sql='Delete from Kin', live=false} 
   DB:close()
end


-- Suggest that you click around on the Purple function calls in the annotation blocks on the right to
-- navigate around the code and open up dialogs to see the data in it's various stages.
