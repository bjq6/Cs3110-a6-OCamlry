open String
open Types

(*The User will be forced into input commands in the way that we want
 *These are how the commands will be structured
 *Move (x,y) to (a,b)
 *Attack (x,y) from (a,b)
 *Buy unit_x at (a,b)
 *)
(*type unit = int*)



let rec splitWords str1 =
      let str = String.trim(str1)^" " in
      match str with
      |" "->[]
      |_->let index = String.index str ' ' in
          let length = String.length str in
          let delta = if (length-index-1)<0 then 0 else (length-index-1) in
          let fst = String.sub str 0 index in
          let snd = String.sub str (index+1) delta in
          fst::(splitWords snd)


let string2pair str =
  let f = (fun x->if (x = ',') then ' ' else x) in
  let s = String.map f str in
  let s1 = if s.[0]='(' then String.sub s 1 ((String.length s)-1) else s in
  let s2 = if s1.[((String.length s1)-1)]=')'
      then String.sub s1 0 ((String.length s1)-1) else s1 in
  let l1 = splitWords s2 in
  if List.length l1 <> 2 then None else
  try
   let l2 = List.map int_of_string l1 in
   Some(List.hd l2,List.nth l2 1)
  with Failure "int_of_string"->None

let unit2str un =
  match un with
  |Infantry -> "Infantry"
  | Ocamlry -> "Ocamlry"
  | Tank    -> "Tank"

let string2unit str =
  match String.lowercase(str) with
  |"tank"->Some Tank
  |"t"->Some Tank
  |"ocamlry"->Some Ocamlry
  |"o"->Some Ocamlry
  |"infantry"->Some Infantry
  |"i"->Some Infantry
  |_->None


let getcmd (player:bytes) =
  Printf.printf "Player %s's turn to move\n" player;
  let str = read_line () in
  let words = splitWords(str) in
  if words = [] then (Invalid "No Command") else
    match String.lowercase(List.hd words) with
    |"move" ->
          let snd = List.tl words in
          if List.length snd = 2 then
            let l1 = List.map string2pair snd in
            match l1 with
              |Some x::Some y::[]-> Move (x,y)
              |_->Invalid "Error Parsing Move Command"
          else
            Invalid "Invalid Move Command"
    |"attack" ->
          let snd = List.tl words in
          if List.length snd = 2 then
            let l1 = List.map string2pair snd in
            match l1 with
              |Some x::Some y::[]-> Attack (x,y)
              |_->Invalid "Error Parsing Attack Command"
          else
            Invalid "Invalid Attack Command"
    |"buy" ->
          let snd = List.tl words in
          if List.length snd = 2
          then
          let one = string2unit (List.hd snd) in
          let two = string2pair (List.nth snd 1) in
          match (one,two) with
            |(Some x,Some y)-> Buy (x,y)
            |_->Invalid "Error Parsing Buy Command"
          else
          Invalid "Invalid Buy Command"
    |"capture"->
          let snd = List.tl words in
          if List.length snd = 1
          then
            match string2pair (List.hd snd) with
            |Some x -> Capture x
            |_-> Invalid "Error Parsing Capture Command"
          else
            Invalid "Invalid Capture Command"
    |"surrender"->Surrender
    |"quit"->Surrender
    |"end" ->EndTurn
    |_-> Invalid "Unknown Command"



