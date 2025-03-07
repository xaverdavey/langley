{
    open Parser
    open String
    exception Error of char 
}

let letter = ['A'-'Z'] | ['a'-'z']
let digit = ['0'-'9']
let non_digit = '_' | letter
let ident = non_digit (non_digit | digit)*

let single_line_comment = "//" [^ '\n']* 
let multi_line_comment = "/*" ([^ '*'] | '*' [^ '/'])* "*/"

rule token = parse
    [ ' ' '\t' ] | single_line_comment { token lexbuf; }
    | multi_line_comment as comment { Util.multi_line_new_line comment lexbuf; token lexbuf; }
    | [ '\n' ] { Lexing.new_line lexbuf; token lexbuf }
    | ident as str 
        { match str with
            | "let" -> LET
            | "if" -> IF
            | "else" -> ELSE
            | "while" -> WHILE
            | "func" -> FUNC
            | "return" -> RETURN
            | "printx" -> PRINTX
            | "print" -> PRINT
            | "rand" -> RAND
            | s -> IDENT(s)
        }
    | digit+ as lxm { INT (int_of_string lxm) }
    | ['='] { EQ }
    | ['&'] { AMPERSAND }
    | ['|'] { VBAR }
    | ['^'] { CARET }
    | "==" { EQUAL }
    | "!=" { NOTEQUAL }
    | ['<'] { LESS }
    | "<=" { LESSEQUAL }
    | ['>'] { GREAT }
    | ">=" { GREATEQUAL }
    | "<<" { LSHIFT }
    | ">>" { RSHIFT }
    | ['+'] { PLUS }
    | ['-'] { MINUS }
    | ['*'] { ASTERISK }
    | ['/'] { SLASH }
    | ['%'] { PERCENT }
    | "**" { POW }
    | ['!'] { EXCLAMATION }
    | ['('] { LPAREN }
    | [')'] { RPAREN }
    | ['{'] { LCURLY }
    | ['}'] { RCURLY }
    | [';'] { SEMICOLON }
    | [','] { COMMA }
    | eof { EOF }
    | _ as c { raise (Error c) }
