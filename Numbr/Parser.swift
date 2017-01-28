//
//  Parser.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-28.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

typealias TokenGenerator = (String) -> Token?

func exponential(_ n1:Double,_ n2:Double)->Double {
    var a:Double = 1
    for _ in 1...Int(n2) {a *= n1}
    return a
}

var simpleOperations:[String:((Double,Double)->Double)] = [
    "+":{$0+$1},
    "-":{$0-$1},
    "*":{$0*$1},
    "/":{$0/$1},
    "^":{exponential($0,$1)}
]


public enum Token {
    
    //case Function()
    case Variable(String)
    //    case Operator
    case Identifier(String)
    case Number(Double)
    case ParensOpen
    case ParensClose
    case Comma
    case Other(String)
}

func getVarValue(_ name:String) -> Any {
    for v in instancedData.varDictio {
        if  name == v.0 {
            print("v1:\(v.1)")
            return v.1
        }
    }
    
    return name
}

let tokenList: [(String, TokenGenerator)] = [
    
    ("[ \t\n]", { _ in nil }),
    ("[a-zA-Z][a-zA-Z0-9]*", {(n: String) in .Variable(n)}),
    ("\\(", {_ in .ParensOpen}),
    ("\\)", {_ in .ParensClose}),
    ("[0-9.]+", { (n:String) in .Number((n as NSString).doubleValue)}),
    
]

var expressions = [String: NSRegularExpression]()

public extension String {
    
    public func match(regex: String) -> String? {
        let expression: NSRegularExpression
        if let exists = expressions[regex] {
            expression = exists
        } else {
            expression = try! NSRegularExpression(pattern: "^\(regex)", options: [])
            expressions[regex] = expression
        }
        
        let range = expression.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, self.utf16.count))
        if range.location != NSNotFound {
            return (self as NSString).substring(with:range)
        }
        return nil
    }
}


public protocol ExprNode: CustomStringConvertible {
    
}

public struct NumberNode: ExprNode {
    public let value: Double
    public var description: String {
        return "NumberNode(\(value))"
    }
}

public struct textNode: ExprNode {
    public let name: String
    public var description: String {
        return "VariableNode(\(name))"
    }
}

public struct OperationNode: ExprNode {
    public let name: String
    public var description: String {
        return "Operation(\(name))"
    }
}

public struct FunctionNode: CustomStringConvertible {
    public let prototype: PrototypeNode
    public let body: ExprNode
    public var description: String {
        return "FunctionNode(prototype: \(prototype), body: \(body))"
    }
}

public struct BinaryOpNode: ExprNode {
    public let op: String
    public let lN: ExprNode
    public let rN: ExprNode
    public var description: String {
        return "BinaryOpNode(\(op), lN: \(lN), rN: \(rN))"
    }
}

public struct PrototypeNode: CustomStringConvertible {
    public let name: String
    public let argumentNames: [String]
    public var description: String {
        return "PrototypeNode(name: \(name), argumentNames: \(argumentNames))"
    }
}

public struct CallNode: ExprNode {
    public let callee: String
    public let arguments: [ExprNode]
    public var description: String {
        return "CallNode(name: \(callee), argument: \(arguments))"
    }
}


private func tokenized(input:String) -> [Token] {
    
    var tokens = [Token]()
    var copy:String = input
    
    while copy.characters.count>0 {
        
        var matches:Bool = false
        for (pattern, generator) in tokenList {
            if let m = copy.match(regex: pattern) {
                if let t = generator(m) {
                    tokens.append(t)
                }
                copy = copy.substring(from: copy.index(copy.startIndex, offsetBy: m.characters.count))
                matches = true
                break
            }
            
        }
        
        if !matches {
            let index = copy.index(copy.startIndex, offsetBy: 1)
            tokens.append(.Other(copy.substring(to: index)))
            copy = copy.substring(from:index)
        }
    }
    
    return tokens
}




enum Errors: Error {
    case UnexpectedToken
    case UndefinedOperator(String)
    
    case ExpectedCharacter(Character)
    case ExpectedExpression
    case ExpectedArgumentList
    case ExpectedFunctionName
}

public class Parsed {
    
    let tokens: [Token]
    var index:Int = 0
    
    init(str: String) {
        self.tokens = tokenized(input: str)
    }
    
    private func seeCurrentToken() throws -> Token {
        guard tokens.count>index else {
            throw Errors.ExpectedExpression
        }
        
        return tokens[index]
    }
    
    private func popCurrentToken() -> Token {
        index += 1
        return tokens[index-1]
    }
    
    private func parseNumber() throws -> ExprNode {
        guard case let Token.Number(value) = popCurrentToken() else {
            throw Errors.UnexpectedToken
        }
        return NumberNode(value: value)
    }
    
    private func parseExpression() throws -> ExprNode {
        let node = try parsePrimary()
        return try parseBinaryOp(node: node)
    }
    
