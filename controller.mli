(*process command will recieve raw [command] from the user, make sense of it 
 * and call the proces process function
 *)
val process_command : string -> gamestate

val process_attack : gameunit * gameunit -> gamestate

val process_movement : gameunit -> gamestate

val process_buy : gameunit -> gamestate

val process_conque : gamebuilding -> gamestate


