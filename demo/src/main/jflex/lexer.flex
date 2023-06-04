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

digit           = [0-9]
WhiteSpace      = [ \t\r\n]+
InputCharacter  = [^\r\n]
LineTerminator = \r|\n|\r\n

Identifier      = [a-zA-Z_] [a-zA-Z0-9_]*

IntegerLiteral  = {digit}+
FloatLiteral    = {digit}+"."{digit}*

Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/_" [^_] ~"_/" | "/_" "_"+ "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "@" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/_" {CommentContent} "_"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

%state STRING
%state COMMENT


%%

<YYINITIAL> {
    /* keywords */
    "if"     { return symbol(ParserSym.IF, yytext()); }
    "else"   { return symbol(ParserSym.ELSE, yytext()); }
    "while"  { return symbol(ParserSym.WHILE, yytext()); }
    "for"    { return symbol(ParserSym.FOR, yytext()); }
    "int"    { return symbol(ParserSym.INT, yytext()); }
    "return" { return symbol(ParserSym.RETURN, yytext()); }
    "float"  { return symbol(ParserSym.FLOAT, yytext()); }
    "bool"   { return symbol(ParserSym.BOOL, yytext()); }
    "char"   { return symbol(ParserSym.CHAR, yytext()); }
    "string" { return symbol(ParserSym.STRING, yytext()); }
    "elif"   { return symbol(ParserSym.ELIF, yytext()); }
    "do"     { return symbol(ParserSym.DO, yytext()); }
    "read"   { return symbol(ParserSym.READ, yytext()); }
    "print"  { return symbol(ParserSym.PRINT, yytext()); }
    "main"   { return symbol(ParserSym.MAIN, yytext()); }
    "true"   { return symbol(ParserSym.TRUE, yytext()); }
    "break"  { return symbol(ParserSym.BREAK, yytext()); }
    "false"  { return symbol(ParserSym.FALSE, yytext()); }
    "$"      { return symbol(ParserSym.DOLAR, yytext()); }
    "not"    { return symbol(ParserSym.NOT, yytext()); }
    "!"      { return symbol(ParserSym.NOT, yytext()); }

    /* identifiers */
    {Identifier}        { return symbol(ParserSym.IDENTIFIER, yytext()); }

    /* literals */
    {IntegerLiteral}    { return symbol(ParserSym.INTEGER_LITERAL, Integer.parseInt(yytext())); }
    {FloatLiteral}      { return symbol(ParserSym.FLOAT_LITERAL, Float.parseFloat(yytext())); }
    \'[^\\\']\'         { return symbol(ParserSym.CHAR_LITERAL, yytext().charAt(1)); } // 'a', 'b', etc.
    \" { yybegin(STRING); string.setLength(0); } // Comienzo del string
    /* operators and separators */
    "="     { return symbol(ParserSym.EQ, yytext()); }
    "=="    { return symbol(ParserSym.EQEQ, yytext()); }
    "+"     { return symbol(ParserSym.PLUS, yytext()); }
    "-"     { return symbol(ParserSym.MINUS, yytext()); }
    "*"     { return symbol(ParserSym.MUL, yytext()); }
    "/"     { return symbol(ParserSym.DIV, yytext()); }
    ";"     { return symbol(ParserSym.SEMICOLON, yytext()); }
    "("     { return symbol(ParserSym.LPAREN, yytext()); }
    ")"     { return symbol(ParserSym.RPAREN, yytext()); }
    "{"     { return symbol(ParserSym.LBRACE, yytext()); }
    "}"     { return symbol(ParserSym.RBRACE, yytext()); }
    "++"    { return symbol(ParserSym.INCREMENT, yytext()); }
    "--"    { return symbol(ParserSym.DECREMENT, yytext()); }
    "["     { return symbol(ParserSym.LBRACKET, yytext()); }
    "]"     { return symbol(ParserSym.RBRACKET, yytext()); }
    "**"    { return symbol(ParserSym.POWER, yytext()); }
    "~"     { return symbol(ParserSym.MODULO, yytext()); }
    "<"     { return symbol(ParserSym.LESS_THAN, yytext()); }
    "<="    { return symbol(ParserSym.LESS_THAN_EQUAL, yytext()); }
    ">"     { return symbol(ParserSym.GREATER_THAN, yytext()); }
    ">="    { return symbol(ParserSym.GREATER_THAN_EQUAL, yytext()); }
    "!="    { return symbol(ParserSym.NOT_EQUAL, yytext()); }
    "^"     { return symbol(ParserSym.AND, yytext()); }
    "#"     { return symbol(ParserSym.OR, yytext()); }
    ","     { return symbol(ParserSym.COMMA, yytext()); }


    /* comments (C-style) */
    "/_"              { yybegin(COMMENT); }
    "@"               { /* manejar comentario de línea */ }

    /* whitespace */
    {WhiteSpace}      { /* ignore whitespace */ }
    {Comment}         { /* ignore Comments */ }
}

<COMMENT> {
    "_/"             { yybegin(YYINITIAL); }
    .                { /* ignore other characters */ }
}
<STRING> {
    \\n  { string.append('\n'); } // Secuencia de escape de nueva línea
    \\t  { string.append('\t'); } // Secuencia de escape de tabulación
    \\\" { string.append('\"'); } // Secuencia de escape de comillas
    [^\n\r\\\"]+ { string.append(yytext()); } // Caracteres regulares
    \"   { yybegin(YYINITIAL); return symbol(ParserSym.STRING_LITERAL, string.toString()); } // Fin del string
}

. {
    throw new Error("Carácter ilegal <" + yytext() + "> en línea " + yyline + ", columna " + yycolumn);
}
