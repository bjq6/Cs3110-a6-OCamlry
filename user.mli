type dirr = 
  |North 
  |South
  |East
  |West

type loc = int * int
type unit_id = string
type command = 
  |Move of dirr
  |Attack of loc * loc
  |Capture of loc
  |Buy of unit_id *loc 


