open Util
open Types

(** Takes in an int representing a map (first thing asked for in REPL) and
 * sets ups a game *)
let configure (i:int) (name1:bytes) (name2:bytes) : gamestate=

let p1_name = (Player1 name1) in
let p2_name = (Player2 name2) in

let p1_building = create_building p1_name 1 1 in
let p2_building = create_building p2_name 8 8 in
let p2_building2 = create_building p2_name 7 8 in

let p1_inf = create_unit p1_name 0 0 (Infantry) in
let p1_tank = create_unit p1_name 1 0 (Tank) in
let p1_caml = create_unit p1_name 1 1 (Ocamlry) in

let p2_inf = create_unit p2_name 9 9 (Infantry) in
let p2_tank = create_unit p2_name 9 8 (Tank) in
let p2_caml = create_unit p2_name 9 7 (Ocamlry) in

let p1 = {
      player_name = p1_name;
      money= 1000;
      score = 0
      } in

let p2 = {
      player_name = p2_name;
      money= 1000;
      score = 0
      } in

let state1 = {
  map = [|[|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Building (Some p1_name); Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Building (Some p2_name); Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|]
          |];
  curr_player = p1;
  player_state = [p1; p2];
  unit_list = [p1_inf; p1_tank; p1_caml; p2_inf; p2_tank; p2_caml];
  building_list = [p1_building; p2_building];
  game_over = false;
  turn = 0;
} in

let s2_p1_caml = create_unit p1_name 1 1 (Ocamlry) in
let s2_p2_inf = create_unit p2_name 2 1 (Infantry) in

let state2 = {
  map = [|[|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Building (Some p1_name); Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Building (Some p2_name); Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|]
          |];
  curr_player = p1;
  player_state = [p1; p2];
  unit_list = [s2_p1_caml;s2_p2_inf];
  building_list = [p1_building; p2_building];
  game_over = false;
  turn = 0;
} in

let s3_p1_caml = create_unit p1_name 1 1 (Ocamlry) in
let s3_p2_tank = create_unit p2_name 2 1 (Tank) in

let state3 = {
  map = [|[|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Building (Some p1_name); Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Building (Some p2_name); Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|]
          |];
  curr_player = p1;
  player_state = [p1; p2];
  unit_list = [s3_p1_caml;s3_p2_tank];
  building_list = [p1_building; p2_building];
  game_over = false;
  turn = 0;
} in
let state4 = {
  map = [|[|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Building (Some p1_name); Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Water; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Building (Some p2_name); Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|]
          |];
  curr_player = p1;
  player_state = [p1; p2];
  unit_list = [p1_inf; p1_tank; p1_caml; p2_inf; p2_tank; p2_caml];
  building_list = [p1_building; p2_building];
  game_over = false;
  turn = 0;
} in
let state5 = {
  map = [|[|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Building (Some p1_name); Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Water; Plain; Plain; Plain; Plain; Water; Plain; Plain|];
          [|Water; Water; Water; Plain; Plain; Plain; Plain; Water; Water; Water|];
          [|Plain; Plain; Water; Plain; Plain; Plain; Plain; Water; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Building (Some p2_name); Building (Some p2_name); Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|]
          |];
  curr_player = p1;
  player_state = [p1; p2];
  unit_list = [p1_inf; p1_tank; p1_caml; p2_inf; p2_tank; p2_caml];
  building_list = [p1_building; p2_building; p2_building2 ];
  game_over = false;
  turn = 0;
} in

  print_bytes("Loading map ");print_int(i);print_endline("");
  match i with
  | 1 -> state1
  | 2 -> state2
  | 3 -> state3
  | 4 -> state4
  | 5 -> state5
  | _->failwith "Please Enter a number between 1 and 5"
