open Types

let print_map (g:gamestate) = failwith "unimplemented"

(*given location, returns unit option. used in controller*)
let rec unit_at_loc (lst : unit_parameters list) (x : loc) =
  match lst with
  | [] -> None
  | h::t -> if h.position = x then Some h else unit_at_loc t x

(*given location, returns building option. used in controller*)
let rec b_at_loc (lst : building_parameters list) (x : loc) =
  match lst with
  | [] -> None
  | h::t -> if h.position = x then Some h else b_at_loc t x



(*next player given two players defined *)
let next_player (g: gamestate) =
  match g.curr_player.player_name with
  | Player1 _ -> List.nth g.player_state 1
  | Player2 _ -> List.nth g.player_state 0


(*get base_unit info given unit_parameters*)

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

let base_access_unit_type (x : unit_type) =
  match x with
  | Infantry -> infantry_base
  | Ocamlry -> ocamlry_base
  | Tank -> tank_base


(*refresh all units at the end of each turn*)
let rec refresh (lst : unit_parameters list) =
  match lst with
  | [] -> ()
  | h::t ->
    h.active <- true;
    let base = base_access h in
    h.curr_mvt <- base.max_mvt;
    refresh t


(*find num of buildings owner by current player*)
let rec num_building (lst : building_parameters list) (p : player_id) (i : int) =
  match lst with
  | [] -> i
  | h::t -> if h.owner = p
    then num_building t p (i+1) else num_building t p i


(*---------Commands from process command--------

(** Given a unit *)
let process_movement ((x1,y1),(x2,y2)) = failwith "unimplemented"

(** Given first a unit and then the unit it is attacking, it returns the
  gamestate with the proper damage and deaths made*)
let process_attack ((x1,y1),(x2,y2)) = failwith "unimplemented"

(** Purchases a unit of type unit_type for the current player and places it at
  loc provided that there is a building there that doesn't already have a unit
  on it and the current player has the proper resources to purchase the unit*)
let process_buy ((x1,y1),u) = failwith "unimplemented"

(** Ends the turn, reactivates units, updates monies and turns over control*)
let process_end_turn () = failwith "unimplemented"

(** Ends the game *)
let process_surrender () = failwith "unimplemented"

(** Sends the game in a full loop and makes the player try re-entering the
  * command *)
let process_invalid () = failwith "unimplemented"

---------------------------------------------*)
