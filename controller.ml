open Types
open Util
open Getcmd
open Battle

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
  | Invalid s -> Printf.printf "Invalid command %s\n" s; g
  | Surrender ->
    (*surrender protocol:Clarkson Wins Exit 0
    print_endline "Clarkson wins"; Exit 0*) failwith "unimplemented"
  | EndTurn -> failwith "unimplemented"
    (*modify gamestate to change player, return new gamestate*)

    (*add money to new players bank(100 per building owned)*)

    (*refresh all unit(have refresh func in util)*)
  | Move ((x1,y1),(x2,y2)) ->
    (*check to see if unit present belonging to current player*)
    begin
    match (unit_at_loc g.unit_list (x1,y1)) with
    | None -> print_endline "No unit at this location"; g
    | Some u -> if (g.curr_player.player_name <> u.plyr)
      then (print_endline "This is not your unit"; g)
      else

    (*check to see if unit is active*)
      if (not u.active) then (print_endline "Unit not active"; g)
      else

    (*check y to see if space available and is plain or building*)

      match (unit_at_loc g.unit_list (x2,y2)) with
      | Some z -> print_endline "Space currently occupied by unit"; g
      | None -> if ((g.map).(x2).(y2) = Water)
        then (print_endline "Can't move to water"; g)
        else
    (*check if unit can move that many spaces. use abs delta x + delta y*)
        let move_amt = abs (x1-x2)+ abs (y1-y2) in
        if (move_amt > u.curr_mvt)
          then (print_endline "Movement is too far"; g)
          else
    (*update x, y, unit position, unit state to reflect # of spaces moved*)
            (u.position <- (x2,y2);
            u.curr_mvt <- u.curr_mvt - move_amt; g)
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

    (*check to see if unit is active*)
      if (not u.active) then (print_endline "Unit not active"; g)
      else

    (*check y to see if unit present belonging to enemy*)
      match (unit_at_loc g.unit_list (x2,y2)) with
      | None -> print_endline "No unit at target location"; g
      | Some target -> if (g.curr_player.player_name = u.plyr)
        then (print_endline "You can't attack yourself :/"; g)
        else
    (*check to make sure distance is in attack range*)
        let range = abs (x1-x2) + abs (y1-y2) in
        let base = base_access u in
        if (range > base.attack_range)
          then (print_endline "Movement is too far"; g)
          else
    (*call battle function in util with two units. returns unit list*)
           let new_unit_list = battle u target g.unit_list in
    (*update gamestate with updated units*)
           g.unit_list <- new_unit_list;
    (*return new gamestate*)
    g
    end
  | Capture (x,y) ->
  (*same as attack but with unit, building on same space*)
  (*only infantry can capture*)

  (*check to see if unit present belonging to current player*)
    begin
    match (unit_at_loc g.unit_list (x,y)) with
    | None -> print_endline "No unit at attack location"; g
    | Some u -> if (g.curr_player.player_name <> u.plyr)
      then (print_endline "This is not your unit"; g)
      else

    (*check to see if unit is active*)
      if (not u.active) then (print_endline "Unit not active"; g)
      else

      (*check if infantry*)
      if (u.typ <> Infantry) then (print_endline "Only Infantry can capture"; g)
      else

    (*check y to see if building present belonging to enemy*)
      let target = (b_at_loc g.building_list (x,y)) in

      match target with
      | None -> print_endline "No building at target location"; g
      | Some b -> if (g.curr_player.player_name = b.owner)
        then (print_endline "You already own this building :/"; g)
        else

    (*call capture function in util. returns building list*)

        let new_building_list = capture u.plyr b g.building_list in
    (*update gamestate with updated building list*)
          g.building_list <- new_building_list;
    (*return new gamestate*)
    g

  end

  | Buy (u,x) ->
    (*u is base unit, x is loc of building*)
    (*check to make sure there is a building at x that is owned by the player*)
    let target = (b_at_loc g.building_list x) in

    match target with
    | None -> print_endline "No building at purchase location"; g
    | Some b -> if (g.curr_player.player_name <> b.owner)
      then (print_endline "You don't own this building :/"; g)
      else
    (*check to make sure there is not a unit at x*)
      match (unit_at_loc g.unit_list x) with
      | Some u -> print_endline "There's a unit already here!"; g
      | None ->
    (*check to make sure the player has enough money to buy the unit*)
        let product = base_access_unit_type u in
        if (g.curr_player.money < product.unit_cost)
          then (print_endline "You too broke to buy this"; g)
          else
    (*subtract the money from the player*)
            (g.curr_player.money <- g.curr_player.money - product.unit_cost;
    (*add a unit to the unit list at x that is inactive(cannot move or attack)*)
            let new_u = {typ = u; plyr = g.curr_player.player_name;
            unit_id = 3110; active = false; curr_hp = product.max_hp;
            curr_mvt = product.max_mvt; position = x} in
            g.unit_list <- (new_u :: g.unit_list);
            g.curr_player.unit_ids <- (new_u.unit_id :: g.curr_player.unit_ids);

    (*update the gamestate*)
    g)

