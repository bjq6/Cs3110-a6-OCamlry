open Types

val print_map : gamestate -> unit

val unit_at_loc : unit_parameters list -> loc -> unit_parameters option

val b_at_loc : building_parameters list -> loc -> building_parameters option

val base_access : unit_parameters -> base_unit

val base_access_unit_type : unit_type -> base_unit

(*---------Commands from process command--------

(** Given a unit *)
val process_movement : loc * loc ->  gamestate

(** Given first a unit and then the unit it is attacking, it returns the
  gamestate with the proper damage and deaths made*)
val process_attack : loc * loc -> gamestate

(** Purchases a unit of type unit_type for the current player and places it at
  loc provided that there is a building there that doesn't already have a unit
  on it and the current player has the proper resources to purchase the unit*)
val process_buy : loc * unit_type -> gamestate

(** Ends the turn, reactivates units, updates monies and turns over control*)
val process_end_turn : unit -> gamestate

(** Ends the game *)
val process_surrender : unit -> unit

(** Sends the game in a full loop and makes the player try re-entering the
  * command *)
val process_invalid : unit -> gamestate

---------------------------------------------*)