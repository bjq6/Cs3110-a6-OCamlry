open Types
open Util
open Getcmd
open Battle
open Gamestates
open View
open Ai


(** Process command will receive a command from the user module, make sense of it
 * and call the proper process function below - basically a wrapper for below *)
(*you are welcome to clean this up, just trying to get something to work now*)
(*distances between units measured as manhattan distance not euclidean*)
let process_command (c:cmd) (g:gamestate) : gamestate =
  match c with
  | Invalid s -> Printf.printf "Invalid command %s\n" s; g
  | Surrender ->
    (*surrender protocol:Clarkson Wins Exit 0 *)
    print_endline "You Have Surrendered: Thank you for playing\n";
    g.game_over<-true;
    g
  | EndTurn ->
    print_endline "End Turn";
    (*modify gamestate to change player*)
      g.curr_player <- next_player g;
    (*add money to new players bank(100 per building owned)*)
      let num = num_building g.building_list g.curr_player.player_name 0 in
      g.curr_player.money <- g.curr_player.money + (num*100);
    (*refresh all unit(have refresh func in util); return g*)
      g.turn<-g.turn + 1;
      refresh g.unit_list; g

  | Move ((x1,y1),(x2,y2)) ->
    Printf.printf "Moving from (%d,%d) to (%d,%d)\n" x1 y1 x2 y2;
    (*check to see if unit present belonging to current player*)
    begin

    (*make sure inputs are on map*)
    if (not (map_check (x1,y1) g.map)|| not (map_check (x2,y2) g.map))
    then (print_endline "Input off map"; g)
    else

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
      | Some z ->
        print_endline "Space currently occupied by unit"; g
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
    Printf.printf "Attacking from (%d,%d) to (%d,%d)\n" x1 y1 x2 y2;
    (*check x to see if unit present belonging to current player*)
    begin

    (*make sure inputs are on map*)
    if (not (map_check (x1,y1) g.map)|| not (map_check (x2,y2) g.map))
    then (print_endline "Input off map"; g)
    else

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
      | Some target -> if (g.curr_player.player_name = target.plyr)
        then (print_endline "You can't attack yourself :("; g)
        else
    (*check to make sure distance is in attack range*)
        let range = abs (x1-x2) + abs (y1-y2) in
        let base = base_access u in
        if (range > base.attack_range)
          then (print_endline "Attack is too far"; g)
          else
    (*call battle function in util with two units. returns unit list*)
           let (i, new_unit_list) = battle u target g.unit_list in
    (*update gamestate with updated units*)
           g.unit_list <- new_unit_list;
           g.curr_player.score <- g.curr_player.score + i;
           let my_un = List.length (get_units new_unit_list g.curr_player.player_name []) in
           let en_un = List.length (get_units new_unit_list (next_player g).player_name []) in
           let () = Printf.printf "I have %d units:He has %d units\n" my_un en_un in
           g.game_over <-(my_un=0) ||(en_un=0);
    (*return new gamestate*)
    g
    end
  | Capture (x,y) ->
    Printf.printf "Capturing building at (%d,%d)\n" x y;

  (*same as attack but with unit, building on same space*)
  (*only infantry can capture*)

  (*check to see if unit present belonging to current player*)
    begin

  (*make sure inputs are on map*)
    if (not (map_check (x,y) g.map))
    then (print_endline "Input off map"; g) else

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

    (*change building owner in map, update unit as inactive*)
          ((g.map).(x).(y)) <- (Building (Some g.curr_player.player_name));
          u.active <- false;

    (*return new gamestate*)
    g

  end

  | Buy (u,x) ->
    (*u is base unit, x is loc of building*)

    (*make sure inputs are on map*)
    if (not (map_check x g.map)) then (print_endline "Input off map"; g) else

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
            unit_id = (newvar ()); active = false; curr_hp = product.max_hp;
            curr_mvt = product.max_mvt; position = x} in
            g.unit_list <- (new_u :: g.unit_list);

    (*update the gamestate*)
    g)





(** Loop/Repl - prompts user, process_command, update gamestate, call main again *)
let rec main (s:gamestate) (ai_name: bytes option) (nxt_cmd: cmd list) =
  (*check if AI; get command from AI or user*)
  let str = match s.curr_player.player_name with Player1 s -> s |Player2 s-> s in

  let (cmd_2_process,next_cmd) =
  match str, ai_name, nxt_cmd with
  | cur_p,Some ai, h::t ->
    (*let _ = after (Core.Std.sec 1.) in*)
    (h,t)
  | cur_p, Some ai, [] ->
    if (cur_p = ai) then
      (*let _ = after (Core.Std.sec 1.) in*)
          let _ = print_endline("AI's Turn") in
      let commands_to_do = start_ai s in
        begin
        match commands_to_do with
        | h::t -> (h,t)
        | [] -> let _ = print_endline("AI is confused") in (EndTurn,[])
        end
    else let cmd = getcmd (str) in (cmd,[])
  | _,None,_ ->
    let cmd = getcmd (str) in (cmd,[])
  in
    let g = process_command cmd_2_process s in
    let end_game = g.game_over  in (*Need to add something to type to see if game has ended*)
    (*update view*)
    let () = Printf.printf ">>> Turn %d <<<\n" g.turn in
    let () = update_state g in
    (*froot loop it and return unit. actual unit not matt unit*)
    if end_game then () else main g ai_name next_cmd


  (** Starts the REPL *)
let begin_game () =
    let map_num = get_map_num () in
    let name1 = get_player_name 1 None in
    let name2 = get_player_name 2 (Some name1) in
    let ai_bool = play_ai () in
    let main_state = configure map_num name1 name2 in
    let () = init(main_state) in
    if ai_bool then (main main_state (Some name2) []) else (main main_state None [])

let _ = begin_game ()