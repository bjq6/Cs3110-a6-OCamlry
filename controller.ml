open Types
open Util
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
(*you are welcome to clean this up, just trying to get something to work right now*)
let process_command (c:cmd) (g:gamestate) : gamestate =
  match c with
  | Invalid s -> Printf.printf "%s\n" s; g
  | Surrender ->
    (*surrender protocol:Clarkson Wins Exit 0
    print_endline "Clarkson wins"; Exit 0*) failwith "unimplemented"
  | EndTurn -> failwith "unimplemented"
    (*modify gamestate to change player, return new gamestate*)

    (*add money to new players bank(100 per building owned)*)

    (*refresh all unit(have refresh func in util)*)
  | Move ((x1,y1),(x2,y2)) ->
    (*check x to see if unit present belonging to current player*)
    begin
    match (unit_at_loc g.unit_list (x1,y1)) with
    | None -> print_endline "No unit at this location"; g
    | Some u -> if (g.curr_player.player_name <> u.plyr)
      then (print_endline "This is not your unit"; g)
      else

    (*check y to see if space available and is plain or building*)

      match (unit_at_loc g.unit_list (x2,y2)) with
      | Some z -> print_endline "Space currently occupied by unit"; g
      | None -> if ((g.map).(x2).(y2) = Water)
        then (print_endline "Can't move to water"; g)
        else
    (*check if unit can move that many spaces. use abs delta x + delta y*)
        let move_amt = abs ((x1-x2)+(y1-y2)) in
        if (move_amt > u.curr_mvt)
          then (print_endline "Movement is too far"; g)
          else
    (*update x, y, unit position, unit state to reflect # of spaces moved*)
    (*active?
            (u.position := (x2,y2);
            u.curr_mvt := u.curr_mvt - move_amt; g) *) g
    end
    (*if any conditions fail: print error message, return original state*)
    (*return new gamestate*)
  | Attack ((x1,y1),(x2,y2)) ->
    (*check x to see if unit present belonging to current player*)
    begin
    match (unit_at_loc g.unit_list (x1,y1)) with
    | None -> print_endline "No unit at attack location"; g
    | Some u -> if (g.curr_player.player_name <> u.plyr)
      then (print_endline "This is not your unit"; g)
      else
    (*check y to see if unit present belonging to enemy*)
      match (unit_at_loc g.unit_list (x2,y2)) with
      | None -> print_endline "No unit at target location"; g
      | Some target -> if (g.curr_player.player_name = u.plyr)
        then (print_endline "You can't attack yourself :/"; g)
        else
    (*check to make sure distance is in attack range*)
        let move_amt = abs ((x1-x2)+(y1-y2)) in
        if move_amt > u.curr_mvt (*filler code. where is attack range field*)
          then (print_endline "Movement is too far"; g)
          else
    (*call battle function in util with two units. returns two units*)
           (*let (u',target') = battle_module u target in*)
    (*update gamestate with updated units*)
    (*return new gamestate*)
    g
    end
  | Capture x -> (*same as attack but with unit, building on same space*)
  failwith "unimplemented"
  | Buy (u,x) -> failwith "unimplemented"
    (*check to make sure there is a building at x that is owned by the player*)
    (*check to make sure there is no a unit at x*)
    (*check to make sure the player has enough money to buy the unit*)
    (*subtract the money from the player*)
    (*add a unit to the unit list at x that is inactive(cannot move or attack)*)
    (*update the gamestate*)


