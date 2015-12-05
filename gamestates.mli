open Util
open Types

(** Takes in an int representing a map (first thing asked for in REPL) and
 * sets ups a game *)
val configure : int -> bytes -> bytes -> gamestate