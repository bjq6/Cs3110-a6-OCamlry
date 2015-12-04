

let create_dummy_unit owner x y typ hp =
  {typ = typ; plyr = owner; unit_id= 0; active = true; curr_hp = hp;
  curr_mvt = 0; position = (x,y);}

let my_unit = create_dummy_unit (Player1 "me") 5 5 (Infantry) 100

let enems =
    [create_dummy_unit (Player2 "en") 5 6 (Tank) 100;
     create_dummy_unit (Player2 "en") 6 5 (Ocamlry) 100;
     create_dummy_unit (Player2 "en") 4 5 (Infantry) 100;
     create_dummy_unit (Player2 "en") 5 4 (Tank) 100]

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

let top_kill this_unit enemy_units g : loc option =
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
            | Some m -> Some m
            | None -> attack_helper t
          end
        | [] ->
          (*If not, is there at least a favorable trade?*)
          let favorable = List.filter (favorable_trade this_unit) enems in
          let rec favorable_helper maim_list=
            match maim_list with
            | h::t ->
              begin
                match (next_to this_unit h g)  with
                | Some m -> Some m
                | None -> favorable_helper t
              end
            | [] -> None
          in
          favorable_helper favorable
      in
      attack_helper killable