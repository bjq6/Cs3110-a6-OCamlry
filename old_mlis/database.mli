open Controller

(* A place on the map matrix *)
val loc : int * int
val player_id : string

(* Types of unit - all units start with the same base stats *)
type unit_type =  Infrantry  | Ocamlry  | Tank

(* Generic unit information for a unit_type *)
type base_unit = {
  unit_typ : unit_type; (* Type of unit*)
  max_hp : int;         (* Max health for a given type of unit *)
  max_mvt : int;        (* Max movement for a given type of unit*)
  unit_cost : int;      (* The cost of purchasing a single unit of said type*)
}

(* List of the above type *)
val base_unit_list : base_unit list


(* An individual unit of unit_type with unique unit_id *)
type unit_parameters = {
  typ : unit_type;        (* Type of unit *)
  plyr : player;          (* Player who owns the given unit *)
  unit_id : int;          (* Unique ID that reperesents this single unit*)
  active : mutable bool;  (* Reflects whether the unit acted on the given turn *)
  curr_hp : mutable int;  (* Reflects the current health of the unit*)
  curr_mvt : mutable int; (* Reflects how many more moves the unit has this turn*)
  position : mutable int*int  (* A location where the unit is now *)
}

(* Stats of a given building *)
type building_parameters = {
  max_hp : int;               (* Max health of a building *)
  owner : mutable player_id;  (* Player who owns it *)
  curr_hp : mutable int;      (* Current health of this building *)
  position : mutable int*int  (* A location where the building is on a map *)
}

(* What each tile/location on the map can be *)
type tile = Plain | Water | Building

(* A given player *)
type player = {
  player_name : player_id;      (* who this player is *)
  money : int;                  (* How much money this player has*)
  building_ids : list of ints;  (* All the buildings owned by this player *)
  unit_ids : list of ints;      (* All the units owned by this player*)
}

(* Total Gamestate *)
type gamestate = {
  map : list of list of tile;   (* Matrix representing tiles *)
  curr_player : player;         (* who the current player is *)
  player_state : list of player;  (* all the players in the game *)
  unit_list : list of unit_parameters;  (* all the units in the game *)
  building_list : list of building_parameters;  (* all the buildings in game *)
}


