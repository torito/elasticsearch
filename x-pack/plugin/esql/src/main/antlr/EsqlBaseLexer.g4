lexer grammar EsqlBaseLexer;

EVAL : 'eval' -> pushMode(EXPRESSION);
EXPLAIN : 'explain' -> pushMode(EXPRESSION);
FROM : 'from' -> pushMode(SOURCE_IDENTIFIERS);
ROW : 'row' -> pushMode(EXPRESSION);
STATS : 'stats' -> pushMode(EXPRESSION);
WHERE : 'where' -> pushMode(EXPRESSION);
SORT : 'sort' -> pushMode(EXPRESSION);
LIMIT : 'limit' -> pushMode(EXPRESSION);
PROJECT : 'project' -> pushMode(SOURCE_IDENTIFIERS);

LINE_COMMENT
    : '//' ~[\r\n]* '\r'? '\n'? -> channel(HIDDEN)
    ;

MULTILINE_COMMENT
    : '/*' (MULTILINE_COMMENT|.)*? '*/' -> channel(HIDDEN)
    ;

WS
    : [ \r\n\t]+ -> channel(HIDDEN)
    ;



mode EXPRESSION;

PIPE : '|' -> popMode;

fragment DIGIT
    : [0-9]
    ;

fragment LETTER
    : [A-Za-z]
    ;

fragment ESCAPE_SEQUENCE
    : '\\' [tnr"\\]
    ;

fragment UNESCAPED_CHARS
    : ~[\r\n"\\]
    ;

fragment EXPONENT
    : [Ee] [+-]? DIGIT+
    ;

STRING
    : '"' (ESCAPE_SEQUENCE | UNESCAPED_CHARS)* '"'
    | '"""' (~[\r\n])*? '"""' '"'? '"'?
    ;

INTEGER_LITERAL
    : DIGIT+
    ;

DECIMAL_LITERAL
    : DIGIT+ DOT DIGIT*
    | DOT DIGIT+
    | DIGIT+ (DOT DIGIT*)? EXPONENT
    | DOT DIGIT+ EXPONENT
    ;

BY : 'by';

AND : 'and';
ASC : 'asc';
ASSIGN : '=';
COMMA : ',';
DESC : 'desc';
DOT : '.';
FALSE : 'false';
FIRST : 'first';
LAST : 'last';
LP : '(';
OPENING_BRACKET : '[' -> pushMode(DEFAULT_MODE);
CLOSING_BRACKET : ']' -> popMode, popMode; // pop twice, once to clear mode of current cmd and once to exit DEFAULT_MODE
NOT : 'not';
NULL : 'null';
NULLS : 'nulls';
OR : 'or';
RP : ')';
TRUE : 'true';

EQ  : '==';
NEQ : '!=';
LT  : '<';
LTE : '<=';
GT  : '>';
GTE : '>=';

PLUS : '+';
MINUS : '-';
ASTERISK : '*';
SLASH : '/';
PERCENT : '%';

UNQUOTED_IDENTIFIER
    : (LETTER | '_') (LETTER | DIGIT | '_')*
    ;

QUOTED_IDENTIFIER
    : '`' ( ~'`' | '``' )* '`'
    ;

EXPR_LINE_COMMENT
    : LINE_COMMENT -> channel(HIDDEN)
    ;

EXPR_MULTILINE_COMMENT
    : MULTILINE_COMMENT -> channel(HIDDEN)
    ;

EXPR_WS
    : WS -> channel(HIDDEN)
    ;



mode SOURCE_IDENTIFIERS;

SRC_PIPE : '|' -> type(PIPE), popMode;
SRC_CLOSING_BRACKET : ']' -> popMode, popMode, type(CLOSING_BRACKET);
SRC_COMMA : ',' -> type(COMMA);
SRC_ASSIGN : '=' -> type(ASSIGN);

SRC_UNQUOTED_IDENTIFIER
    : ~[=`|, [\]\t\r\n]+
    ;

SRC_QUOTED_IDENTIFIER
    : QUOTED_IDENTIFIER
    ;

SRC_LINE_COMMENT
    : LINE_COMMENT -> channel(HIDDEN)
    ;

SRC_MULTILINE_COMMENT
    : MULTILINE_COMMENT -> channel(HIDDEN)
    ;

SRC_WS
    : WS -> channel(HIDDEN)
    ;