    private func parseParens() throws -> ExprNode {
        guard case Token.ParensOpen = popCurrentToken() else {
            throw Errors.ExpectedCharacter("(")
        }
        
        let exp = try parseExpression()
        
        guard case Token.ParensClose = popCurrentToken() else {
            throw Errors.ExpectedCharacter(")")
        }
        
        return exp
    }
    
    
    private func parseFunction() throws -> ExprNode {
        guard case let Token.Identifier(name) = popCurrentToken() else {
            print("\(popCurrentToken())")
            throw Errors.UnexpectedToken
        }
        
        guard case Token.ParensOpen = try seeCurrentToken() else {
            throw Errors.UnexpectedToken
        }
        _ = popCurrentToken()
        
        var arguments = [ExprNode]()
        if case Token.ParensClose = try seeCurrentToken() {
        }
        else {
            while true {
                let argument = try parseExpression()
                arguments.append(argument)
                
                if case Token.ParensClose = try seeCurrentToken() {
                    break
                }
                
                guard case Token.Comma = popCurrentToken() else {
                    throw Errors.ExpectedArgumentList
                }
            }
        }
        
        _ = popCurrentToken()
        return CallNode(callee: name, arguments: arguments)
    }
    
    private func parseVariable() throws -> ExprNode {
        guard case let Token.Variable(s) = popCurrentToken() else {
            throw Errors.UnexpectedToken
        }
        
        let g = getVarValue(s)
        print(instancedData.varDictio)
        
        if g is String {
            return textNode(name: g as! String)
        } else if g is Double {
            return NumberNode(value: g as! Double)
        }
        throw Errors.UnexpectedToken
    }
    
    private func parsePrimary() throws -> ExprNode {
        switch (try seeCurrentToken()) {
        case .Variable:
            return try parseVariable()
        case .Number:
            return try parseNumber()
        case .ParensOpen:
            return try parseParens()
        default:
            throw Errors.ExpectedExpression
        }
    }
    
    private let operatorPrecedence: [String: Int] = [
        "+": 20,
        "-": 20,
        "*": 40,
        "/": 40,
        "^": 50,
        "=": 0
    ]
    
    private func getCurrentTokenPrecedence() throws -> Int {
        guard index < tokens.count else {
            return -1
        }
        
        guard case let Token.Other(op) = try seeCurrentToken() else {
            return -1
        }
        
        guard let precedence = operatorPrecedence[op] else {
            throw Errors.UndefinedOperator(op)
        }
        
        return precedence
    }
    
    private func parseBinaryOp(node: ExprNode, exprPrecedence: Int = 0) throws -> ExprNode {
        var lhs = node
        while true {
            let tokenPrecedence = try getCurrentTokenPrecedence()
            if tokenPrecedence < exprPrecedence {
                return lhs
            }
            
            guard case let Token.Other(op) = popCurrentToken() else {
                throw Errors.UnexpectedToken
            }
            
            var rhs = try parsePrimary()
            let nextPrecedence = try getCurrentTokenPrecedence()
            
            if tokenPrecedence < nextPrecedence {
                rhs = try parseBinaryOp(node: rhs, exprPrecedence: tokenPrecedence+1)
            }
            lhs = BinaryOpNode(op: op, lN: lhs, rN: rhs)
        }
    }
    
    private func parsePrototype() throws -> PrototypeNode {
        guard case let Token.Identifier(name) = popCurrentToken() else {
            throw Errors.ExpectedFunctionName
        }
        
        guard case Token.ParensOpen = popCurrentToken() else {
            throw Errors.ExpectedCharacter("(")
        }
        
        var argumentNames = [String]()
        while case let Token.Identifier(name) = try seeCurrentToken() {
            _ = popCurrentToken()
            argumentNames.append(name)
            
            if case Token.ParensClose = try seeCurrentToken() {
                break
            }
            
            guard case Token.Comma = popCurrentToken() else {
                throw Errors.ExpectedArgumentList
            }
        }
        
        // remove ")"
        _ = popCurrentToken()
        
        return PrototypeNode(name: name, argumentNames: argumentNames)
    }
    
    private func parseDefinition() throws -> FunctionNode {
        _ = popCurrentToken()
        let prototype = try parsePrototype()
        let body = try parseExpression()
        return FunctionNode(prototype: prototype, body: body)
    }
    
    private func parseTopLevelExpr() throws -> FunctionNode {
        let prototype = PrototypeNode(name: "", argumentNames: [])
        let body = try parseExpression()
        return FunctionNode(prototype: prototype, body: body)
    }
    
    func parse() throws -> ExprNode {
        index = 0
        
        var nodes = [Any]()
        while index < tokens.count {
            let expr = try parseExpression()
            nodes.append(expr)
        }
        return nodes[0] as! ExprNode
    }
}





func saveVariable(_ name: String, _ value: Double) {
    instancedData.varDictio.append(name,value)
}

func compute(_ t: ExprNode) throws -> Double {
    
    func operation(_ l:Double,_ r:Double,_ o:String) throws -> Double {
        
        for (name,op) in simpleOperations {
            if name == o {
                return op(l,r)
            }
        }
        
        throw Errors.ExpectedExpression
        
    }
    
    func loop (_ s: ExprNode) throws -> Double  {
        if let bn = s as? BinaryOpNode {
            
            if bn.op == "=" {
                
                guard let v = bn.lN as? textNode else {
                    return try loop(bn.rN)
                }
                
                let c = try loop(bn.rN)
                saveVariable(v.name, c)
                return c
                
            } else {
                
                let x = try loop(bn.lN)
                let d = try loop(bn.rN)
            
                return try operation(x,d,bn.op)
                
            }
            
        } else if let nn = s as? NumberNode {
            return nn.value
        }
        
        throw Errors.ExpectedExpression
    }
    return try loop(t)
    
}

class ParsedResult {
    
    init() {
        
    }
    
    func execute(_ t: String) throws -> Double {
        do {
            let a = try Parsed(str: t).parse()
            let b = try compute(a)
            return b
        } catch {
            throw Errors.ExpectedExpression
        }
    }
}





