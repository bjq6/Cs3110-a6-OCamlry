open User
open Database

(** Starts the REPL *)
val begin : unit -> unit

(** Takes in an int representing a map (first thing asked for in REPL) and
 * sets ups a game *)
val configure : int -> gamestate

(** Loop/Repl - prompts user, process_command, update gamestate, call main again *)
val main : gamestate -> unit

(** Process command will receive a command from the user module, make sense of it
 * and call the proper process function below - basically a wrapper for below *)
val process_command : command -> gamestate

(*---------Commands from process command--------*)

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

(*---------------------------------------------*)

