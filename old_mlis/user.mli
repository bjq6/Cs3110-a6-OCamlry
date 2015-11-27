open View

type dirr =
  |North
  |South
  |East
  |West

type command =
  |Move of int * dirr             (* Unit moves one space in given direction if possible *)
  |Attack of unit_id * unit_id    (* First Unit ID tries to attack second Unit ID if possible *)
  |Buy of unit_type * building_id (* Buy a unit of type unit_type at a given building *)
  |EndTurn                        (* Turns over control to the other player *)
  |Surrender                      (* Ends the game, you lose *)
  |Invalid                        (* If the player inputs an invalid command *)

val parse_command : string -> command

