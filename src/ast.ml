
open Printf

type bop = 
  (* arithmetic *)
  | BopAdd | BopSub | BopMul | BopDiv | BopMod | BopPow
  (* logical *)
  | BopAnd | BopOr | BopXor | BopLBShift | BopRBShift
  (* comparison *)
  | BopEq | BopNotEq | BopLess | BopLessEq | BopGreat | BopGreatEq

type uop =
  | UnopMinus | UnopNeg | UnopNot

type const =
  | CInt of int

type tm =
  | TmVar of string
  | TmConst of const
  | TmRand
  | TmBinOp of bop * tm * tm
  | TmUnOp of uop * tm
  | TmDef of string * tm
  | TmAssign of string * tm
  | TmPrintX of tm
  | TmPrint of tm
  | TmIf of tm * tm * tm option
  | TmWhile of tm * tm
  | TmFunc of string * string list * tm
  | TmRet of tm
  | TmScope of tm list * tm option
  | TmCall of string * tm list

let pprint_bop = function
  | BopAnd -> "&"
  | BopOr -> "|"
  | BopXor -> "^"
  | BopEq -> "=="
  | BopNotEq -> "!="
  | BopLess -> "<"
  | BopLessEq -> "<="
  | BopGreat -> ">"
  | BopGreatEq -> ">="
  | BopLBShift -> "<<"
  | BopRBShift -> "<<"
  | BopAdd -> "+"
  | BopSub -> "-"
  | BopMul -> "*"
  | BopDiv -> "/"
  | BopMod -> "%"
  | BopPow -> "**"

let pprint_uop = function
  | UnopMinus -> "-"
  | UnopNeg -> "~"
  | UnopNot -> "!"

let rec pprint_const = function
  | CInt(i) -> sprintf "CInt(%d)" i

let rec pprint_tm = function 
  | TmVar(x) -> "TmVar(" ^ x ^ ")"
  | TmConst(c) -> "TmConst(" ^ pprint_const c ^ ")"
  | TmBinOp(bop, e1, e2) -> "TmBinOp(" ^ pprint_bop bop ^ ", " ^ pprint_tm e1 ^ ", " ^ pprint_tm e2 ^ ")"
  | TmUnOp(uop, e) -> "TmUnOp(" ^ pprint_uop uop ^ ", " ^ pprint_tm e ^ ")"
  | TmDef(x, e) -> "TmDef(" ^ x ^ ", " ^ pprint_tm e ^ ")"
  | TmAssign(x, e) -> "TmAssign(" ^ x ^ ", " ^ pprint_tm e ^ ")"
  | TmPrintX(e) -> "TmPrintX(" ^ pprint_tm e ^ ")"
  | TmPrint(e) -> "TmPrint(" ^ pprint_tm e ^ ")"
  | TmIf(e, tm1, tm2) -> "TmIf(" ^ pprint_tm e  ^ ", " ^ pprint_tm tm1 ^ 
    (match tm2 with 
      | Some(tm2tm) -> ", " ^ pprint_tm tm2tm
      | None -> ""
    ) ^ ")"
  | TmWhile(e, tm) -> "TmWhile(" ^ pprint_tm e ^ pprint_tm tm ^ ", " ^ ")"
  | TmFunc(x, ps, tm) -> "TmFunc(" ^ x ^ ", " ^ "Params(" ^ (String.concat ", " ps) ^ "), " ^ pprint_tm tm ^ ")"
  | TmRet(e) -> "TmRet(" ^ pprint_tm e ^ ")"
  | TmRand -> "TmRand"
  | TmCall(x, es) ->
    let str_es = List.map pprint_tm es in
    "TmCall(" ^ x ^ ", [" ^ String.concat ", " str_es ^ "])"
  | TmScope(tmlist, tmret) -> 
    let str_tms = List.map pprint_tm tmlist in
    "TmScope([" ^ String.concat ", " str_tms ^ "], " ^
    (match tmret with 
      | Some(tm2) -> pprint_tm tm2
      | None -> ""
    ) ^ ")"
