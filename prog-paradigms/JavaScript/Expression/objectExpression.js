'use strict'

function Const(value) {
    this.value = value
    this.evaluate = function (x, y, z) {
        return value
    }

    this.toString = function () {
        return value.toString()
    }

    this.prefix = this.toString

    this.diff = function () {
        return new Const(0)
    }
}

function Variable(name) {
    this.name = name.trim()

    this.evaluate = function (x, y, z) {
        return this.name === 'x' ? x : this.name === 'y' ? y : z
    }

    this.toString = function () {
        return this.name
    }

    this.prefix = this.toString

    this.diff = function (variableName) {
        return variableName === this.name ? new Const(1) : new Const(0)
    }
}

function Operation(func, diffFunc, sign, ...args) {
    this.func = func
    this.diffFunc = diffFunc
    this.sign = sign
    this.args = args

    this.evaluate = function (x, y, z) {
        return func(...args.map(a => a.evaluate(x, y, z)))
    }

    this.toString = function () {
        let ret = ''
        args.forEach(elem => ret += elem.toString() + ' ')
        return ret + sign
    }

    this.prefix = function () {
        let ret = '(' + sign + ' '
        args.forEach(elem => ret += elem.prefix() + ' ')
        return ret.substring(0, ret.length - 1) + ')'
    }

    this.diff = diffFunc(...args)
}

function Add(left, right) {
    let difFunc = (a, b) => (variableName) => new Add(a.diff(variableName), b.diff(variableName))
    Operation.call(this, (a, b) => a + b, difFunc, '+', left, right)
}

Add.prototype = Object.create(Operation.prototype)
Add.prototype.constructor = Add

function Subtract(left, right) {
    let difFunc = (a, b) => (variableName) => new Subtract(a.diff(variableName), b.diff(variableName))
    Operation.call(this, (a, b) => a - b, difFunc, '-', left, right)
}

Subtract.prototype = Object.create(Operation.prototype)
Subtract.prototype.constructor = Subtract

function Multiply(left, right) {
    let difFunc = (a, b) => (variableName) =>
        new Add(
            new Multiply(a.diff(variableName), b),
            new Multiply(a, b.diff(variableName))
        )
    Operation.call(this, (a, b) => a * b, difFunc, '*', left, right)
}

Multiply.prototype = Object.create(Operation.prototype)
Multiply.prototype.constructor = Multiply

function Divide(left, right) {
    let difFunc = (a, b) => (variableName) =>
        new Divide(
            new Subtract(
                new Multiply(a.diff(variableName), b),
                new Multiply(a, b.diff(variableName))
            ),
            new Multiply(b, b)
        )
    Operation.call(this, (a, b) => a / b, difFunc, '/', left, right)
}

Divide.prototype = Object.create(Operation.prototype)
Divide.prototype.constructor = Divide

function Negate(element) {
    let difFunc = (a) => (variableName) => new Negate(a.diff(variableName))
    Operation.call(this, a => -a, difFunc, 'negate', element)
}

Negate.prototype = Object.create(Operation.prototype)
Negate.prototype.constructor = Negate

function Sinh(element) {
    let difFunc = (a) => (variableName) => new Multiply(new Cosh(a), a.diff(variableName))
    Operation.call(this, a => Math.sinh(a), difFunc, 'sinh', element)
}

Sinh.prototype = Object.create(Operation.prototype)
Sinh.prototype.constructor = Sinh

function Cosh(element) {
    let difFunc = (a) => (variableName) => new Multiply(new Sinh(a), a.diff(variableName))
    Operation.call(this, a => Math.cosh(a), difFunc, 'cosh', element)
}

Cosh.prototype = Object.create(Operation.prototype)
Cosh.prototype.constructor = Cosh

function Mean(...args) {
    let func = (...args) => {
        let sum = 0.0
        for (const elem of args) {
            sum += elem
        }

        return sum / args.length
    }
    let diffFunc = () => {
    }
    Operation.call(this, func, diffFunc, 'mean', ...args)
}

Mean.prototype = Object.create(Operation.prototype)
Mean.prototype.constructor = Mean

function Var(...args) {
    let func = (...args) => {
        let sum = 0.0
        for (const elem of args) {
            sum += elem
        }
        let average = sum / args.length
        let res = 0.0
        for (const elem of args) {
            res += (elem - average) * (elem - average)
        }
        return res / args.length
    }
    let diffFunc = () => {
    }
    Operation.call(this, func, diffFunc, 'var', ...args)
}

Var.prototype = Object.create(Operation.prototype)
Var.prototype.constructor = Var

function ExpressionError(message) {
    Error.call(this, message)
    this.message = message
}

ExpressionError.prototype = Object.create(Error.prototype)
ExpressionError.prototype.constructor = ExpressionError

function SyntaxError(message) {
    ExpressionError.call(this, message)
}

SyntaxError.prototype = Object.create(ExpressionError.prototype)
SyntaxError.prototype.constructor = SyntaxError

function OperationError(message) {
    SyntaxError.call(this, message)
}

OperationError.prototype = Object.create(SyntaxError.prototype)
OperationError.prototype.constructor = OperationError

