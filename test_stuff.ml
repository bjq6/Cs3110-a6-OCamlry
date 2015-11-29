type tile = Plain | Water 
type gamestate = {
  map : tile array array;
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
  update = Ivar.create ()
}
