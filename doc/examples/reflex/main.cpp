#include "lex.yy.cpp"

int main() {
    ExampleLexer lexer(std::cin);
    while (lexer.yylex() != 0) {
        // lex() already handles output per rules
    }
    return 0;
}
