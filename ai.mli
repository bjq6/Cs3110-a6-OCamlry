open Types
open Util
open Battle

val sim_all : unit_parameters -> unit_parameters list -> (int*int) list

val priority_kill : (int*int) list -> float list

val kill_mine : unit_parameters -> unit_parameters -> bool

val kill_theirs : unit_parameters -> unit_parameters -> bool

(*Given one of your units and an enemy unit, it returns a bool:
True if he will lose more damage than you
False if you will lose more damage than it*)

(*                        my unit           their_unit              *)
val favorable_trade : unit_parameters -> unit_parameters -> bool

(*Given your unit and a list of enemy units, it returns a location option
Some loc - if there is a unit in range that is worth attacking
None - if there are no units in range worth attacking*)

(*                 my unit          enemy unit list           g                       *)
val top_kill : unit_parameters -> unit_parameters list -> gamestate -> (loc*loc) option

(*                 my unit          enemy unit list           g                       *)
val inf_turn : unit_parameters -> unit_parameters list -> gamestate -> cmd list

val start_ai : gamestate -> cmd list