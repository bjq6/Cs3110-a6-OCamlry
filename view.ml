open Graphics
open Async

let previous_state = ref {map = [|[|Plain |]|]; update = Ivar.create ()}
let curr_x = ref 0 
let curr_y = ref 0 
let water_color = Graphics.rgb 0 191 255 
let plain_color = Graphics.rgb 189 183 107 


let rec process_tyles map = failwith "unimplemented"

(*The followind two functions below should take in the raw game map 
 * (which at this point is an array of array and then return a new 
 * array matrix, this matrix will be used to draw the map
 *)
let draw_tyle tyle delta_x h w= 
  Graphics.set_color (match tyle with Plain -> plain_color |Water -> water_color);
  Graphics.fill_rect !curr_x !curr_y h w 

let draw_array tyle_array delta_x h w = 
  Array.iter ( fun e -> 
    curr_x := !curr_x + delta_x;
    draw_tyle e delta_x h w)  tyle_array

let draw_map tyle_matrix delta_x delta_y  = 
  Array.iter (fun arr_lst -> 
    curr_x := -delta_x;
    curr_y := !curr_y + delta_y;
    draw_array arr_lst delta_x delta_y delta_x) tyle_matrix


(*Function to create the map, this will
 * 1) Create the nXn grid where that is determined by some other modules
 * 2) Using the gamestate, color the grid based on terrain
 *)
let create_map gamestate = 
  Graphics.open_graph " 600x600";
  
  (*Define colors for the water and plain tiles
   *)
  (*First, define what delta_x and delta_y will be*)
  let num_vert_tiles = Array.length gamestate.map in
  let num_hor_tiles = Array.length gamestate.map.(0) in
  let delta_x = 600/num_hor_tiles in 
  let delta_y = 600/num_vert_tiles in

  draw_map gamestate.map delta_x delta_y
  (*At this point, we should now have a map that is processed and ready to get
   * filed*)

let populate_map gamestate = failwith "unimplemented"

let depopulate_map gamestate = failwith "unimplemented"

let update_status_bar gamestate = failwith "unimplemented"

(*let observe_gamestate gamestate = 
  upon gamestate.update (fun updated_state ->
    depopulate_map previous_state;
    populate_map updated_state;
    update_status_bar;
    previous_state := update_state)
*) 
let init gamestate =  
  create_map gamestate; 
  populate_map gamestate
