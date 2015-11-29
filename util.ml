open Types

let print_map (g:gamestate) = failwith "unimplemented"

(*---------Commands from process command--------*)

(** Given a unit *)
let process_movement ((x1,y1),(x2,y2)) = failwith "unimplemented"

(** Given first a unit and then the unit it is attacking, it returns the
  gamestate with the proper damage and deaths made*)
let process_attack ((x1,y1),(x2,y2)) = failwith "unimplemented"

(** Purchases a unit of type unit_type for the current player and places it at
  loc provided that there is a building there that doesn't already have a unit
  on it and the current player has the proper resources to purchase the unit*)
let process_buy ((x1,y1),u) = failwith "unimplemented"

(** Ends the turn, reactivates units, updates monies and turns over control*)
let process_end_turn () = failwith "unimplemented"

(** Ends the game *)
let process_surrender () = failwith "unimplemented"

(** Sends the game in a full loop and makes the player try re-entering the
  * command *)
let process_invalid () = failwith "unimplemented"

(*---------------------------------------------*)