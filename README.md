# Frac

A simple Lua module for working with fractions. 

## Usage
Just copy-paste file Frac.lua in your project folder, then require it in all necessary source files:

    local Frac = require "Frac"
    
### New fraction
    local a = Frac:new(4, 5)
    local b = Frac:new(3) -- if second argument is missing, it takes 1
    local c = Frac:new(5.5, 2.3) -- non-integers also acceptable
    local d = Frac:new(6, 2)
    print(a, b, c, d) -- Notice that d is auto-cutted. You can disable this behavior using Frac.autoCut = false

### Operations
All standard arithmetic operations (+, -, *, /, ^, unary -) are supported. Second argument may either be a fraction or a number.

    print(a + b) -- 19 / 5
    print(c * d) -- 16.5 / 2.3
    print(-a) -- -4 / 5
    print(a^2) -- 16 / 25
    print(a^b) -- 64 / 125
    
### Comparison
*Warning*: you cannot compare a fraction and a number - this is limitations of Lua itself.

    print(a == a) -- true
    print(a < b) -- true

### Other operations
    a:cut() -- Cuts fraction. Works only on fractions with integer components or if fraction's value is integer
    a:value() -- Returns decimal value of fraction (0.8)
    a:components() -- Returns numerator and denominator (4, 5)
    
## Versions
Module works fine on Lua 5.1 (Corona SDK) and Lua 5.2
