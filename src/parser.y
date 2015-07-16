%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "tree.h"

int yyparse(void);
int yylex(void);
void yyerror(const char *str);

extern tree parse_head;


%}

%union
{
    int number;
    char *string;
    tree tree;
}

%error-verbose
%locations

%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO
%token DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INT LONG
%token REGISTER RETURN SHORT SIGNED SIZEOF STATIC STRUCT
%token SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE
%token EQUATE NOT_EQUATE LESS_OR_EQUAL GREATER_OR_EQUAL
%token SHIFT_LEFT SHIFT_RIGHT BOOL_OP_AND BOOL_OP_OR

%token <string> IDENTIFIER
%token <string> CONST_BITS
%token <string> CONST_HEX
%token <number> INTEGER;

%type <tree> statements
%type <tree> statement

%%

statements: statement  ';'
{
    parse_head = $1;
}
| statements statement ';'
{
    $1->next = $2;
    $$ = $2;
}

statement: INTEGER
{
    tree number = tree_make(T_INTEGER);
    number->data.integer = $1;
    $$ = number;
}
;