open Types
open Util
open Battle

val sim_all : unit_parameters -> unit_parameters list -> (int*int) list

val priority_kill : (int*int) list -> float list
