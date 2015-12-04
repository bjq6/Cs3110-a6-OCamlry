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

(** generate an unused type variable *)
let next_var1  = ref 0
let newvar () =
    next_var1 := 1 + !next_var1;
    !next_var1

let create_unit owner x y typ = {
  typ = typ; plyr = owner; unit_id= newvar (); active = true;
  curr_hp = (base_access_unit_type typ).max_hp;
  curr_mvt = (base_access_unit_type typ).max_mvt;
  position = (x,y);
  }

let create_building owner x y = {
  max_hp = 2;
  owner = owner;
  curr_hp = 2;
  position = (x,y);
  }

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

(*find units owned by current player*)
let rec get_units (lst : unit_parameters list) (p : player_id)
   (out : unit_parameters list) =
  match lst with
  | [] -> out
  | h::t -> if h.plyr = p
    then get_units t p (h::out) else get_units t p out

(*given a player's units, sort them into lists by unit type. For AI.
 * Initialize with empty list tuple ([],[],[])*)
let rec sort_units (lst : unit_parameters list) (i,o,tnk) =
  match lst with
  | [] -> (i,o,tnk)
  | h::t ->
    match h.typ with
    | Infantry -> sort_units t (h::i, o, tnk)
    | Ocamlry -> sort_units t (i, h::o, tnk)
    | Tank -> sort_units t (i, o, h::tnk)

(*make sure user input is not off the map *)
let map_check ((a,b) : int*int) (m : terrain array array) =
  let y = (Array.length m) in
  let x = (Array.length (Array.get m 0)) in
  (a >= 0) && (a < x) && (b >= 0) && (b < y)

(*AI: check for nearby enemies given a list of enemies (lst)*)
let rec enemy_check (a : unit_parameters) (lst : unit_parameters list)
  (targets : unit_parameters list) : unit_parameters list =

  match lst with
  | [] -> targets
  | h::t ->
    let (x1,y1) = a.position in
    let (x2,y2) = h.position in
    if ((abs x1-x2) + (abs y1-y2)) <= a.curr_mvt + 1
    then enemy_check a t (h::targets)
    else enemy_check a t targets

(* AI: check for nearby unoccupied neutral or enemy buildings given gamestate
 * building lst*)
let rec building_check (a : unit_parameters) (lst : building_parameters list)
  (targets : building_parameters list) (g_list : unit_parameters list) =

  match lst with
  | [] -> targets
  | h::t ->
    let (x1,y1) = a.position in
    let (x2,y2) = h.position in
    if (((abs x1-x2) + (abs y1-y2)) <= a.curr_mvt) && (h.owner <> a.plyr)
      && (unit_at_loc g_list (x2,y2) = None)
    then building_check a t (h::targets) g_list
    else building_check a t targets g_list

(*return loc that would move unit next to enemy unit, also checks for water*)
let next_to (a : unit_parameters) (enemy : unit_parameters) (g : gamestate) =
    let (x1,y1) = a.position in
    let (x2,y2) = enemy.position in
    if (((abs x1-x2) + (abs y1-y2)) > a.curr_mvt+1)
    then None
    else if (((abs x1-(x2+1)) + (abs y1-y2)) <= a.curr_mvt) &&
      (g.map.(x2+1).(y2) <> Water) && (map_check (x2+1,y2) g.map) &&
      (unit_at_loc g.unit_list (x2+1,y2) = None)
      then Some (x2+1,y2)
    else if (((abs x1-(x2-1)) + (abs y1-y2)) <= a.curr_mvt) &&
      (g.map.(x2-1).(y2) <> Water) && (map_check (x2-1,y2) g.map) &&
      (unit_at_loc g.unit_list (x2-1,y2) = None)
      then Some (x2-1,y2)
    else if (((abs x1-x2) + (abs y1-(y2+1)) <= a.curr_mvt) &&
      (g.map.(x2).(y2+1) <> Water) && (map_check (x2,y2+1) g.map) &&
      (unit_at_loc g.unit_list (x2,y2+1) = None))
      then Some (x2,y2+1)
    else if (((abs x1-x2) + (abs y1-(y2-1)) <= a.curr_mvt) &&
      (g.map.(x2).(y2-1) <> Water) && (map_check (x2,y2-1) g.map) &&
      (unit_at_loc g.unit_list (x2,y2-1) = None))
      then Some (x2,y2-1)
    else None

(*generates random spot on map to move to bc why not*)
let move_rand (m : terrain array array) =
  let y = (Array.length m) in
  let x = (Array.length (Array.get m 0)) in
  (Random.int x, Random.int y)



(* AI: if attacking/moving to target in range not viable, provide location for
 * infantry to move to nearest capturable building and tank/ocamlry to move to
 * nearest enemy. lst is already a pre-filtered list of enemies*)
