open Types
open Util
open Battle

let sim_all this_unit enemy_units : (int*int) list =
  List.map (sim_battle this_unit) enemy_units

let priority_kill health_list : float list =
  let rec kill_help l =
    match l with
    | (mine,their)::t ->
        let h =
          try (float_of_int(mine)/.float_of_int(their))
          with Failure "Division_by_zero" -> max_float
        in
        h::kill_help(t)
    | [] -> []
  in
  kill_help health_list

let kill_mine mine enemy : bool =
  match (sim_battle mine enemy) with
  | (0,_) -> true
  | _ -> false

let kill_theirs mine enemy : bool =
  match (sim_battle mine enemy) with
  | (_,0) -> true
  | _ -> false

let favorable_trade (mine:unit_parameters) (enemy:unit_parameters) : bool =
  let me_health = mine.curr_hp in
  let enem_health = enemy.curr_hp in
  let (new_me,new_them) = sim_battle mine enemy in
    let percen =
      try (float_of_int(enem_health - new_them)/.float_of_int(me_health - new_me))
      with Failure "Division_by_zero" -> max_float
    in
      if percen>1. then true else false

let top_kill this_unit enemy_units : loc option =
  match enemy_units with
  | [] -> None
  | enems ->
      let killable = List.filter (kill_theirs this_unit) enems in
      match killable with
      | h::t -> []


(*
let who_to_attack this_unit enemy_units : unit_parameters =
  let (enemy_inf, enemy_camls, enemy_tanks) = sort_units enemy_units in
  match this_unit.typ with
  | Infantry ->
  | Ocamlry ->
  | Tank ->
*)
(*
let inf_turn this_inf enemy_inf enemy_camls enemy_tanks g : cmd list =

  let my_pos = this_inf.positon in

  (*Currently capturing a building?*)
  match (b_at_loc g.building_list my_pos) with
  | Some b ->
      if not (g.curr_player.player_name = b.owner) then [Capture my_pos]
  | None ->
    (*Can I capture a building*)
    let near_buildings = building_check this_inf g.building_list [] g.unit_list in
    match near_buildings with
    | h::_ -> [Move h.positon; Capture h.positon]
    | [] ->
      (*Are enemies in range?*)
      let near_enemies = enemy_check this_inf
        enemy_inf@enemy_camls@enemy_tanks [] in
      match near_enemies with
      |
      |
        (*Can I kill it?*)
*)
(*
let caml_turn this_inf enemy_inf enemy_camls enemy_tanks g : cmd list =
      failwith "unimplemented"

let tank_turn this_inf enemy_inf enemy_camls enemy_tanks g : cmd list =
      failwith "unimplemented"
*)

(* start_ai will take the current game state and compute what the best move
currently is and send in list of commands to accomplish that move.

For example, that could mean moving to a place and then attack, or moving then
capturing, just moving, or ending the turn. Therefore cmd list will always
have at least one command in it, but at most two commands. *)

(*

let start_ai (g:gamestate) : cmd list =

  let my_units = get_units g.unit_list g.curr_player [] in
  let (my_inf,my_camls,my_tanks) = sort_units my_units ([],[],[]) in

  let enemy_units = get_units g.unit_list (next_player g) [] in
  let (enemy_i,enemy_c,enemy_t) = sort_units enemy_units ([],[],[]) in

  match my_tanks, my_camls, my_inf with
  | [], [], [] -> [EndTurn]
  | [], [], curr_inf::t -> inf_turn curr_inf enemy_i enemy_c enemy_t g

  (*
  | [], curr_caml::t, _ -> caml_turn curr_inf enemy_i enemy_c enemy_t g
  | curr_tank::t, _, _  -> tank_turn curr_inf enemy_i enemy_c enemy_t g
  *)
  | _ -> [Surrender]

*)