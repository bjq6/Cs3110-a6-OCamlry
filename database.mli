(*Define all the units here*)

type unit_type =  Infrantry  | Ocamlry  | Tank 
type unit_parameters = {
  max_hp : int;
  max_mvt : int;
  unit_cost : int;
  typ : game_unit; 
  unit_id : int;
  position : mutable int*int;
  curr_hp : mutable int;
  movement_capabailit : mutable int;
  active : mutable bool
}

val update_state : state -> state


