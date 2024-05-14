%{
#include<stdio.h>
#include<stdbool.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin,*yyout;
bool flag = false;
extern char *yytext;
FILE *yparse;
int yylex();
void yyerror(char *s) ;
int yywrap();
int yyparse();
extern int line;
int main(int argc, char** argv){

    if(argc!=2){
        printf("please provide arguments correctly");
    }
    else{
        yyin = fopen(argv[1], "r");
		yparse = fopen("Parser.txt","w");
		yyout = fopen("Lexer.txt","w");
		line = 1;
        yyparse();
        if(flag){
          printf("Syntax Error Detected\n");
        }
        else{
          printf("No Syntax Error Detected\n");
        }
    }
}


void yyerror(char* s)
{
	fprintf(yparse,"\n\nERROR! Line : %d : %s",line,s);
  	flag = 1;
}


%}

%token INT STR_TYPE 
%token IF ELSE WHILE RETURN
%token IDENTIFIER NUMBER STRING
%token COMMA DINCOMM AND OR PLUS MINUS ASSIGN LST GRT MULT DIV SEMICOL GREQ LSEQ EQ NOTEQ
%token LPAREN RPAREN LCBRACE RCBRACE LSQBRACKET RSQBRACKET 

 
 
%%

bnf_start_here : stmts 
stmts :	stmt  stmts
	|  stmt  
	;
stmt :	exp SEMICOL		{fprintf(yparse,"exp : \n");}
	| var_dec SEMICOL	{fprintf(yparse,"Variable_declaration : \n\n");}
	| fun
	| control_stmt
	;
	
control_stmt :  ifStmt		{fprintf(yparse,"if_statement  \n");}
	| whileStmt		{fprintf(yparse,"while_statement \n");}
	;
	
whileStmt :	WHILE LPAREN exp RPAREN stmt				{fprintf(yparse,"while_statement\n");} 
		| WHILE LPAREN exp RPAREN LCBRACE funBody RCBRACE	{fprintf(yparse,"while_statement\n");} 
		;
		
ifStmt :	IF LPAREN exp RPAREN stmt			{fprintf(yparse,"if_statement\n");} 
		| IF LPAREN exp RPAREN LCBRACE funBody RCBRACE	{fprintf(yparse,"if_statement\n");} 
		| IF LPAREN exp RPAREN LCBRACE funBody RCBRACE ELSE LCBRACE funBody RCBRACE	{fprintf(yparse,"if_else_statement\n");} 
		| IF LPAREN exp RPAREN LCBRACE funBody RCBRACE ELSE stmt	{fprintf(yparse,"if_else_statement\n");} 
		;

fun :  fun_dec SEMICOL		{fprintf(yparse,"func_declaration : \n\n");}
	| functionDef 		{fprintf(yparse,"func_definition : \n\n");}
	| functionCall SEMICOL	{fprintf(yparse,"func_call : \n\n");}
	;
	
funBody : 	stmts_funcs | RETURN exp SEMICOL
		;

stmts_funcs :	stmts_func  stmts_funcs
	|  stmts_func  
	;
stmts_func :	exp SEMICOL		{fprintf(yparse,"exp : \n");}
	| var_dec SEMICOL	{fprintf(yparse,"Variable_declaration : \n\n");}
	| fun
	| control_stmt_funcs
	;
	
control_stmt_funcs :  ifStmt_func		{fprintf(yparse,"if_statement  \n");}
	| whileStmt_func	{fprintf(yparse,"while_statement \n");}
	;
	
whileStmt_func :	WHILE LPAREN exp RPAREN stmt				{fprintf(yparse,"while_statement\n");} 
		| WHILE LPAREN exp RPAREN LCBRACE funBody RCBRACE	{fprintf(yparse,"while_statement\n");} 
		;
		
ifStmt_func :	IF LPAREN exp RPAREN stmt			{fprintf(yparse,"if_statement\n");} 
		| IF LPAREN exp RPAREN LCBRACE funBody RCBRACE	{fprintf(yparse,"if_statement\n");} 
		| IF LPAREN exp RPAREN LCBRACE funBody RCBRACE ELSE LCBRACE funBody RCBRACE	{fprintf(yparse,"if_else_statement\n");} 
		| IF LPAREN exp RPAREN LCBRACE funBody RCBRACE ELSE stmt	{fprintf(yparse,"if_else_statement\n");} 
		;


exp : 	bool_exp
	| assignment			{fprintf(yparse,"assign_expr \n");}
	| equation			{fprintf(yparse,"simple_expression \n");}
	;
	

bool_exp : equation inBracket_Exp equation 		{	fprintf(yparse,"bool_expr \n");}
	;
inBracket_Exp : NOTEQ | EQ | LSEQ | LST | GREQ | GRT
		;
dataType :	INT		{fprintf(yparse,"var_type :int \n");}
		;

data :	NUMBER {fprintf(yparse, "const_number : \n");}
	| IDENTIFIER				{fprintf(yparse,"Variable : ");}
	| IDENTIFIER LSQBRACKET exp RSQBRACKET	{fprintf(yparse,"Variable : \n");}
	;
		
assignment :	IDENTIFIER ASSIGN equation	{fprintf(yparse,"Variable : \n");}
				| IDENTIFIER ASSIGN assignment {fprintf(yparse,"Variable : \n");}
		;
		
equation : equation PLUS term			{fprintf(yparse,"Operator : + \n");}
	| equation MINUS term		{fprintf(yparse,"Operator :  - \n");}
	| term						
	| MINUS term 
	;
	
term : 	term MULT factor		{fprintf(yparse,"Operator :  * \n");}
	| term DIV factor		{fprintf(yparse,"Operator :  / \n");}
	| factor
	;
	
factor :	LPAREN equation RPAREN
		| data
		;

id_list :	IDENTIFIER 			{fprintf(yparse,"Variable : \n");}
		| IDENTIFIER COMMA id_list
		;
		
ass_list :	assignment 
		| assignment COMMA assignment
		;	

		
var_dec :	dataType id_list
		| dataType ass_list
		| STR_TYPE IDENTIFIER ASSIGN STRING				{fprintf(yparse,"STRING : ");}
		| STR_TYPE IDENTIFIER 	
		;
		
fun_dec :	dataType IDENTIFIER LPAREN argList RPAREN		{fprintf(yparse,"Func_definition\n");} 
		| dataType IDENTIFIER LPAREN RPAREN 			{fprintf(yparse,"Func_definition\n");} 
		;
		
exp_list : 	exp
		| exp COMMA exp_list
		;
		
functionCall : 	IDENTIFIER LPAREN exp_list RPAREN 	{fprintf(yparse,"Func_call\n");} 
		| IDENTIFIER LPAREN RPAREN		{fprintf(yparse,"Func_call\n");} 
		|
		;
		
argList :	dataType IDENTIFIER
		| dataType IDENTIFIER COMMA argList
		;
		
functionDef  : 	dataType IDENTIFIER LPAREN argList RPAREN LCBRACE funBody RETURN exp SEMICOL RCBRACE		{fprintf(yparse,"func_end\n");} 
		| dataType IDENTIFIER LPAREN RPAREN LCBRACE funBody RETURN exp SEMICOL RCBRACE			{fprintf(yparse,"func_end\n");} 
		;
		
%%



