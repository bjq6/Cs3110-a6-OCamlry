(*Define states to test the view module*)

let create_dummy_unit owner x y typ =
  {typ = typ; plyr = owner; unit_id= 0; active = true; curr_hp = 250;
  curr_mvt = 0; position = (x,y);}

let test_init_state3 = {
  map = [|[|Building (Some (Player2 "")); Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Building (Some (Player1 "")); Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Building (Some (Player2 "")); Plain; Plain|]
          |];
  curr_player = {player_name = Player1 ""; money= 0; score = 0};
  player_state = [];
  unit_list =
    [create_dummy_unit (Player1 "") 0 0 (Infantry);
     create_dummy_unit (Player1 "") 1 0 (Tank);
     create_dummy_unit (Player1 "") 1 1 (Ocamlry);
     create_dummy_unit (Player2 "") 9 9 (Infantry);
     create_dummy_unit (Player2 "") 9 8 (Tank);
     create_dummy_unit (Player2 "") 9 7 (Ocamlry)];
  building_list = [];
}

let test_init_state4= {
  map = [|[|Building (Some (Player2 "")); Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Building (Some (Player1 "")); Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Building (Some (Player2 "")); Plain; Plain|]
          |];
  curr_player = {player_name = Player1 ""; money= 0; score = 0 };
  player_state = [];
  unit_list =
    [create_dummy_unit (Player1 "") 0 1 (Infantry);
     create_dummy_unit (Player1 "") 1 0 (Tank);
     create_dummy_unit (Player1 "") 1 1 (Ocamlry);
     create_dummy_unit (Player2 "") 9 9 (Infantry);
     create_dummy_unit (Player2 "") 9 8 (Tank);
     create_dummy_unit (Player2 "") 9 7 (Ocamlry)];
  building_list = [];
}


