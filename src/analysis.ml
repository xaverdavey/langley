
open Store
open Hashtbl
open Printf
open Ast
exception Error of string

(*
  stores for variables and functions
*)
let name_store = create_names
let func_store = (Hashtbl.create 0)

(*
  helper function for calculating integer exponentiation
*)
let rec pow x y = if y == 0 then 1 else x * pow x (y - 1)

let rec execute_const = function
  | CInt(i) -> i

let rec execute_tm = function 
  | TmVar(x) -> name_find name_store x
  | TmConst(c) -> execute_const c
  | TmRand -> Random.self_init(); Int64.to_int (Random.int64 (Int64.max_int))
  | TmBinOp(bop, e1, e2) -> (
    match bop with
      | BopAnd -> (execute_tm e1) land (execute_tm e2)
      | BopOr -> (execute_tm e1) lor (execute_tm e2)
      | BopXor -> (execute_tm e1) lxor (execute_tm e2)
      | BopEq -> if (execute_tm e1) == (execute_tm e2) then 1 else 0
      | BopNotEq -> if (execute_tm e1) != (execute_tm e2) then 1 else 0
      | BopLess -> if (execute_tm e1) < (execute_tm e2) then 1 else 0
      | BopLessEq -> if (execute_tm e1) <= (execute_tm e2) then 1 else 0
      | BopGreat -> if (execute_tm e1) > (execute_tm e2) then 1 else 0
      | BopGreatEq -> if (execute_tm e1) >= (execute_tm e2) then 1 else 0
      | BopLBShift -> (execute_tm e1) lsl (execute_tm e2)
      | BopRBShift -> (execute_tm e1) lsr (execute_tm e2)
      | BopAdd -> (execute_tm e1) + (execute_tm e2)
      | BopSub -> (execute_tm e1) - (execute_tm e2)
      | BopMul -> (execute_tm e1) * (execute_tm e2)
      | BopDiv -> (execute_tm e1) / (execute_tm e2)
      | BopMod -> (execute_tm e1) mod (execute_tm e2)
      | BopPow -> pow (execute_tm e1) (execute_tm e2)
      )
  | TmUnOp(uop, e) -> (
    match uop with
      | UnopMinus -> (-(execute_tm e) )
      | UnopNeg -> (~-(execute_tm e) )
      | UnopNot -> if (execute_tm e) == 0 then 1 else 0 
  )
  | TmDef(x, e) ->
    let e_val = (execute_tm e) in
    name_add name_store x e_val;
    e_val
  | TmAssign(x, e) ->
    let e_val = (execute_tm e) in
    name_replace name_store x e_val;
    e_val
  | TmPrintX(e) -> 
      printf "%016x\n" (execute_tm e);
      0
  | TmPrint(e) -> 
    printf "%d\n" (execute_tm e);
    0
  | TmIf(e, tm1, tm2) ->
    let _ = if (execute_tm e) != 0 then (execute_tm tm1) else (match tm2 with
      | Some(tm2tm) -> (execute_tm tm2tm)
      | None -> 0
    ) in
    0
  | TmWhile(e, tm) ->
    while (execute_tm e) != 0 do (ignore (execute_tm tm)) done;
    0
  | TmFunc(x, ps, tm) ->
    let func_exists = (match Hashtbl.find_opt func_store x with
    | Some(fn) -> true
    | None -> false) in
    if func_exists then raise (Error (sprintf "function '%s' already defined!" x));
    Hashtbl.add func_store x (ps, tm);
    0
  | TmRet(e) -> (execute_tm e)
  | TmCall(x, elist) ->
    let (ps, tm) = Hashtbl.find func_store x in
    let arg_vals = List.map (fun e -> execute_tm e) elist in
    let args = List.combine ps arg_vals in
    let scope_env = name_store.root in
    set_scope name_store (find_global_scope (match scope_env with
      | Some(se) -> se
      | None -> raise (Error "unexpected error in call!")
    ));
    create_scope name_store;
    List.iter (fun (p, av) -> name_add name_store p av ) args;
    let e_val = execute_tm tm in
    pop_scope name_store;
    set_scope name_store (match scope_env with
      | Some(se) -> se
      | None -> raise (Error "unexpected error in call!")
    );
    e_val
  | TmScope(tmlist, tmret) -> 
    create_scope name_store;
    let _ = List.map execute_tm tmlist in
    let ret_val = (match tmret with
    | Some(tm2) -> execute_tm tm2
    | None -> 0) in
    pop_scope name_store;
    ret_val
