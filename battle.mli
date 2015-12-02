open Types
open Random

val battle : unit_parameters-> unit_parameters->
              unit_parameters list-> (int* unit_parameters list)
val sim_battle : unit_parameters-> unit_parameters -> (int*int)
val capture : player_id -> building_parameters ->
              building_parameters list -> (building_parameters list)