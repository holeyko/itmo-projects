"use strict"

// :NOTE: let -> const
let constructor_operation = (f) => (...args) => (x, y, z) => (f(...args.map(a => a(x, y, z))))

let add = constructor_operation((a, b) => a + b)
let subtract = constructor_operation((a, b) => a - b)
let multiply = constructor_operation((a, b) => a * b)
let divide = constructor_operation((a, b) => a / b)
let negate = constructor_operation(a => -a)
let sinh = constructor_operation(a => Math.sinh(a))
let cosh = constructor_operation(a => Math.cosh(a))

let cnst = (value) => (x, y, z) => value
let pi = () => Math.PI
let e = () => Math.E
let variable = (variable_name) => (x, y, z) => variable_name === 'x' ? x : variable_name === 'y' ? y : z
