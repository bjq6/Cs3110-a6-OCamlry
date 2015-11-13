open Controller

(*Define all the units here*)

type unit_type =  Infrantry  | Ocamlry  | Tank

type base_unit = {
  unit_typ : unit_type; (* Type of unit*)
  max_hp : int;         (* Max health for a given type of unit *)
  max_mvt : int;        (* Max movement for a given type of unit*)
  unit_cost : int;      (* The cost of purchasing a single unit of said type*)
}

type unit_parameters = {
  typ : unit_type;
  unit_id : int;
  active : mutable bool;
  curr_hp : mutable int;
  curr_mvt : mutable int;
  position : mutable int*int
}

type building_parameters = {
  builing_id : int;
  max_hp : int;
  curr_hp : mutable int;
  active : mutable bool;
}

type tile = Plain | Water | Building

type player = {
  money : int;
  building_ids : list of ints;
  unit_ids : list of ints;
}

type gamestate = {
  map : list of list of tile;
  player_state : list of player;
  unit_list : list of unit_parameters;
  building_list : list of building_parameters;
}

val update_state : gamestate -> gamestate


