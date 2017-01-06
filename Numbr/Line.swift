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
        
        //TODO: Real algo
        
        
        // Placeholder algo using NSExpression
        if content != "" {
            let s = NSExpression(format: content)
            let sq = s.expressionValue(with: nil, context: nil)
            let uw = sq as! Double
            self.answer = "\(uw)"
        } else {
            self.answer = ""
        }
        
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
    
}
