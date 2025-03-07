
open Printf
open Ast
open Analysis

let main =
  let lexbuf = Lexing.from_channel stdin in
  let res =
    try
      Parser.main Lexer.token lexbuf
    with 
      | Lexer.Error(c) ->
        fprintf stderr "Lexical error at line %d: Unknown character '%c'\n" 
          lexbuf.lex_curr_p.pos_lnum c;
        exit 1
      | Parser.Error ->
        fprintf stderr "Parser error at line %d\n"
          lexbuf.lex_curr_p.pos_lnum;
        exit 1
  in
  (*
  printf "Result: %s\n" (pprint_tm res);
  *)
  execute_tm res;