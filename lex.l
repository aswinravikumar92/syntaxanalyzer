alpha [a-zA-Z]
digit [0-9]
us [_]

%%
[ \t]		;
[ \n]   { yylineno = yylineno + 1;}
int	return INT;
float return FLOAT;
char return CHAR;
void return VOID;
double return DOUBLE;
program return PROGRAM;
beginprogram return BE;
endprogram return EN;
and     return AND;
loop    return LOOP;
endloop return ENDLOOP;
then    return THEN;
for 	return FOR;
while	return WHILE;
if	return IF;
of      return OF;
array   return ARRAY;
else	return ELSE;
write  return WRITE;
read   return READ;
struct 	return STRUCT;
^"#include ".+ ;
{digit}+       return NUM;
{alpha}({us})*({alpha}|{digit})* return ID;
"<="    return LE;
">="    return GE;
"=="    return EQ;
"!="    return NE;
">"	return GT;
"<"	return LT;
"."     return DOT;
\/\/.* ;
\/\*(.*\n)*.*\*\/ ;
.       return yytext[0];
%%
