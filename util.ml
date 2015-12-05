open Types
open Str

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
    then (building_check a t (h::targets) g_list)
    else (building_check a t targets g_list)

(*return loc that would move unit next to enemy unit, also checks for water*)
let next_to (a : unit_parameters) (enemy : unit_parameters) (g : gamestate) =
    let (x1,y1) = a.position in
    let (x2,y2) = enemy.position in
    (*If enemy is too far away*)
    if (((abs (x1-x2)) + (abs (y1-y2))) > a.curr_mvt+1) then None
    (*If you are already next to the enemy*)
    else if ((abs (x1-x2)) + (abs (y1-y2))) = 1 then Some (x1,y1)
    (*Check 4 spaces around enemy unit
    - Valid place on map
    - Not water
    - Enough curr_mvt to get there
    - Not unit already there            *)
    (*Right*)
    else if (map_check (x2+1,y2) g.map) &&
      ((abs (x1-(x2+1))) + (abs (y1-y2)) <= a.curr_mvt) &&
      (g.map.(x2+1).(y2) <> Water) &&
      (unit_at_loc g.unit_list (x2+1,y2) = None)
      then Some (x2+1,y2)
    (*Left*)
    else if (map_check (x2-1,y2) g.map) &&
      (((abs (x1-(x2-1))) + (abs (y1-y2))) <= a.curr_mvt) &&
      (g.map.(x2-1).(y2) <> Water) &&
      (unit_at_loc g.unit_list (x2-1,y2) = None)
      then Some (x2-1,y2)
    (*Above*)
    else if (map_check (x2,y2+1) g.map) &&
      ((abs (x1-x2)) + (abs (y1-(y2+1))) <= a.curr_mvt) &&
      (g.map.(x2).(y2+1) <> Water) &&
      (unit_at_loc g.unit_list (x2,y2+1) = None)
      then Some (x2,y2+1)
    (*Below*)
    else if (map_check (x2,y2-1) g.map) &&
      ((abs (x1-x2)) + (abs (y1-(y2-1))) <= a.curr_mvt) &&
      (g.map.(x2).(y2-1) <> Water) &&
      (unit_at_loc g.unit_list (x2,y2-1) = None)
      then Some (x2,y2-1)
    else let _ = print_endline("Can't move next_to") in None

(*generates random spot on map to move to bc why not*)
let rec move_rand (m : terrain array array) (lst : unit_parameters list) =
  let y = (Array.length m) in
  let x = (Array.length (Array.get m 0)) in
  let () = Random.self_init () in
  let (x',y') = ((Random.int x), (Random.int y)) in
  match (unit_at_loc lst (x',y'), (m.(x').(y') <> Water)) with
  | (None, true) -> Printf.printf "Random walking to (%d,%d)\n" x' y'; (x',y')
  | (_,_) -> move_rand m lst



(* AI: if attacking/moving to target in range not viable, provide location for
 * infantry to move to nearest capturable building and tank/ocamlry to move to
 * nearest enemy. lst is already a pre-filtered list of enemies. lst' is all
 * units *)