let move_towards_enemy_unit (u : unit_parameters) (lst : unit_parameters list)
  (b_lst : building_parameters list) (m : terrain array array) : loc =
  match u.typ with
  | Infantry ->
    let targets = List.filter (fun x -> (x.owner <> u.plyr)) b_lst in
    begin
    match targets with
    | [] -> move_rand m
    | h::t ->
    let (x1,y1) = u.position in
    let distance a b =
      let (x2,y2) = a.position in
      let (x3,y3) = b.position in
      if (abs(x1-x2) + abs(y1-y2)) < (abs(x1-x3) + abs(y1-y3))
      then a else b in
    let go = List.fold_left distance h targets in
    go.position;
    end

  | _ ->
    begin
    match lst with
    | [] -> move_rand m
    | hd::tl ->
    let (x1,y1) = u.position in
    let distance' (a : unit_parameters) (b : unit_parameters) : unit_parameters =
      let (x2,y2) = a.position in
      let (x3,y3) = b.position in
      if ((abs(x1-x2) + abs(y1-y2)) < (abs(x1-x3) + abs(y1-y3)))
      then a else b
    in
    let g = List.fold_left distance' hd lst in
    g.position;
    end

(* return list of current player's buildings that are unoccupied.
 * initialize b as empty list *)
let rec my_buildings (g : gamestate) (lst : building_parameters list)
  (b : building_parameters list) =
  match lst with
  | [] -> b
  | h::t ->
    if (h.owner = g.curr_player.player_name)
      && (unit_at_loc g.unit_list h.position <> None)
    then my_buildings g t (h::b) else my_buildings g t b

(* helper function for buy_ai. a = infantry, b = ocamlry, c = tank *)
(* (a,b,c) ints representing list lengths*)
let rec purchase ((a':int),(b':int),(c':int)) (money : int)
  (b_lst : building_parameters list) (cd : cmd list)=
  let mini = List.sort compare [a';b';c'] in
  let i = base_access_unit_type Infantry in
  let o = base_access_unit_type Ocamlry in
  let tnk = base_access_unit_type Tank in
  match b_lst with
  | [] -> cd
  | h::t ->
  if (List.nth mini 0 = a') && (money >= i.unit_cost) then
    purchase (a'+1,b',c') (money - i.unit_cost) t
    ((Buy (Infantry,h.position))::cd)
  else if (List.nth mini 0 = b') && (money >= o.unit_cost) then
    purchase (a',b'+1,c') (money - o.unit_cost) t
    ((Buy (Ocamlry,h.position))::cd)
  else if (List.nth mini 0 = c') && (money >= tnk.unit_cost) then
    purchase (a',b',c'+1) (money - tnk.unit_cost) t
    ((Buy (Tank,h.position))::cd)
  else if (List.nth mini 1 = a') && (money >= i.unit_cost) then
    purchase (a'+1,b',c') (money - i.unit_cost) t
    ((Buy (Infantry,h.position))::cd)
  else if (List.nth mini 1 = b') && (money >= o.unit_cost) then
    purchase (a',b'+1,c') (money - o.unit_cost) t
    ((Buy (Ocamlry,h.position))::cd)
  else if (List.nth mini 1 = c') && (money >= tnk.unit_cost) then
    purchase (a',b',c'+1) (money - tnk.unit_cost) t
    ((Buy (Tank,h.position))::cd)
  else if (List.nth mini 2 = a') && (money >= i.unit_cost) then
    purchase (a'+1,b',c') (money - i.unit_cost) t
    ((Buy (Infantry,h.position))::cd)
  else if (List.nth mini 2 = b') && (money >= o.unit_cost) then
    purchase (a',b'+1,c') (money - o.unit_cost) t
    ((Buy (Ocamlry,h.position))::cd)
  else if (List.nth mini 2 = c') && (money >= tnk.unit_cost) then
    purchase (a',b',c'+1) (money - tnk.unit_cost) t
    ((Buy (Tank,h.position))::cd)
  else cd

(* Buy for AI. Check for own buildings not occupied by a unit, and buying
 * whatever unit type it has the least of. Return cmd list *)
let buy_ai (g : gamestate) =
  let b_lst = my_buildings g g.building_list [] in
  let my_units = get_units g.unit_list g.curr_player.player_name [] in
  let (a,b,c) = sort_units my_units ([],[],[]) in
  let a' = List.length a in
  let b' = List.length b in
  let c' = List.length c in
  purchase (a',b',c') g.curr_player.money b_lst []

(* AI: returns unit_parameters that are active and have moves *)
let rec out_of_moves (lst : unit_parameters list) (x : unit_parameters list) =
  match lst with
  | [] -> x
  | h::t ->
    if (h.active)&&(h.curr_mvt > 0)
    then out_of_moves t (h::x)
    else out_of_moves t x

let rec get_map_num () : int =
  let _ = print_endline("Which map would you like to play?") in
  let _ = print_endline("1 - Plains\n2 - Test") in
  let str = read_line () in
  let words = String.trim(str) in
  match words with
  | "1" -> 1
  | "2" -> 2
  | _ ->
    let _ = print_endline("That is not a valid map. Please choose a number") in
    get_map_num ()

let rec get_player_name (i:int) (other_name) : bytes =
  let _ = print_bytes("What is the name of player ");print_int(i);
          print_endline("?") in
  let str = read_line () in
  let possible_name = String.trim(str) in
  match possible_name,other_name with
  | name1,Some name2 ->
      if (name1 = name2) then
      let _ = print_endline("The player's names can not be the same. Try again") in
      get_player_name i other_name
      else name1
  | name1, None -> name1






