open Graphics
open Types 

(*let previous_state = ref {map = [|[|Plain |]|]; units = [];
 update = Ivar.create ()}*)
let curr_x = ref 0 
let curr_y = ref 0 
let water_color = Graphics.rgb 0 191 255 
let plain_color = Graphics.rgb 189 183 107 
let player1_color = Graphics.red
let player2_color = Graphics.blue
let neutral_color = Graphics.white
(*The followind two functions below should take in the raw game map 
 * (which at this point is an array of array and then return a new 
 * array matrix, this matrix will be used to draw the map
 *)
let draw_tyle tyle delta_x h w= 
  Graphics.set_color (match tyle with Plain -> plain_color 
    |Water -> water_color
    |Building (None) -> neutral_color
    |Building (Some (Player1 _)) -> player1_color
    |Building (Some (Player2 _)) -> player2_color);
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

let draw_hort_lines delta_x delta_y = 
  Graphics.set_color Graphics.black;
  Graphics.moveto 0 0;
  for i = 0 to 600/delta_x do 
    Graphics.moveto 0 (Graphics.current_y () + delta_y);
    Graphics.lineto 600 (Graphics.current_y ());
  done

let draw_vert_lines delta_x delta_y = 
  Graphics.set_color Graphics.black;
  Graphics.moveto 0 0;
  for i = 0 to 600/delta_y do
    Graphics.moveto (Graphics.current_x () + delta_x) 0;
    Graphics.lineto (Graphics.current_x ()) 600;
  done

let draw_grid delta_x delta_y = 
  draw_vert_lines delta_x delta_y;
  draw_hort_lines delta_x delta_y

(*Function to create the map, this will
 * 1) Create the nXn grid where that is determined by some other modules
 * 2) Using the gamestate, color the grid based on terrain
 *)
let create_map gamestate = 
  Graphics.open_graph " 600x650";
  
  (*Define colors for the water and plain tiles
   *)
  (*First, define what delta_x and delta_y will be*)
  let num_vert_tiles = Array.length gamestate.map in
  let num_hor_tiles = Array.length gamestate.map.(0) in
  let delta_x = 600/num_hor_tiles in 
  let delta_y = 600/num_vert_tiles in
  curr_y := -delta_y;
  draw_map gamestate.map delta_x delta_y;
  draw_grid delta_x delta_y
  (*At this point, we should now have a map that is processed and ready to get
   * filed*)
(*Helper functions to use when drawing units in the map *)
(*Buildings will be represented as triangles*)
let draw_building (x,y) delta_x delta_y = 
  let height = delta_y*8/10 in 
  let width = delta_x*2/10 in
  Graphics.fill_rect (delta_x*x + delta_x*4/10) (delta_y*y + delta_y/10) 
                      width height 
                      
(*infantry is represented by triangle*)
let draw_infantry (x,y) delta_x delta_y = 
  Graphics.fill_poly [|(x*delta_x + delta_x/10, y*delta_y + delta_y/10);
                       ((x+1)*delta_x - delta_x/10, y*delta_y + delta_y/10);
                       (x*delta_x + delta_x/2, (y+1)*delta_y - delta_y/10) |]

(*tank is represented by a circle*)
let draw_tank (x,y) delta_x delta_y = 
  Graphics.fill_circle (delta_x*x + delta_x/2) 
                        (delta_y*y + delta_y/2) (delta_x/2)

(*ocamlry is represetned by square*)
let draw_ocamlry (x,y) delta_x delta_y = 
  Graphics.fill_rect (delta_x*x + 6) (delta_y*y + 6) 
                      (delta_x*8/10) (delta_y*8/10)

let draw_unit unit_to_draw delta_x delta_y = 
  Graphics.set_color (match unit_to_draw.plyr with Player1 _ -> player1_color
                                                   |Player2 _ -> player2_color);
  match unit_to_draw.typ with
  |Infantry -> draw_infantry unit_to_draw.position delta_x delta_y
  |Ocamlry  -> draw_ocamlry unit_to_draw.position delta_x delta_y
  |Tank     -> draw_tank unit_to_draw.position delta_x delta_y 

let populate_map gamestate = 
  let delta_x = 600/(Array.length gamestate.map) in 
  let delta_y = 600/(Array.length gamestate.map.(0)) in
  List.iter (fun elt -> draw_unit elt delta_x delta_y) gamestate.unit_list 

let depopulate_map gamestate = create_map gamestate

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
