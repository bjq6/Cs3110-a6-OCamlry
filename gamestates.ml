open Util
open Types

let p1_building = create_building (Player1 "") 1 1
let p2_building = create_building (Player2 "") 8 8

let p1_inf = create_unit (Player1 "") 0 0 (Infantry)
let p1_tank = create_unit (Player1 "") 1 0 (Tank)
let p1_caml = create_unit (Player1 "") 1 1 (Ocamlry)

let p2_inf = create_unit (Player2 "") 9 9 (Infantry)
let p2_tank = create_unit (Player2 "") 9 8 (Tank)
let p2_caml = create_unit (Player2 "") 9 7 (Ocamlry)

let p1 = {
      player_name = (Player1 "");
      money= 1000;
      score = 0
      }

let p2 = {
      player_name = (Player2 "");
      money= 1000;
      score = 0
      }

let state1 = {
  map = [|[|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Building (Some (Player1 "")); Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Building (Some (Player2 "")); Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|]
          |];
  curr_player = p1;
  player_state = [p1; p2];
  unit_list = [p1_inf; p1_tank; p1_caml; p2_inf; p2_tank; p2_caml];
  building_list = [p1_building; p2_building];
}