let commonParser = function (parseMode) {
    return function (expression) {
        let parseExpression
        let pos = 0
        let variablesList = ['x', 'y', 'z']
        let separatorsList = ['(', ')', ' ']
        let informativeSeparatorsList = ['(', ')']
        let operationsList = {
            'mean': Infinity,
            'var': Infinity,
            '+': 2,
            '-': 2,
            '*': 2,
            '/': 2,
            'negate': 1,
            'sinh': 1,
            'cosh': 1,
            '': 1,
        }

        let skipNonInformativeSeparators = function () {
            while (!isEnd()) {
                let separator = parseSeparator()
                if (separator.length === 0 || informativeSeparatorsList.includes(separator)) {
                    pos -= separator.length
                    return
                }
            }
        }

        let expect = function (expectedElem) {
            if (expression[pos] !== expectedElem) {
                throw new SyntaxError('expected ' + expectedElem + ' at ' + (pos + 1) + ' position');
            }
            pos++
        }

        let getCurCH = function () {
            return expression[pos]
        }

        let isEnd = function () {
            return pos === expression.length
        }

        let handleInformativeSeparator = function () {
            skipNonInformativeSeparators()
            let separator = parseSeparator()
            switch (separator) {
                case '(':
                    let result = parseExpression(true)
                    skipNonInformativeSeparators()
                    expect(')')
                    return result
                case ')':
                    throw new SyntaxError('unexpected ) at ' + pos + ' position')
            }

            return undefined;
        }

        let createOperation = function (operation, args) {
            if (operationsList[operation] !== args.length && operationsList[operation] !== Infinity) {
                throw new SyntaxError('incorrect count of inputs for operation ' + operation)
            }

            switch (operation) {
                case '':
                    return args[0]
                case '+':
                    return new Add(...args)
                case '-':
                    return new Subtract(...args)
                case '*':
                    return new Multiply(...args)
                case '/':
                    return new Divide(...args)
                case 'negate':
                    return new Negate(...args)
                case 'cosh':
                    return new Cosh(...args)
                case 'sinh':
                    return new Sinh(...args)
                case 'mean':
                    return new Mean(...args)
                case 'var':
                    return new Var(...args)
            }
        }

        let parsePrefixExpression = function (isOperationExpected = false) {
            let operation = ''
            try {
                operation = parseOperation();
            } catch (e) {
                if (isOperationExpected || !(e instanceof OperationError)) {
                    throw e
                }
            }

            let countArgs = operationsList[operation]
            let args = []
            for (let i = 0; i < countArgs; i++) {
                let tmpPos = pos
                try {
                    args.push(parseElement())
                } catch (e) {
                    if (countArgs === Infinity) {
                        pos = tmpPos
                        break
                    }
                    throw e
                }
            }

            return createOperation(operation, args)
        }

        let parsePostfixExpression = function (isOperationExpected = false) {
            let stack = []
            while (!isEnd()) {
                try {
                    stack.push(parseElement())
                } catch (e1) {
                    if (!e1 instanceof SyntaxError) {
                        throw e1
                    }
                    try {
                        let operation = ''
                        operation = parseOperation()
                        let countArgs = operationsList[operation] === Infinity ? stack.length : operationsList[operation]
                        let args = stack.splice(stack.length - countArgs, countArgs)
                        let expr = createOperation(operation, args)
                        stack.push(expr)
                    } catch (e2) {
                        if (isOperationExpected || stack.length > 1 || !(e2 instanceof OperationError)) {
                            throw e2
                        }
                    }
                }
            }

            return stack.pop()
        }

        let parseToken = function () {
            let curToken = ''
            while (!isEnd()) {
                curToken += getCurCH()
                pos++

                for (let separator of separatorsList) {
                    if (separator.length <= curToken.length && curToken.substring(curToken.length - separator.length) === separator) {
                        pos -= separator.length
                        return curToken.substring(0, curToken.length - separator.length)
                    }
                }
            }

            return curToken
        }

        let parseSeparator = function () {
            let curSeparator = ''
            let controlPos = pos
            let controlSep = ''
            while (!isEnd()) {
                if (separatorsList.includes(curSeparator + getCurCH())) {
                    curSeparator += getCurCH()
                    pos++
                    controlSep = curSeparator
                    controlPos = pos
                }
                if (separatorsList.some(separator => separator.substring(0, curSeparator.length + 1) === curSeparator + getCurCH())) {
                    curSeparator += getCurCH()
                    pos++
                } else {
                    break
                }
            }

            pos = controlPos
            return controlSep
        }

        let parseOperation = function () {
            skipNonInformativeSeparators()
            let operation = parseToken()
            if (Object.keys(operationsList).includes(operation)) {
                return operation
            } else {
                pos -= operation.length
                throw new OperationError('unexpected operation ' + operation + ' at pos ' + (pos + 1))
            }
        }

        let parseElement = function () {
            let maybeExpression = handleInformativeSeparator();
            if (maybeExpression !== undefined) {
                return maybeExpression;
            }

            let element = parseToken()
            if (element !== '' && !isNaN(element)) {
                return new Const(parseInt(element))
            } else if (variablesList.includes(element)) {
                return new Variable(element)
            } else {
                pos -= element.length
                throw new SyntaxError('expected expression element after ' + (pos + 1) + ' position')
            }
        }

        switch (parseMode) {
            case 'postfix':
                parseExpression = parsePostfixExpression
                break
            case 'prefix':
                parseExpression = parsePrefixExpression
                break
            default:
                throw new ExpressionError('unknown parse mode ' + parseMode)
        }

        let res = parseExpression()
        skipNonInformativeSeparators()
        if (!isEnd()) {
            throw new Error('expected end of expression after ' + pos + ' position')
        }
        return res
    }
}

let parsePrefix = commonParser('prefix')
let parse = commonParser('postfix')


