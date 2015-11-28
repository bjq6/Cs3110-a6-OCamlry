open Types
open Getcmd

(** Starts the REPL *)
let begin_game () = ()

(** Takes in an int representing a map (first thing asked for in REPL) and
 * sets ups a game *)
let configure (i:int) = failwith "unimplemented"

(** Loop/Repl - prompts user, process_command, update gamestate, call main again *)
let rec main (s:gamestate) = failwith "unimplemented"

(** Process command will receive a command from the user module, make sense of it
 * and call the proper process function below - basically a wrapper for below *)
let process_command (c:cmd) = failwith "unimplemented"
