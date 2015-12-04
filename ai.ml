open Types
open Util

(* start_ai will take the current game state and compute what the best move
currently is and send in list of commands to accomplish that move.

For example, that could mean moving to a place and then attack, or moving then
capturing, just moving, or ending the turn. Therefore cmd list will always
have at least one command in it, but at most two commands. *)
let start_ai (g:gamestate) : cmd list = failwith "unimplemented"

