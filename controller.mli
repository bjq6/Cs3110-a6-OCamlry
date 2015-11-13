open User
open Database

(** Starts the REPL *)
val begin : unit -> unit

(** Takes in an int representing a map (first thing asked for in REPL) and
 * sets ups a game *)
val configure : int -> gamestate

(** Process command will recieve raw [command] from the user, make sense of it
 * and call the proces process function *)
val process_command : string -> gamestate

val process_attack : unit_type * unit_type -> gamestate

val process_movement : unit_type -> gamestate

val process_buy : unit_type -> gamestate

val process_conquer : gamebuilding -> gamestate

val process_quit : gamestate -> gamestate

val main : gamestate -> gamestate