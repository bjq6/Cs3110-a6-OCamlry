(* A place on the map matrix *)
type loc = int * int
type player_id = Player1 of string | Player2 of string
type specific_unit_id = int
type unit_type =  Infantry  | Ocamlry  | Tank

(* Generic unit information for a unit_type *)
type base_unit = {
  unit_typ : unit_type; (* Type of unit*)
  max_hp : int;         (* Max health for a given type of unit *)
  max_mvt : int;        (* Max movement for a given type of unit*)
  unit_cost : int;      (* The cost of purchasing a single unit of said type*)
  attack_range : int;   (* The max distance the unit can attack from*)
}

(* An individual unit of unit_type with unique unit_id *)
type unit_parameters = {
  typ : unit_type;        (* Type of unit *)
  plyr : player_id;          (* Player who owns the given unit *)
  unit_id : specific_unit_id;(* Unique ID that reperesents this single unit*)
  mutable active : bool;   (* Reflects whether the unit acted on the given turn *)
  mutable curr_hp : int;  (* Reflects the current health of the unit*)
  mutable curr_mvt : int; (* Reflects how many more moves the unit has this turn*)
  mutable position : loc;  (* A location where the unit is now *)
}

let infantry_base = {unit_typ = Infantry; max_hp = 100; max_mvt = 3;
  unit_cost = 200; attack_range = 1}

let ocamlry_base = {unit_typ = Ocamlry; max_hp = 150; max_mvt = 5;
  unit_cost = 500; attack_range = 1}

let tank_base = {unit_typ = Tank; max_hp = 250; max_mvt = 4;
  unit_cost = 1000; attack_range = 1}


let base_access (x : unit_parameters) =
  match x.typ with
  | Infantry -> infantry_base
  | Ocamlry -> ocamlry_base
  | Tank -> tank_base

let battle_generic (attacker:unit_type)(defender:unit_type):float =
  match (attacker,defender) with
  |(Infantry,Infantry)->0.75
  |(Infantry,Ocamlry) ->0.55
  |(Infantry,Tank)    ->0.25
  |(Ocamlry,Infantry) ->0.95
  |(Ocamlry,Ocamlry)  ->0.65
  |(Ocamlry,Tank)     ->0.35
  |(Tank,Infantry)    ->0.65
  |(Tank,Ocamlry)     ->0.65
  |(Tank,Tank)        ->0.75
let rand_percent max =
  let x = Random.int (max*2+1) in
  (float_of_int (x-max))/.100.
let max x y =
  if x>y then x else y
let rec remove x lst =
  match lst with
  |[]->[]
  |h::t->if (x=h) then t else h::remove x t
let attack (attacker:unit_parameters) (defender:unit_parameters)=
  let att_type = attacker.typ in
  let def_type = defender.typ in
  let att_max = (base_access attacker).max_hp in
  let def_dmg = (battle_generic att_type def_type) +. rand_percent 5 in
  let att_hlt = float_of_int(attacker.curr_hp)/.float_of_int (att_max) in
  let hlt_left = 1. -. (att_hlt *. def_dmg) in
  let new_hlt = float_of_int(defender.curr_hp)*.hlt_left in
  defender.curr_hp <- max (int_of_float new_hlt) 0
let attack_sim (attacker:unit_parameters) (defender:unit_parameters)=
  let att_type = attacker.typ in
  let def_type = defender.typ in
  let att_max = (base_access attacker).max_hp in
  let def_dmg = (battle_generic att_type def_type) in
  let att_hlt = float_of_int(attacker.curr_hp)/.float_of_int (att_max) in
  let hlt_left = 1. -. (att_hlt *. def_dmg) in
  let new_hlt = float_of_int(defender.curr_hp)*.hlt_left in
  max (int_of_float new_hlt) 0
let sim_battle (attacker:unit_parameters)(defender:unit_parameters):(int*int) =
  let def_hlt = attack_sim attacker defender in
  if def_hlt= 0
  then
    (attacker.curr_hp,0)
  else
    let d1 = {typ = defender.typ;plyr = defender.plyr;unit_id = defender.unit_id;
    active = defender.active;curr_hp = def_hlt;
    curr_mvt =  defender.curr_mvt; position = defender.position} in
    (*let () = d1.curr_hp <- def_hlt in*)
    let att_hlt = attack_sim d1 attacker in
    (att_hlt,def_hlt)





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