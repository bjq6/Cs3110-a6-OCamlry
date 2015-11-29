open Graphics
open Database 

let previous_state = ref gamestate  
let curr_x = ref 0  
let water_color = Graphics.rgb 0 191 255 
let plain_color = Graphics.rgb 189 183 107 


let rec process_tyles map : tyle_type array array = failwith "unimplemented"

(*The followind two functions below should take in the raw game map 
 * (which at this point is an array of array and then return a new 
 * array matrix, this matrix will be used to draw the map
 *)
let draw_tyle tyle = 
  Graphics.set_color= match e with Plain -> plain_color |Water -> water_color;
  Graphics.draw_rect 

let get_array_map_to_draw tyle_array delta_x = 
  Array.map ( fun e -> 
    curr_x := !curr_x + delta_x;
    { x = !curr_x; y= !curr_y; height = h; witdth = w;
    tyle_color = match e with Plain -> plain_color | Water -> water_color})  tyle_array

let get_matrix_map_to_draw tyle_matrix delta_x delta_y 
                          : tyle_type array array = 
  Array.map tyle_matrix (fun arr_lst -> 
    curr_x := -delta_x;
    curr_y := !curr_y + delta_y;
    get_array_map_to_draw arr_lst delta_x)


(*This function will take the processed map and then use it to draw everything
 *)
let draw_map processed_map = failwith "unimplemented"

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
  let num_hor_tile = Array.lenght gamestate.map.(0) in
  let delta_x = 600/num_hor_tile in 
  let delta_y = 600/num_vert_tile in

  let processed_map = get_matrix_map_to_draw gamestate.map delta_x delta_y in
  (*At this point, we should now have a map that is processed and ready to get
   * filed*)
  draw_map processed_map

let populate_map gamestate = failwith "unimplemented"

let depopulate_map gamestate = failwith "unimplemented"

let update_status_bar gamestate = failwith "unimplemented"

let observe_gamestate gamestate = 
  upon gamestate.updated (fun updated_state ->
    depopulate_map previous_state;
    populate_map updated_state;
    update_status_bar;
    previous_state := update_state)
 
let init gamestate =  
  create_map gamestate; 
  populate_map gamestate
