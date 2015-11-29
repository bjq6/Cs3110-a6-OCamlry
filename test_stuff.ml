type tile = Plain | Water 
type gamestate = {
  map : tile array array;
  update : gamestate Ivar.t 
}
let test_init_state = {
  map = [| [|Plain; Plain; Water|] ; [| Plain; Plain; Plain|] ;
            [| Plain; Plain; Plain |] |];
  update = Ivar.create ()
}

