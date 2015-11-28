let previous_state = ref gamestate

let init gamestate =  
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

(*Function to create the map, this will
 * 1) Create the nXn grid where that is determined by some other modules
 * 2) Using the gamestate, color the grid based on terrain
 *)
let create_map gamestate = 
  (*Define colors for the water and plain tiles
   *)
  let water_color = Graphics.rgb 0 191 255 in 
  let plain_color = Graphics.rgb 189 183 107 in 
  (*Process tyles*)
  Array.iter draw_tyle tyles;


let populate_map gamestate = failwith "unimplemented"

let depopulate_map gamestate = failwith "unimplemented"

let update_status_bar gamestate = failwith "unimplemented"
