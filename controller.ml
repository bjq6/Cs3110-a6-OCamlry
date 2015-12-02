open Types
open Getcmd

(** Starts the REPL *)
let begin_game () = ()

(** Takes in an int representing a map (first thing asked for in REPL) and
 * sets ups a game *)
let configure (i:int) = failwith "unimplemented"

(** Loop/Repl - prompts user, process_command, update gamestate, call main again *)
let rec main (s:gamestate) = failwith "unimplemented"
(*check if AI; get command from AI or user*)

(*process command*)

(*update view*)

(*froot loop it and return unit. actual unit not matt unit*)

(** Process command will receive a command from the user module, make sense of it
 * and call the proper process function below - basically a wrapper for below *)
let process_command (c:cmd) (g:gamestate) : gamestate = failwith "unimplemented"
(*
  match c with
  | Invalid s -> printf "%s\n" s; g
  | Surrender -> (*surrender protocol*)
  | EndTurn -> (*modify gamestate to change player, return new gamestate*)
  | Move (x,y) ->
    (*check x to see if unit present belonging to current player*)
    (*check y to see if space available and is plain or building*)
    (*check if unit can move that many spaces. use abs delta x + delta y*)
    (*TODO: make sure path is available*)
    (*update x, y, unit position, unit state to reflect # of spaces moved*)
    (*if any conditions fail: print error message, return original state*)
    (*return new gamestate*)
  | Attack (x,y) ->
    (*check x to see if unit present belonging to current player*)
    (*check y to see if unit present belonging to enemy*)
    (*check to make sure distance is in attack range*)
    (*call battle function in util with two units. returns two units*)
    (*update gamestate with updated units*)
    (*return new gamestate*)
  | Capture x -> (*same as attack but with unit, building on same space*)
  | Buy (u,x) ->
*)

