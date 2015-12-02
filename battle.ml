open Types
open Random
open Util
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
  |h::t->if (x=h) then t else remove x t
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
  defender.curr_hp <- max (int_of_float new_hlt) 0

let capture (player:player_id)(building:building_parameters)
              (bldlst:building_parameters list) =
  let lst = remove building bldlst in
  let () = (match building.curr_hp with
           |1->let () = building.curr_hp<-2 in
                      building.owner<-player
           |_->building.curr_hp<-1 )in
  building::lst
let sim_battle (attacker:unit_parameters)(defender:unit_parameters):(int*int) =
  let () = attack_sim attacker defender in
  if defender.curr_hp = 0
  then
    (attacker.curr_hp,0)
  else
    let () = attack_sim defender attacker in
    (attacker.curr_hp,defender.curr_hp)
let battle (attacker:unit_parameters)(defender:unit_parameters)
              (unit_list:unit_parameters list):(int*unit_parameters list) =
  let lst = remove attacker (remove defender unit_list) in
  let () = attack attacker defender in
  if defender.curr_hp = 0
  then
    let dscore = match defender.typ with Infantry -> 1|Ocamlry -> 2|Tank -> 3 in
    let () = attacker.active<-false in
    (dscore,attacker::lst)
  else
    let () = attack defender attacker in
    if attacker.curr_hp = 0
    then
      let ascore = match attacker.typ with|Infantry -> -1|Ocamlry -> -2|Tank -> -3 in
      (ascore,defender::lst)
    else
      let () = attacker.active<-false in
      (0,attacker::defender::lst)

