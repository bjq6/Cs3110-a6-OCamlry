open Types
open Random

val battle : unit_parameters-> unit_parameters->
              unit_parameters list-> unit_parameters list
val capture : player_id -> building_parameters ->
              building_parameters list -> building_parameters list