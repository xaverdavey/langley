open Hashtbl
open Printf
exception Error of string

type scope = {
  curr: (string, int) Hashtbl.t;
  mutable next: scope option;
}

type names = {
  mutable root: scope option;
}

let create_names : names = {
  root: scope option = None;
}

let set_root ( ns : names) (sc : scope) : unit = 
  ns.root <- Some sc

let create_scope ( ns : names ) : unit = 
  let new_scope = {
    next: scope option = ns.root;
    curr = (Hashtbl.create 0);
  } in
  ns.root <- Some new_scope

let pop_scope ( ns : names ) : unit = 
  ns.root <- (match ns.root with
  | Some(sc) -> sc.next
  | None -> raise (Error "cannot pop scope!")
  )

let set_scope ( ns : names ) ( sc : scope ) : unit =
  ns.root <- Some sc

let rec find_global_scope ( sc : scope ) : scope =
  match sc.next with
  | Some(sc2) -> find_global_scope sc2
  | None -> sc
  


let rec scope_find_opt sc x : int option =
  match Hashtbl.find_opt sc.curr x with
  | Some(value) -> Some(value)
  | None -> (match sc.next with
    | Some(sc2) -> scope_find_opt sc2 x
    | None -> None
  )

let rec scope_find sc x : int =
  match scope_find_opt sc x with
  | Some(value) -> value
  | None -> raise (Error (sprintf "variable '%s' is not defined!" x))

let rec scope_replace sc x value : unit =
  match Hashtbl.find_opt sc.curr x with
  | Some(prev_value) -> Hashtbl.replace (sc.curr) x value
  | None -> (match sc.next with
    | Some(sc2) -> scope_replace sc2 x value
    | None -> raise (Error "cannot replace undefined variable")
  )

let name_find_opt ns x : int option =
  match ns.root with
  | Some(sc) -> scope_find_opt sc x
  | None -> None

let name_find ns x : int =
  match ns.root with
  | Some(sc) -> scope_find sc x
  | None -> raise (Error (sprintf "variable '%s' is not defined!" x))

let name_add ns x value : unit =
  match ns.root with
  | Some(sc) ->
    let var_exists = (match (Hashtbl.find_opt sc.curr x) with
      | Some(tv) -> true
      | None -> false
    ) in
    if var_exists then raise (Error "variable already defined in scope!");
    Hashtbl.add (sc.curr) x value
  | None -> raise (Error "cannot add name without table!")
  
let name_replace ns x value : unit = 
  match ns.root with
  | Some(sc) -> scope_replace sc x value
  | None -> raise (Error "cannot replace name without table!")

