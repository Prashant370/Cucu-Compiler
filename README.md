# Compiler Design for CUCU

## Overview

This project consists of a lexer (`cucu.l`) and a parser (`cucu.y`) designed to tokenize and parse sample input files (`sample1.cu` and `sample2.cu`). The lexer tokenizes the input files, while the parser checks the syntactic correctness based on a predefined grammar.

## Files

- `cucu.l`: Lexer file responsible for tokenizing the input files.
- `cucu.y`: Parser file containing the grammar rules for parsing the input files.
- `sample1.cu`: A sample input file with correct syntax.
- `sample2.cu`: A sample input file with incorrect syntax.

## Usage

1. Compile the lexer and parser files:
    ```
    lex cucu.l
    yacc -d cucu.y -o cucu.tab.c
    ```

2. Compile the generated lexer and parser files along with the input files:
    ```
    gcc lex.yy.c cucu.tab.c -o parser
    ```

3. Run the parser with the input file (e.g., `sample1.cu`):
    ```
    ./parser sample1.cu
    ```

## Assumptions

1. Negative numbers are not allowed.
2. Increment (`a++`) and decrement (`a--`) operators are not allowed.
3. Only `int` and `char*` datatypes are allowed.
4. Use of bitwise operators is not allowed.
5. Only conditional statements followed by curly brackets are allowed.
6. The parser will stop printing after encountering syntax errors.
7. The modulo operator is not supported in arithmetic.
8. Single-line comments (double slash) are not allowed.
9. Boolean operations in function calls are not allowed.
10. Allowed tokens include `ID`, `NUM`, `DATATYPE`, `RO`, `IF`, `ELSE`, `WHILE`, and `RET`.

> **Note:**  There are two sample files named `sample1.cu` and `sample2.cu` provided for testing the parser and lexer. After running, two files named `parser.txt` and `lexer.txt` will be generated.

