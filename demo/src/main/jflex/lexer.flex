package com.compiler;
import java_cup.runtime.*;

%%

%class Lexer
%cup
%implements ParserSym
%line
%column
%char
%unicode


%{
    StringBuffer string = new StringBuffer();

    private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
    }
    private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
    }
%}


%eofval{
    return symbol(ParserSym.EOF);
%eofval}

digit = [0-9]
letter = [a-zA-Z]
whitespace = [\t\n]



%%

{digit}+ { return symbol(ParserSym.NUMBER, Integer.valueOf(yytext()));}

"(" { return symbol(ParserSym.LPAREN, yytext());}
")" { return symbol(ParserSym.RPAREN, yytext());}
"*" { return symbol(ParserSym.TIMES, yytext());}
"+" { return symbol(ParserSym.PLUS, yytext());}

{whitespace}+ {}
[^]                             { throw new Error("Cadena ilegal <"+
                                                        yytext()+">"); }



