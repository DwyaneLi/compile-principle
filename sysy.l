%option noyywrap
%option yylineno

%{
#include <stdio.h>

enum Token {
    INT=258, FLOAT, VOID, CONST, RETURN, IF, ELSE, FOR, WHILE, DO, BREAK, CONTINUE,
    LP, RP, LB, RB, LC, RC, COMMA, SEMICOLON, QUESTION, COLON,
    MINUS, NOT, TILDE, ASSIGN, ADD, MUL, DIV, MOD, AND, OR,
    EQ, NE, LT, LE, GT, GE,
    ID, INT_LIT, FLOAT_LIT,
    LEX_ERR
};

%}
delim [\r\n ]
ws {delim}+
notes1 [\/][\/].*
notes2 [\/][\*](.|\n)*[\*][\/]
/* ID定义 */
identifier_nondigit [a-zA-Z_]
digit [0-9]
id {identifier_nondigit}({identifier_nondigit}|{digit})*
/* int定义 */
hexadecimal_perfix 0[xX]
nonzero_digit [1-9]
octal_digit [0-7]
hexadecimal_digit [0-9a-fA-F]
decimal_const ({nonzero_digit}{digit}*)|0
octal_const 0{octal_digit}* 
hexadecimal_const {hexadecimal_perfix}{hexadecimal_digit}*
int_suffix ([uU][lL]?)|([uU](ll|LL))|([lL][uU]?)|(ll|LL[uU]?)
int_lit ({decimal_const}|{octal_const}|{hexadecimal_const}){int_suffix}?
/* float定义 */
float_suffix [flFL]
digit_sequence {digit}*
hexadecimal_sequence {hexadecimal_digit}*
sign [\+-]
exponent_part [eE]{sign}?{digit_sequence}
binary_exponent_part [pP]{sign}?{digit_sequence}
fractional_constant ({digit_sequence}?\.{digit_sequence})|({digit_sequence}\.)
hexadecimal_fractional_constant ({hexadecimal_sequence}?\.{hexadecimal_sequence})|({hexadecimal_sequence}\.)
decimal_floating_constant ({fractional_constant}{exponent_part}?{float_suffix}?)|({digit_sequence}{exponent_part}{float_suffix}?)
hexadecimal_floating_constant ({hexadecimal_perfix}{hexadecimal_fractional_constant}{binary_exponent_part}{float_suffix}?)|({hexadecimal_perfix}{hexadecimal_sequence}{binary_exponent_part}{float_suffix}?)
float_lit {decimal_floating_constant}|{hexadecimal_floating_constant}
/*错误定义*/
err_int 0([0-7]*)?[8-9][0-9]*
err_float {int_lit}{float_suffix}
err_id {digit}{id}
%%
"int" {printf("%s : INT\n", yytext); return INT; }
"float" {printf("%s : FLOAT\n", yytext); return FLOAT; }
"void" {printf("%s : VOID\n", yytext); return VOID; }
"const" {printf("%s : CONST\n", yytext); return CONST; }
"return" {printf("%s : RETURN\n", yytext); ; return RETURN; }
"if" {printf("%s : IF\n", yytext); return IF; }
"else" {printf("%s : ELSE\n", yytext); return ELSE; }
"for" {printf("%s : FOR\n", yytext); return FOR; }
"while" {printf("%s : WHILE\n", yytext); return WHILE; }
"do" {printf("%s : DO\n", yytext); return DO; }
"break" {printf("%s : BREAK\n", yytext); return BREAK; }
"continue" {printf("%s : CONTINUE\n", yytext); return CONTINUE; }
"(" {printf("%s : LP\n", yytext); return LP; }
")" {printf("%s : RP\n", yytext); return RP; }
"[" {printf("%s : LB\n", yytext); return LB; }
"]" {printf("%s : RB\n", yytext); return RB; }
"{" {printf("%s : LC\n", yytext); return LC; }
"}" {printf("%s : RC\n", yytext); return RC; }
"," {printf("%s : COMMA\n", yytext); return COMMA; }
";" {printf("%s : SEMICOLON\n", yytext); return SEMICOLON; }
"?" {printf("%s : QUESTION\n", yytext); return QUESTION; }
":" {printf("%s : COLON\n", yytext); return COLON; }
"!" {printf("%s : NOT\n", yytext); return NOT; }
"=" {printf("%s : ASSIGN\n", yytext); return ASSIGN; }
"-" {printf("%s : MINUS\n", yytext); return MINUS; }
"+" {printf("%s : ADD\n", yytext); return ADD; }
"*" {printf("%s : MUL\n", yytext); return MUL; }
"/" {printf("%s : DIV\n", yytext); return DIV; }
"%" {printf("%s : MOD\n", yytext); return MOD; }
"&&" {printf("%s : AND\n", yytext); return AND; }
"||" {printf("%s : OR\n", yytext); return OR; }
"==" {printf("%s : EQ\n", yytext); return EQ; }
"!=" {printf("%s : NE\n", yytext); return NE; }
"<" {printf("%s : LT\n", yytext); return LT; }
"<=" {printf("%s : LE\n", yytext); return LE; }
">" {printf("%s : GT\n", yytext); return GT; }
">=" {printf("%s : GE\n", yytext); return GE; }
{ws} {}
{notes1} {}
{notes2} {}
{id} {printf("%s : ID\n", yytext); return ID; }
{int_lit} {printf("%s : INT_LIT\n", yytext); return INT_LIT; }
{float_lit} {printf("%s : FLOAT_LIT\n", yytext); return FLOAT_LIT; }
{err_int} {printf("Lexical error - line %d : %s\n", yylineno, yytext); return LEX_ERR;}
{err_float} {printf("Lexical error - line %d : %s\n", yylineno, yytext); return LEX_ERR;}
{err_id} {printf("Lexical error - line %d : %s\n", yylineno, yytext); return LEX_ERR;}
%%



int main(int argc, char** argv) {
    if(argc > 1) {
        if(!(yyin = fopen(argv[1], "r"))) {
           perror(argv[1]); 
           return  1; 
        }       
        while(yylex()){

        }
        fclose(yyin);
    } else printf("No source file given!\n"); 

    return 0; 
}

