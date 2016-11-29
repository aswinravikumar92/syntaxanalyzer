%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *fp;

%}
 
%token INT FLOAT CHAR DOUBLE VOID
%token FOR WHILE 
%token IF ELSE WRITE  READ
%token STRUCT 
%token NUM ID
%token INCLUDE LOOP ENDLOOP
%token DOT OF ARRAY PROGRAM AND THEN BE EN
%left AND OR
%left '<' '>' LE GE EQ NE LT GT
%%

start:	Prgm|Function 
	| Declaration
	;

/* Declaration block */
Declaration: Assignment ':' Type ';' 
	| Assignment ';'  	
	| FunctionCall ';' 	
	| ArrayUsage ';'	
	|Assignment ':' ARRAY ArrayUsage OF Type ';'   
	| StructStmt ';'	
	| error	
	;

/* Assignment block */
Prgm:PROGRAM ID ';' StmtList
    ;
Bgprgm:BE StmtList EN
;
Assignment: ID '=' Assignment
	| ID '=' FunctionCall
	| ID '=' ArrayUsage
	| ArrayUsage '=' Assignment
        | ArrayUsage '=' ArrayUsage
	| ArrayUsage ','ArrayUsage ',' Assignment
	| ID ',' ArrayUsage
	| ID ',' Assignment
	| NUM ',' Assignment
	| ID '+' Assignment
	| ID '-' Assignment
	| ID '*' Assignment
	| ID '/' Assignment	
	| NUM '+' Assignment
	| NUM '-' Assignment
	| NUM '*' Assignment
	| NUM '/' Assignment
	| '\'' Assignment '\''	
	| '[' Assignment ']'
	| '-' '[' Assignment ']'
	| '-' NUM
	| '-' ID
	|   NUM
	|   ID 
	;

/* Function Call Block */
FunctionCall : ID'['']'
	| ID'['Assignment']'
	;

/* Array Usage */
ArrayUsage : '('Assignment')'
        |ID'('Assignment')' 
	;

/* Function block */
Function: Type ID '[' ArgListOpt ']' CompoundStmt 
        //|
        // PROGRAM Assignment ';'
	;
ArgListOpt: ArgList
	|
	;
ArgList:  ArgList ',' Arg
	| Arg
	;
Arg:	Type ID
	;
CompoundStmt:	'{' StmtList '}'
	;
StmtList:	StmtList Stmt
	|
	;
Stmt:	WhileStmt
	| Declaration
	|Function
	| ForStmt
	| IfStmt
	| PrintFunc
        | ReadFunc
	| Bgprgm
	| ';'
	;

/* Type Identifier block */
Type:	INT 
	| FLOAT
	| CHAR
	| DOUBLE
	| VOID 
	;

/* Loop Blocks */ 
WhileStmt: WHILE '[' Expr ']' Stmt  
	| WHILE '[' Expr ']' CompoundStmt 
        | WHILE '['Expr ']' LOOP CompoundStmt ENDLOOP
	;

/* For Block */
ForStmt: FOR '[' Expr ';' Expr ';' Expr ']' Stmt 
       | FOR '[' Expr ';' Expr ';' Expr ']' CompoundStmt 
       | FOR '[' Expr ']' Stmt 
       | FOR '[' Expr ']' CompoundStmt 
	;

/* IfStmt Block */
IfStmt : IF '[' Expr ']' 
	 	Stmt 
        |IF'[' Expr ']'AND '[' Expr ']'THEN Stmt ELSE Stmt
        |IF '[' Expr ']' AND '[' Expr ']' AND '[' Expr ']' THEN '{' StmtList '}' ELSE '{'StmtList'}'
	;

/* Struct Statement */
StructStmt : STRUCT ID '{' Type Assignment '}'  
	;

/* Print Function */
PrintFunc : WRITE Expr ';'

	;
/*Read Function */
ReadFunc : READ Expr ';'
         ;
/*Expression Block*/
Expr:	
	| Expr LE Expr 
	| Expr GE Expr
	| Expr NE Expr
	| Expr EQ Expr
	| Expr GT Expr
	| Expr LT Expr
	| Assignment
	| ArrayUsage
	;
%%
#include"lex.yy.c"
#include<ctype.h>
int count=0;

int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	
   if(!yyparse())
		printf("\nParsing complete\n");
	else
		printf("\nParsing failed\n");
	
	fclose(yyin);
    return 0;
}
         
yyerror(char *s) {
	printf("%d : %s %s\n", yylineno, s, yytext );
}         

