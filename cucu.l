%{
#include <stdio.h>
#include "cucu.tab.h"
extern YYSTYPE yylval;
void yyerror(char *s);
extern FILE *yyout,*yyin;
int line = 1;
int cnt = 0;
%}

digit       [0-9]
letter      [a-zA-Z]
identifier  {letter}({letter}|{digit}|_)*

%%    

\n          {fprintf(yyout,"\n\n"); line+=1;} 

\/\*(.)*\*\/          {fprintf(yyout,"COMMENT : %s\n",yytext); }

int       { fprintf(yyout,"TYPE : int\n"); return INT; }
char[ ]*\*    { fprintf(yyout,"TYPE : char*\n"); return STR_TYPE; }

if        { fprintf(yyout,"IF : if\n"); return IF; }
else     { fprintf(yyout,"ELSE : else\n"); return ELSE; }
return    { fprintf(yyout,"RETURN : return\n"); return RETURN; }
while    { fprintf(yyout,"WHILE : while\n"); return WHILE; }

{identifier} { fprintf(yyout,"ID : %s\n", yytext); return IDENTIFIER; }
{digit}+    { fprintf(yyout,"NUM : %s\n", yytext); return NUMBER; }
\"[^"]*\"       { fprintf(yyout,"STRING : %s\n", yytext); return STRING;}




","         { fprintf(yyout,"COMMA : ,\n"); return COMMA; }
"\""        { fprintf(yyout,"DOUBLE_INVERTED_COMMA : \"\n"); return DINCOMM; }
";"         { fprintf(yyout,"SEMICOLON : ;\n"); return SEMICOL; line+=1; }

"&"         { fprintf(yyout,"AND : &\n"); return AND; }
"|"         { fprintf(yyout,"OR : |\n"); return OR; }
"+"         { fprintf(yyout,"PLUS : +\n"); return PLUS; }
"-"         { fprintf(yyout,"MINUS : -\n"); return MINUS; }
"*"         { fprintf(yyout,"ASTERISK : *\n"); return MULT; }
"/"         { fprintf(yyout,"DIVISION : /\n"); return DIV; }
"="         { fprintf(yyout,"ASSIGNMENT : =\n"); return ASSIGN; }

"<"         { fprintf(yyout,"LESS_THAN : <\n"); return LST; }
">"         { fprintf(yyout,"GREATER_THAN : >\n"); return GRT; }
">="        { fprintf(yyout,"GREATER_THAN_EQUAL_TO : >=\n"); return GREQ; }
"<="        { fprintf(yyout,"LESS_THAN_EQUAL_TO : <=\n"); return LSEQ; }
"=="        { fprintf(yyout,"EQUALS : ==\n"); return EQ; }
"!="        { fprintf(yyout,"NOT_EQUALS : !=\n"); return NOTEQ; }

"("         { fprintf(yyout,"LEFT_PARENTHESIS : (\n"); return LPAREN; }
")"         { fprintf(yyout,"RIGHT_PARENTHESIS : )\n"); return RPAREN; }
"{"         { fprintf(yyout,"LEFT_BRACE : {\n"); return LCBRACE; }
"}"         { fprintf(yyout,"RIGHT_BRACE : }\n"); return RCBRACE;  }
"["         { fprintf(yyout,"LEFT_SQUARE_BRACKET : [\n"); return LSQBRACKET; }
"]"         { fprintf(yyout,"RIGHT_SQUARE_BRACKET : ]\n"); return RSQBRACKET; }



[ \t]+                ;
.          


%%

int yywrap(void) {
    return 1;
}
