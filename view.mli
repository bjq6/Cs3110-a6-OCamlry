open Types
open Graphics

(*This will have the value of the old gamestate saved on to it
 *)
(*val log : gamestate ref*)
 (*Function that will observe the gamestate and once it is updated will update
  * the graphics*)
(*val observe_gamestate : gamestate -> unit*)
val init : gamestate -> unit

val update_state : gamestate -> unit

val create_map : gamestate -> unit

val populate_map : gamestate -> unit
(*Upon taking the gamestate, function will depopulate the map*)
val depopulate_map : gamestate -> unit

(*Updates the status of the bar
 * TODO may need to create a creator function*)
val update_status_bar : gamestate -> unit