let next_close_enemy_unit (u : unit_parameters) (lst : unit_parameters list)
  (b_lst : building_parameters list) (m : terrain array array)
  (lst' : unit_parameters list) : loc =
  match u.typ with
  | Infantry ->
    let targets = List.filter (fun x -> (x.owner <> u.plyr)) b_lst in
    begin
    match targets with
    | [] -> move_rand m lst'
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

  | Tank | Ocamlry  ->
    begin
    match lst with
    | [] -> move_rand m lst'
    | hd::tl ->
    let (x1,y1) = u.position in
    let distance' (a : unit_parameters) (b : unit_parameters) : unit_parameters=
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
      && (unit_at_loc g.unit_list h.position = None)
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

(* AI: returns unit_parameters that are active and have not moved *)
let rec out_of_moves (lst : unit_parameters list) (x : unit_parameters list) =
  match lst with
  | [] -> x
  | h::t ->
    if (h.active)&&(h.curr_mvt = (base_access h).max_mvt)
    then out_of_moves t (h::x)
    else out_of_moves t x

(* Game Start : Asks the player what map they want to play - returns int*)
let rec get_map_num () : int =
  let _ = print_endline("Which map would you like to play?") in
  let _ = print_endline("1 - Plains\n2 - Pond\n3 - Center Stronghold") in
  let str = read_line () in
  let words = String.trim(str) in
  match words with
  | "1" -> 1
  | "2" -> 2
  | "3" -> 3
  | "t" -> 99
  | "t2" -> 98
  | _ ->
    let _ = print_endline("That is not a valid map. Please choose a number") in
    get_map_num ()

(* Game Start : Asks the user what name this player should be - returns bytes*)
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

(* Game Start: Asks if user wants to play against an AI, returns true if yes*)
let rec play_ai () =
  Printf.printf "Would you like player 2 to be an AI? y/n\n";
  let str = read_line () in
  let str2 = String.trim str in
  match str2 with
  |"y" |"Y" | "yes" | "Yes" -> true
  |"n" |"N" | "no" | "No" -> false
  | _ -> Printf.printf "Invalid command"; play_ai ()


(* Given location, map, unit list, returns bool -> loc is available to move to
 * probably should have made this earlier *)
let go_check (x,y) (m : terrain array array) (lst : unit_parameters list) =
  (m.(x).(y) <> Water) && (unit_at_loc lst (x,y) = None)
    && (map_check (x,y) m)


(*lst is list of potential movement spots; x',y' is target location, lst' = []*)
let rec dist lst lst' (x',y') =
  match lst with
  | [] -> lst'
  | (x,y)::t ->
  let d = (abs (x-x') + abs (y-y')) in
  dist t ((x,y,d)::lst') (x',y')

(*find min dist in list*)
let rec min_dist lst (x', y', d') =
  match lst with
  | [] -> (x',y',d')
  | (x,y,d)::t ->
  if d < d' then min_dist t (x,y,d) else min_dist t (x',y',d')


(* u is unit, (x,y) is target location potentially out of move bounds (values
 * come from next_close_enemy_unit); m is map, lst is g.unit_list. output is loc*)
let move_it (u : unit_parameters) (x,y) (m : terrain array array)
  (lst : unit_parameters list) =
  let (x',y') = u.position in
  if ((abs(x-x') + abs(y-y')) <= u.curr_mvt) && (go_check (x,y) m lst)
  then (Move (u.position,(x,y))) (* move_rand in next_close_enemy_unit checks if this is valid*)
  else let mvt = u.curr_mvt in
  (*make matrix of mvt*mvt box coordinates around u.position*)
    let mat = Array.make_matrix ((2*mvt)+1) ((2*mvt)+1) (x',y') in
    for i = 0 to (2*mvt) do
      for j = 0 to (2*mvt) do
        mat.(i).(j) <- (x'-mvt+i,y'-mvt+j);
      done;
    done;
    (*filter matrix into list of valid spaces to move*)
    let spaces = ref [] in
     for i' = 0 to (2*mvt) do
      for j' = 0 to (2*mvt) do
        let (a,b) = mat.(i').(j') in
        if ((map_check (a,b) m) && ((abs (a-x')) + (abs (b-y'))) <= mvt)
          && (go_check (a,b) m lst) then
        spaces := (a,b)::!spaces;
      done;
    done;

  let dist_list = dist !spaces [] (x,y) in
  match dist_list with
  | [] -> (Move (u.position,(x',y')))
  | h::t ->
  let (a',b',_) = min_dist dist_list h in
  (Move (u.position, (a',b')))








(*Functions to read from simple csv files, helper functions for the Graphics
 * module are defined here
 *)
let comma = Str.regexp ","

let parse_line line = List.map int_of_string (Str.split_delim comma line)

let rec make_triplet l1 l2 l3 = match (l1,l2,l3) with
  |([],[],[]) -> []
  |(h1::t1, h2::t2, h3::t3) -> (h1,h2,h3)::(make_triplet t1 t2 t3)
  | _ -> failwith "should not happen"

let read_image length red_file blue_file green_file =
  let color_map = Array.make length [||] in
  let red_chan = Pervasives.open_in red_file in
  let blue_chan = Pervasives.open_in blue_file in
  let green_chan = Pervasives.open_in green_file in
  let counter = ref 0 in
  try
    while true; do
      let curr_red_line =  parse_line (Pervasives.input_line red_chan) in
      let curr_blue_line = parse_line (Pervasives.input_line blue_chan) in
      let curr_green_line= parse_line (Pervasives.input_line green_chan) in
      let rgb_list = make_triplet curr_red_line curr_blue_line curr_green_line in
      color_map.(!counter) <- Array.of_list (
        List.map (fun (r,g,b) -> Graphics.rgb r g b) rgb_list);
      counter := !counter + 1;
    done; color_map
  with End_of_file ->
    Pervasives.close_in red_chan;
    color_map



