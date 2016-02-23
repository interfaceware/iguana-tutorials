-- This script maps specific patient data to an external SQLite database.

-- If the database does not exist it will be automatically created
-- (in the Iguana executable folder).  But you will need to follow
-- instructions below to create the Patient database table in the database.

-- To control where the database goes, change the name below to an
-- absolute path such as 'C:\MyFolder\Database.sqlite' (on Windows),
-- or '/home/myhome/database.sqlite' (on Linux)  
DB = db.connect{api=db.SQLITE, name='DemoDatabase.sqlite'}

function main(Data)
   -- Parse incoming raw message with hl7.parse.  We use a schema
   -- file called adt.vmd.  You can edit this file with Chameleon
   local MsgIn = hl7.parse{vmd='adt.vmd', data=Data}
   -- Build node tree of tables to temporarily store information
   -- tables.vmd name = 'ADT'.  
   -- For more information on changing this file please read:
   -- http://help.interfaceware.com/code/details/tables-vmd
   local TableOut = db.tables{vmd='tables.vmd', name='ADT'}
   
   -- Map fields from PID segment to Patient table
   MapPatient(TableOut.Patient[1], MsgIn.PID)
   -- (1) To create the required 'Patient' table in the database,
   -- hover over the arrow beside 'tables.vmd' in the project
   -- folder, then choose 'Create DB Tables'. 
   -- Enter the name of your database file, set the API to
   -- SQLite, then click'Preview Create Statements',
   -- followed by 'Execute Statements'.
   
   -- Insert information from TableOut into the real table
   -- The table uses te key field "Id" to determine whether
   -- to insert or update a row in the Patient table
   DB:merge{data=TableOut, live=false}
   -- (2) Change the above live=false to live=true to run
   -- this code in the editor.
   -- (3) Remove the comment below and click Result Set in the
   -- annotations to the right
   -- DB:query{sql='Select * from Patient'}
end

function MapPatient(Patient, PID)
   -- This function prepares the TableOut variable
   Patient.Id        = PID[3][1][1]
   Patient.FirstName = PID[5][1][2]
   Patient.LastName  = PID[5][1][1][1]
   Patient.Gender    = PID[8]   
   -- Click the Patient Row to the right to see results
   return Patient
end
