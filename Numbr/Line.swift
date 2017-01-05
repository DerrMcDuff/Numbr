//
//  Line.swift
//  Numbr
//
//  Created by Derr McDuff on 16-12-29.
//  Copyright © 2016 anonymous. All rights reserved.
//

import Foundation

class Line {
    
    let id:Int
    private var content:String!
    private var answer:String!
    
    init(_ n:Int) {
        id = n
        content = ""
        answer = ""
    }
    
    func fill(_ content:String) {
        
        let cNS = String(content.characters.filter({$0 != " "}))
        // TODO: This
//        if cNS != ""{
//            switch true {
//            case cNS.contains("="):
//                equal(cNS)
//            case cNS.contains("="):
//                
//            default:
//                <#code#>
//            }
//        }
        let s = NSExpression(format: content)
        let sq = s.expressionValue(with: nil, context: nil)
        let uw = sq as! Double
        self.answer = "\(uw)"
    }
    func getContent()->String {
        return content
    }
    func setContent(_ newContent: String) {
        content = newContent
    }
    func setAnswer(_ newAnswer: String) {
        answer = newAnswer
    }
    func getAnswer()->String {
        return answer
    }
    
    func equal(_ rawEq:String) {
        
        
        let trans = rawEq.components(separatedBy: "=")
        
    }
    
}
