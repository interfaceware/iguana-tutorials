function MapPatient(Patient, PID)
   -- This function prepares the TableOut variable
   Patient.Id        = PID[3][1][1]
   Patient.FirstName = PID[5][1][2]
   Patient.LastName  = PID[5][1][1][1]
   Patient.Gender    = PID[8]   
   -- Click the Patient Row to the right to see results
   return Patient
end