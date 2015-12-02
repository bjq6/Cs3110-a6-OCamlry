open Graphics
open Types
(*Define the colors and variables that will be used in the game.  These
 * include tyle colors, active/inactive unit colors, and neutral colors
 *)
let curr_x = ref 0
let curr_y = ref 0
let water_color = Graphics.cyan
let plain_color = Graphics.rgb 153 255 153
let player1_color = Graphics.red
let player1_inactive_color = Graphics.rgb 201 136 136
let player2_color = Graphics.yellow
let player2_inactive_color = Graphics.rgb 212 197 66
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
  draw_grid delta_x delta_y;
  for i=0 to num_vert_tiles - 1 do 
    for j=0 to num_hor_tiles - 1 do
      Graphics.moveto (j*delta_x + delta_x*7/10) (i*delta_y);
      Graphics.draw_string ((string_of_int j) ^","^ (string_of_int i)) ;
    done
  done

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
                        (delta_y*y + delta_y/2) (delta_x*4/10)

(*ocamlry is represetned by square*)
let draw_ocamlry (x,y) delta_x delta_y =
  Graphics.fill_rect (delta_x*x + 6) (delta_y*y + 6)
                      (delta_x*8/10) (delta_y*8/10)

(*infantry is represented by triangle*)
let draw_infantry_outline (x,y) delta_x delta_y =
  Graphics.draw_poly [|(x*delta_x + delta_x/10, y*delta_y + delta_y/10);
                       ((x+1)*delta_x - delta_x/10, y*delta_y + delta_y/10);
                       (x*delta_x + delta_x/2, (y+1)*delta_y - delta_y/10) |]

(*tank is represented by a circle*)
let draw_tank_outline (x,y) delta_x delta_y =
  Graphics.draw_circle (delta_x*x + delta_x/2)
                        (delta_y*y + delta_y/2) (delta_x*4/10)

(*ocamlry is represetned by square*)
let draw_ocamlry_outline (x,y) delta_x delta_y =
  Graphics.draw_rect (delta_x*x + 6) (delta_y*y + 6)
                      (delta_x*8/10) (delta_y*8/10)
(*Function that will return a color based on (1) the player who owns
 * the color and (2) whether the unit is active or not
 *)
let get_color unit_to_draw =
  match (unit_to_draw.plyr, unit_to_draw.active) with
  |(Player1 _, true) -> player1_color
  |(Player1 _, false) -> player1_inactive_color
  |(Player2 _, true) -> player2_color
  |(Player2 _, false) -> player2_inactive_color


let draw_unit_status (x,y) hp delta_x delta_y =
  Graphics.moveto (x*delta_x + delta_x*3/10) (y*delta_y + delta_y*3/10);
  Graphics.draw_string (string_of_int hp)

let draw_unit unit_to_draw delta_x delta_y =
  Graphics.set_color (get_color unit_to_draw);
  (match unit_to_draw.typ with
  |Infantry -> draw_infantry unit_to_draw.position delta_x delta_y
  |Ocamlry  -> draw_ocamlry unit_to_draw.position delta_x delta_y
  |Tank     -> draw_tank unit_to_draw.position delta_x delta_y );
  Graphics.set_color (Graphics.black);
  (match unit_to_draw.typ with
  |Infantry -> draw_infantry_outline unit_to_draw.position delta_x delta_y
  |Ocamlry  -> draw_ocamlry_outline unit_to_draw.position delta_x delta_y
  |Tank     -> draw_tank_outline unit_to_draw.position delta_x delta_y );
  draw_unit_status unit_to_draw.position (unit_to_draw.curr_hp) delta_x delta_y


let populate_map gamestate =
  let delta_x = 600/(Array.length gamestate.map) in
  let delta_y = 600/(Array.length gamestate.map.(0)) in
  List.iter (fun elt -> draw_unit elt delta_x delta_y) gamestate.unit_list

let depopulate_map gamestate = create_map gamestate

let update_status_bar gamestate =
  let player_name = (match gamestate.curr_player.player_name with
    |Player1 s -> s | Player2 s -> s) in
  let money = gamestate.curr_player.money in
  let score = gamestate.curr_player.score in
  Graphics.moveto 20 630;
  Graphics.draw_string ("Current Player: " ^ player_name);
  Graphics.moveto 20 620;
  Graphics.draw_string ("Money: " ^ (string_of_int money));
  Graphics.moveto 20 610;
  Graphics.draw_string ("Score: " ^ (string_of_int score))

(*let observe_gamestate gamestate =
  upon gamestate.update (fun updated_state ->
    depopulate_map previous_state;
    populate_map updated_state;
    update_status_bar;
    previous_state := update_state)
*)
let update_state new_gamestate =
  depopulate_map new_gamestate;
  populate_map new_gamestate;
  update_status_bar new_gamestate


let init gamestate =
  create_map gamestate;
  populate_map gamestate;
  update_status_bar gamestate

