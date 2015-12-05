open Types
open Getcmd

(** Starts the REPL *)
val begin_game : unit -> unit

(** Loop/Repl - prompts user, process_command, update gamestate, call main again *)
val main : gamestate -> bytes option -> cmd list -> unit

(** Process command will receive a command from the user module, make sense of it
 * and call the proper process function below - basically a wrapper for below *)
val process_command : cmd->gamestate-> gamestate
