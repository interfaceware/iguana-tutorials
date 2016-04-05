-- read VMD and create SQLite table creation script 
-- note: the SQL create is ***SQLite*specific***
function CreateVMDTables(DB, VMD)
   
   if os.fs.access(VMD, 'r') then
      -- if VMD is in the working directory
      io.input(VMD)
   else
      -- if VMD is NOT in the working directory
      -- then will be in the "other" directory
      io.input(iguana.project.files()["other/"..VMD])
   end

   vmd=io.read("*all")
   X=xml.parse{data=vmd}
   trace(X.engine.config:child('table',1):child('column',1).config.is_key[1]:nodeValue())
 
   for i=1,X.engine.global:childCount('table') do
      local Sql=''
      Sql=Sql..'CREATE TABLE IF NOT EXISTS '
      Sql=Sql..X.engine.global:child('table',i).name:nodeValue()
      Sql=Sql..'\n(\n'
      for j=1,X.engine.global:child('table',i):childCount('column') do
         Sql=Sql..X.engine.global:child('table',i):child('column',j).name:nodeValue()
         -- if primary key
         if X.engine.config:child('table',i):child('column',j).config.is_key[1]:nodeValue()=='True' then
            Sql=Sql..' TEXT(255) NOT NULL PRIMARY KEY' 
         else
            Sql=Sql..' TEXT(255) NULL' 
         end
         -- last field
         if j~=X.engine.global:child('table',i):childCount('column') then
            Sql=Sql..',\n'
         end
      end
      Sql=Sql..'\n);\n\n'
      trace(Sql)
      DB:execute{sql=Sql,live=true}
   end 
end