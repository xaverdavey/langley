%{
    open Ast
%}

%token <int> INT
%token EQ "="
%token AMPERSAND "&"
%token VBAR "|"
%token CARET "^"
%token EQUAL "=="
%token NOTEQUAL "!="
%token LESS "<"
%token LESSEQUAL "<="
%token GREAT ">"
%token GREATEQUAL ">="
%token LSHIFT "<<"
%token RSHIFT ">>"
%token PLUS "+"
%token MINUS "-"
%token ASTERISK "*"
%token SLASH "/"
%token PERCENT "%"
%token POW "**"
%token EXCLAMATION "!"
%token LPAREN "("
%token RPAREN ")"
%token LCURLY "{"
%token RCURLY "}"
%token SEMICOLON ";"
%token COMMA ","
%token LET
%token IF
%token ELSE
%token WHILE
%token FUNC
%token RETURN
%token PRINTX
%token PRINT
%token RAND
%token <string> IDENT
%token EOF

%left "&" "|" "^"
%left "==" "!=" "<" "<=" ">" ">="
%left "<<" ">>"
%left "+" "-"
%left "*" "/" "%"
%right "**"
%nonassoc UMINUS
%nonassoc EXCLAMATION

%start main
%type <tm> main

%%

main:
    | gsq=gseq EOF { TmScope(gsq, None) }

gseq:
    | gst=gstmt SEMICOLON gsq=gseq { gst::gsq }
    | { [] }

gstmt:
    | FUNC x=IDENT LPAREN ps=params RPAREN LCURLY sq=seq RETURN e=expr SEMICOLON RCURLY { TmFunc(x, ps, TmScope(sq, Some (TmRet(e)))) }
    | st=stmt { st }

seq:
    | st=stmt SEMICOLON sq=seq { st::sq }
    | { [] }

stmt:
    | LET id = IDENT EQ e = expr { TmDef(id, e) }
    | id = IDENT EQ e = expr { TmAssign(id, e) }
    | PRINTX e = expr { TmPrintX(e) }
    | PRINT e = expr { TmPrint(e) }
    | IF e = expr LCURLY sq = seq RCURLY { TmIf(e, TmScope(sq, None), None) }
    | IF e = expr LCURLY sq1 = seq RCURLY ELSE LCURLY sq2 = seq RCURLY { TmIf(e, TmScope(sq1, None), Some(TmScope(sq2, None))) }
    | WHILE e = expr LCURLY sq = seq RCURLY { TmWhile(e, TmScope(sq, None)) }

expr:
    | a=atom { a }
    | e1 = expr AMPERSAND e2 = expr { TmBinOp(BopAnd, e1, e2) }
    | e1 = expr VBAR e2 = expr { TmBinOp(BopOr, e1, e2) }
    | e1 = expr CARET e2 = expr { TmBinOp(BopXor, e1, e2) }
    | e1 = expr EQUAL e2 = expr { TmBinOp(BopEq, e1, e2) }
    | e1 = expr NOTEQUAL e2 = expr { TmBinOp(BopNotEq, e1, e2) }
    | e1 = expr LESS e2 = expr { TmBinOp(BopLess, e1, e2) }
    | e1 = expr LESSEQUAL e2 = expr { TmBinOp(BopLessEq, e1, e2) }
    | e1 = expr GREAT e2 = expr { TmBinOp(BopGreat, e1, e2) }
    | e1 = expr GREATEQUAL e2 = expr { TmBinOp(BopGreatEq, e1, e2) }
    | e1 = expr LSHIFT e2 = expr { TmBinOp(BopLBShift, e1, e2) }
    | e1 = expr RSHIFT e2 = expr { TmBinOp(BopRBShift, e1, e2) }
    | e1 = expr PLUS e2 = expr { TmBinOp(BopAdd, e1, e2) }
    | e1 = expr MINUS e2 = expr { TmBinOp(BopSub, e1, e2) }
    | e1 = expr ASTERISK e2 = expr { TmBinOp(BopMul, e1, e2) }
    | e1 = expr SLASH e2 = expr { TmBinOp(BopDiv, e1, e2) }
    | e1 = expr PERCENT e2 = expr { TmBinOp(BopMod, e1, e2) }
    | e1 = expr POW e2 = expr { TmBinOp(BopPow, e1, e2) }
    | x=IDENT LPAREN a=args RPAREN { TmCall(x, a) }
    | "-" e = expr %prec UMINUS { TmUnOp(UnopMinus, e) }
    | "!" e= expr %prec EXCLAMATION { TmUnOp(UnopNot, e) }
    | x=IDENT { TmVar(x) }
    | LPAREN e = expr RPAREN { e }

atom:
    | i=INT { TmConst(CInt(i)) }
    | RAND { TmRand }

params:
    | x=IDENT COMMA ps=params { x::ps }
    | x=IDENT { [x] }
    | { [] }

args:
    | e=expr COMMA a=args { e::a }
    | e=expr { [e] }
    | { [] }
