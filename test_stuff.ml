type tile = Plain | Water 
type unit_type = Infantry | Ocamlry | Tank
type player = Player1 of string | Player2 of string

type unit_parameters = {
  typ : unit_type;
  owner : player;
  mutable position : int*int
}

type gamestate = {
  map : tile array array;
  units : unit_parameters list;
  update : gamestate Ivar.t 
}

(*
let test_init_state1 = {
  map = [| [|Plain; Plain; Plain; Water|] ; [| Plain; Plain; Plain; Plain|] ;
            [| Plain; Plain; Plain; Plain |]; [|Plain; Water; Water; Water|] |];
  update = Ivar.create ()
}

let test_init_state2 = {
  map = [|  [| Plain; Plain; Plain: Water |] ; 
            [| Plain; Water; Plain; Plain |] ;
            [| Plain; Water; Plain; Plain |] ;
            [| Plain; Water; Water: Plain |] |];
  update = Ivar.create ()
}
*)

let test_init_state3 = {
  map = [|[|Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|]; 
          [|Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|]; 
          [|Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|]; 
          [|Plain; Plain; Plain; Water; Plain; Plain; Plain; Plain; Plain; Plain|]; 
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|]; 
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|]; 
          [|Plain; Plain; Plain; Plain; Plain; Water; Water; Plain; Plain; Plain|]; 
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|];
          [|Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain; Plain|]
  |];
  units = [{typ = Infantry; owner = Player1 ""; position = (0,0)}; 
          {typ = Ocamlry; owner = Player1 ""; position = (1,0)};
          {typ = Tank; owner = Player2 ""; position =  (9,9)}; 
          {typ = Ocamlry; owner = Player2 ""; position = (9,8)}
  ];
  update = Ivar.create ()
}
