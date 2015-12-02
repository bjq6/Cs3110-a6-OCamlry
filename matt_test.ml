open Getcmd
open Types
open View
open Controller
open Util


let _ = Plain in

match getcmd("1") with
|Invalid s ->Printf.printf "Wrong: %s\n" s
|Surrender ->Printf.printf "You have Surrendered\n"
|Move ((x,y),(a,b))->Printf.printf "Move from (%d,%d) to (%d,%d)\n" x y a b
|Attack ((x,y),(a,b))->Printf.printf "Attack from (%d,%d) to (%d,%d)\n" x y a b
|EndTurn -> Printf.printf "You have Ended Your turn\n"
|Capture (x,y)-> Printf.printf "Capture (%d,%d)\n" x y
|Buy (x,(a,b)) -> Printf.printf "Buy %s at (%d,%d)\n" (unit2str x) a b

let create_dummy_unit owner x y typ =
  {typ = typ; plyr = owner; unit_id= 0; active = true; curr_hp = 250;
  curr_mvt = 100; position = (x,y);}

let test_init_state3 = {
  map = [|[|Building (Some (Player2 "Yellow")); Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Building (Some (Player1 "Matt")); Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Building (Some (Player2 "Yellow")); Plain; Plain|]
          |];
  curr_player = {player_name = Player1 "Matt"; money= 0; score = 0};
  player_state = [];
  unit_list =
    [create_dummy_unit (Player1 "Matt") 0 0 (Infantry);
     create_dummy_unit (Player1 "Matt") 1 0 (Tank);
     create_dummy_unit (Player1 "Matt") 1 1 (Ocamlry);
     create_dummy_unit (Player2 "Yellow") 9 9 (Infantry);
     create_dummy_unit (Player2 "Yellow") 9 8 (Tank);
     create_dummy_unit (Player2 "Yellow") 9 7 (Ocamlry)];
  building_list = [];
}
let () = init (test_init_state3) in
main (test_init_state3)
