open Types
open Util
open Battle

val sim_all : unit_parameters -> unit_parameters list -> (int*int) list

val priority_kill : (int*int) list -> float list

val kill_mine : unit_parameters -> unit_parameters -> bool

val kill_theirs : unit_parameters -> unit_parameters -> bool

val favorable_trade : unit_parameters -> unit_parameters -> bool

val top_kill : unit_parameters -> unit_parameters list -> gamestate -> (loc*loc) option

val inf_turn : unit_parameters -> unit_parameters list -> gamestate -> cmd list

val start_ai : gamestate -> cmd list