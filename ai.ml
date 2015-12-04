open Types
open Util
open Battle

(*Creates a list of health pairs, for a simulated battle with all of the units
in a given enemy list and your unit*)
let sim_all this_unit enemy_units : (int*int) list =
  List.map (sim_battle this_unit) enemy_units

(*Makes a list of priorities, how favorable an attack on a list of units is*)
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

(*Returns a bool whether your unit would die in a battle with enemy unit*)
let kill_mine mine enemy : bool =
  match (sim_battle mine enemy) with
  | (0,_) -> true
  | _ -> false

(*Returns a bool whether your unit could kill the enemy unit*)
let kill_theirs mine enemy : bool =
  match (sim_battle mine enemy) with
  | (_,0) -> true
  | _ -> false

(*Given one of your units and an enemy unit, it returns a bool:
True if he will lose more damage than you
False if you will lose more damage than it*)
let favorable_trade (mine:unit_parameters) (enemy:unit_parameters) : bool =
  let me_health = mine.curr_hp in
  let enem_health = enemy.curr_hp in
  let (new_me,new_them) = sim_battle mine enemy in
    let percen =
      try (float_of_int(enem_health - new_them)/.float_of_int(me_health - new_me))
      with Failure "Division_by_zero" -> max_float
    in
      if percen>1. then true else false

(*Given your unit and a list of enemy units, it returns a location option
Some loc - if there is a unit in range that is worth attacking
None - if there are no units in range worth attacking*)
let top_kill this_unit enemy_units g : (loc * loc) option =
  (*Are there enemies in range*)
  let in_range = enemy_check this_unit enemy_units [] in
  match in_range with
  | [] -> None
  | enems ->
      (*Can I kill an enemy*)
      let killable = List.filter (kill_theirs this_unit) enems in
      let rec attack_helper kill_list=
        match kill_list with
        | h::t ->
          begin
            match (next_to this_unit h g)  with
            | Some m -> Some (h.position,m)
            | None -> attack_helper t
          end
        | [] ->
          (*If not, is there at least a favorable trade?*)
          let favorable = List.filter (favorable_trade this_unit) enems in
          let rec favorable_helper maim_list=
            begin
            match maim_list with
            | h::t ->
              begin
                match (next_to this_unit h g)  with
                | Some m -> Some (h.position,m)
                | None -> favorable_helper t
              end
            | [] -> None
            end
          in
          favorable_helper favorable
      in
      attack_helper killable


(*
let who_to_attack this_unit enemy_units : unit_parameters =
  let (enemy_inf, enemy_camls, enemy_tanks) = sort_units enemy_units in
  match this_unit.typ with
  | Infantry ->
  | Ocamlry ->
  | Tank ->
*)

let inf_turn (this_inf:unit_parameters) enemies g : cmd list =

  let my_pos = this_inf.position in
  let backup_step =
  (move_towards_enemy_unit this_inf enemies g.building_list g.map) in

  (*Currently capturing a building?*)
  begin
  match (b_at_loc g.building_list my_pos) with
  | Some b ->
      if (not(g.curr_player.player_name = b.owner)) then [Capture my_pos]
      else [Move (my_pos,backup_step)]
  | None ->
    (*Can I capture a building*)
    let near_buildings = building_check this_inf g.building_list [] g.unit_list in
    begin
    match near_buildings with
    | h::_ -> [Move (this_inf.position,h.position); Capture h.position]
    | [] ->
      begin
      match (top_kill this_inf enemies g) with
      | Some (me,them) -> [Move (my_pos,me); Attack (me,them)]
      | None -> [Move (my_pos,backup_step)]
      end
    end
  end


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