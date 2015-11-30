open Getcmd
open Types
let unit2str un =
  match un with
  |Infantry -> "Infantry"
  | Ocamlry -> "Ocamlry"
  | Tank    -> "Tank"
match getcmd("1") with
|Invalid s ->Printf.printf "Wrong: %s\n" s
|Surrender ->Printf.printf "You have Surrendered\n"
|Move ((x,y),(a,b))->Printf.printf "Move from (%d,%d) to (%d,%d)\n" x y a b
|Attack ((x,y),(a,b))->Printf.printf "Attack from (%d,%d) to (%d,%d)\n" x y a b
|EndTurn -> Printf.printf "You have Ended Your turn\n"
|Capture (x,y)-> Printf.printf "Capture (%d,%d)\n" x y
|Buy (x,(a,b)) -> Printf.printf "Buy %s at (%d,%d)\n" (unit2str x) a b