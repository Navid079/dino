%option main
%option nodefault
%{
void printToken(const int, const char*, const char*);
%}

/* these parts are not code */
COMMENT #.*
NEWLINE [\n\r]|\r\n
WHITESPACE [ \t]|{NEWLINE}
ANYTHING .|{NEWLINE}

/* =================================== keywords =================================== */
/* == types */
CHARTYPES char|string
NUMERICTYPES int|float|short|long|double|byte
BOOLEANTYPES bool|bit
VOIDTYPE void
TYPES var|{CHARTYPES}|{NUMERICTYPES}|{BOOLEANTYPES}|{VOIDTYPE}

/* == conditions */
CONDITIONS if|elif|else

/* == loops */
WHILELOOP do|while
FORLOOP iterate|as
LOOPS {WHILELOOP}|{FORLOOP}

/* == functions */
FUNCTION func
LAMBDA f
RETURN return
FUNCTIONS {FUNCTION}|{LAMBDA}|{RETURN}

/* == class */
CLASS class
ACCESSMODIFIERS private|public|protected
INSTANSE new
CLASSES {CLASS}|{ACCESSMODIFIERS}|{INSTANSE}

/* == miscellaneous */
MISCKEYWORDS use

KEYWORD {TYPES}|{CONDITIONS}|{LOOPS}|{FUNCTIONS}|{CLASSES}|{MISCKEYWORDS}
/* ================================== identifier ================================== */
IDENTIFIERSTART [a-zA-Z_$]
IDENTIFIERFOLLOW {IDENTIFIERSTART}|[0-9]
IDENTIFIER {IDENTIFIERSTART}({IDENTIFIERFOLLOW})*

/* =================================== literals =================================== */

/* == numeric */
/* ==== integer */
/* ====== decimal integer */

DECINTSTART [1-9]
DECINTFOLLOW [0-9]
DECINTEXPONENT [eE]{DECINTSTART}{DECINTFOLLOW}*
DECINT {DECINTSTART}{DECINTFOLLOW}*(DECINTEXPONENT)?

/* ====== hexadecimal integer */
HEXINTSTART [1-9a-fA-F]
HEXINTFOLLOW [0-9a-fA-F]
HEXINTEXPONENT [eE]{HEXINTSTART}{HEXINTFOLLOW}*
HEXINT 0[xX]{HEXINTSTART}{HEXINTFOLLOW}({HEXINTEXPONENT})?

/* ====== binary integer */
BININT 0[bB][01]*

/* ====== integer zero */
ZEROINT 0([xXbB]0)?0*

INTEGERLITERAL ({DECINT}|{HEXINT}|{BININT}|{ZEROINT})[slb]?

/* ==== floating points */
FLOATSTART [1-9]
FLOATFOLLOW [0-9]
FLOATDEC \.{FLOATFOLLOW}+

FLOATLITERAL ({FLOATSTART}{FLOATFOLLOW}*{FLOATDEC})[d]?

NUMERICLITERAL {INTEGERLITERAL}|{FLOATLITERAL}

/* == char-string */
CHARBOUND '
CHARVALUE .|"\"[abefnrtv'0-7]|"\x"[0-9a-fA-F]+|"\u"[0-9a-fA-F]{4}|"\U"[0-9a-fA-F]{8}|"\\"|"\?"|"\"["]
CHAR {CHARBOUND}{CHARVALUE}{CHARBOUND}
STRINGBOUND \"
STRING {STRINGBOUND}.*{STRINGBOUND}

CHARSTRINGLITERAL {CHAR}|{STRING}

/* == boolean */
BOOLEANLITERAL true|false

LITERAL {NUMERICLITERAL}|{CHARSTRINGLITERAL}|{BOOLEANLITERAL}


/* ============================== operator-seperator ============================== */

OPERATOR [+=\-*/^&|~]|and|or|not
SEPERATOR [\[\]():,;{}\.]

%%

{KEYWORD} { printToken(1, "Keyword", yytext); }
{OPERATOR} { printToken(1, "Operator", yytext); }
{IDENTIFIER} { printToken(1, "Identifier", yytext); }
{LITERAL} { printToken(1, "Literal", yytext); }
{SEPERATOR} { printToken(0, "", yytext); }
{COMMENT} { printToken(1, "Comment", yytext); }
{NEWLINE} { printf("\n"); }
{WHITESPACE} ;
{ANYTHING} { printToken(1, "\x1B[31mUnknown\x1B[0m", yytext); }

%%

void printToken(const int printType, const char* type, const char* lexeme) {
  if (printType) {
    printf("<%s, %s> ", type, lexeme);
  } else {
    printf("<%s> ", lexeme);
  }
}
