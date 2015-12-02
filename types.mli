open Async.Std

(* A place on the map matrix *)
type loc = int * int
type player_id = Player1 of string | Player2 of string


(* A given player *)
type player = {
  player_name : player_id;      (* who this player is *)
  money : int;                  (* How much money this player has*)
  building_ids : int list;  (* All the buildings owned by this player *)
  unit_ids : int list;      (* All the units owned by this player*)
}

(* Types of unit - all units start with the same base stats *)
type unit_type =  Infantry  | Ocamlry  | Tank

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
  plyr : player_id;          (* Player who owns the given unit *)
  unit_id : int;          (* Unique ID that reperesents this single unit*)
  mutable active : bool;   (* Reflects whether the unit acted on the given turn *)
  mutable curr_hp : int;  (* Reflects the current health of the unit*)
  mutable curr_mvt : int; (* Reflects how many more moves the unit has this turn*)
  mutable position : int*int;  (* A location where the unit is now *)
}

(* Stats of a given building *)
type building_parameters = {
  max_hp : int;               (* Max health of a building *)
  mutable owner : player_id;  (* Player who owns it *)
  mutable curr_hp : int;      (* Current health of this building *)
  mutable position : int*int; (* A location where the building is on a map *)
}


(* What each tile/location on the map can be *)
type terrain = Plain | Water | Building of player_id option


(* Total Gamestate *)
type gamestate = {
  map : terrain array array;   (* Matrix representing tiles *)
  curr_player : player;         (* who the current player is *)
  player_state : player list;  (* all the players in the game *)
  unit_list : unit_parameters list;  (* all the units in the game *)
  building_list : building_parameters list;  (* all the buildings in game *)
  (*updated : gamestate Deferred.t;  (*updated*)*)
}
type cmd =
    |Move of loc * loc
    |Attack of loc * loc
    |Capture of loc
    |Buy of unit_type * loc
    |Invalid of bytes
    |Surrender
    |EndTurn
