let previous_state = ref gamestate in 
let curr_x = ref 0 in 
let water_color = Graphics.rgb 0 191 255 in 
let plain_color = Graphics.rgb 189 183 107 in 
 
let init gamestate =  
  Graphics.open_graph " 600x600";
  create_map gamestate; 
  populate_map gamestate

let rec observe_gamestate gamestate = 
  upon gamestate.updated (fun updated_state ->
    depopulate_map previous_state;
    populate_map updated_state;
    update_status_bar;
    previous_state := update_state)
    
  
let update_grapic gamestate = failwith "unimplemented"



let rec process_tyles map : tyle_type array array = failwith "unimplemented"

let draw_tyle tyle = failwith "unimplemented"

(*The followind two functions below should take in the raw game map 
 * (which at this point is an array of array and then return a new 
 * array matrix, this matrix will be used to draw the map
 *)
let get_array_map_to_draw tyle_array delta_x : tyle_type array = 
  Arrays.Map tyle_array (fun e -> 
    curr_x := !curr_x + delta_x;
    { x = !curr_x; y= !curr_y; height = h; witdth = w;
    tyle_color = match e with Plain -> plain_color | Water -> water_color})

let get_matrix_map_to_draw tyle_matrix delta_x delta_y 
                          : tyle_type array array = 
  Arrays.Map tyle_matrix (fun arr_lst -> 
    curr_y := !curr_y + delta_y;
    get_array_map_to_draw arr_lst delta_x)

(*Function to create the map, this will
 * 1) Create the nXn grid where that is determined by some other modules
 * 2) Using the gamestate, color the grid based on terrain
 *)
let create_map gamestate = 
  (*Define colors for the water and plain tiles
   *)
  (*First, define what delta_x and delta_y will be*)
  gamestate.map
  (*Process tyles*)
  Array.iter draw_tyle tyles;


let populate_map gamestate = failwith "unimplemented"

let depopulate_map gamestate = failwith "unimplemented"

let update_status_bar gamestate = failwith "unimplemented"
