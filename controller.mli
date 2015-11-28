open Types
open Getcmd

(** Starts the REPL *)
val begin_game : unit -> unit

(** Takes in an int representing a map (first thing asked for in REPL) and
 * sets ups a game *)
val configure : int -> gamestate

(** Loop/Repl - prompts user, process_command, update gamestate, call main again *)
val main : gamestate -> unit

(** Process command will receive a command from the user module, make sense of it
 * and call the proper process function below - basically a wrapper for below *)
val process_command : cmd -> gamestate