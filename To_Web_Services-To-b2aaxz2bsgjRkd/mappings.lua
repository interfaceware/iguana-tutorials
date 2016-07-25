local map = {}

-- Define the outgoing message format. In this case, it's JSON.
function map.template() 
   local JSONTemplate = [[{"patient": {
   "id": "",
   "name_first": "",
   "name_last": "",
   "city": "",
   "state": "",
   "zip": "",
   "phone_home": "",
   "phone_work": "",
   "race": "", 
   "gender": "", 
   "ssn": "" 
}
}]]
   
   return JSONTemplate
end

-- Map the incoming data to the outgoing message.
function map.mapPID (PID, MsgOut) 
   MsgOut.patient.id = PID[3][1][1]:nodeValue()
   MsgOut.patient.name_first = PID[5][1][2]:nodeValue()
   MsgOut.patient.name_last = PID[5][1][1][1]:nodeValue()
   MsgOut.patient.phone_home = PID[13][1][1]:nodeValue()
   MsgOut.patient.phone_work = PID[14][1][1]:nodeValue()
   MsgOut.patient.city = PID[11][1][3]:nodeValue()
   MsgOut.patient.state = PID[11][1][4]:nodeValue()
   MsgOut.patient.zip = PID[11][1][5]:nodeValue()
   MsgOut.patient.gender = PID[8]:nodeValue()
   MsgOut.patient.race = PID[10][1][1]:nodeValue()
   MsgOut.patient.ssn = PID[19]:nodeValue()
   return MsgOut

end

return map