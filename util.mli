open Types

(* given location, returns the unit option at that location *)
val unit_at_loc : unit_parameters list -> loc -> unit_parameters option

(* given location, returns the building option at that location*)
val b_at_loc : building_parameters list -> loc -> building_parameters option

(* Precondition : there are only 2 players defined
Given the current gamestate, returns the next player
NOT the player_id *)
val next_player : gamestate -> player

(*get base_unit info given unit_parameters*)
val base_access : unit_parameters -> base_unit

(*get base_unit info given unit_type*)
val base_access_unit_type : unit_type -> base_unit

(* Re-activate all units at the end of each turn*)
val refresh : unit_parameters list -> unit

val create_unit : player_id -> int -> int -> unit_type -> unit_parameters

val create_building : player_id -> int -> int -> building_parameters

val num_building : building_parameters list -> player_id -> int -> int

val get_units : unit_parameters list -> player_id -> unit_parameters list ->
  unit_parameters list

val newvar : unit -> int

val sort_units : unit_parameters list -> (unit_parameters list *
  unit_parameters list * unit_parameters list) ->
  unit_parameters list * unit_parameters list * unit_parameters list

val map_check : int*int -> terrain array array -> bool

val enemy_check : unit_parameters -> unit_parameters list ->
  unit_parameters list -> unit_parameters list

val building_check : unit_parameters -> building_parameters list ->
  building_parameters list -> unit_parameters list -> building_parameters list

val next_to : unit_parameters -> unit_parameters -> gamestate -> loc option

val move_rand : terrain array array -> unit_parameters list -> int*int


val next_close_enemy_unit : unit_parameters -> unit_parameters list ->
  building_parameters list -> terrain array array -> unit_parameters list ->
  int*int

val my_buildings : gamestate -> building_parameters list ->
  building_parameters list -> building_parameters list

val purchase : int*int*int -> int -> building_parameters list -> cmd list ->
  cmd list

val buy_ai : gamestate -> cmd list

val out_of_moves : unit_parameters list -> unit_parameters list ->
  unit_parameters list

val get_map_num : unit -> int

val get_player_name : int -> bytes option -> bytes

val play_ai : unit -> bool

val go_check : int*int -> terrain array array -> unit_parameters list -> bool

val dist : (int*int) list -> (int*int*int) list -> int*int -> (int*int*int) list

val min_dist : (int*int*int) list -> (int*int*int) -> (int*int*int)

val move_it : unit_parameters -> int*int -> terrain array array ->
 unit_parameters list -> cmd
