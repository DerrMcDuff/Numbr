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
    private var answer:String! // this could become type Answer
    
    init(_ n:Int) {
        id = n
        content = ""
        answer = ""
    }
    
    func fill(_ content:String) {
        
        //TODO: Real algo
        
        
        // Placeholder algo using NSExpression
        
        mainAlgo(data.nowBlock.lines)

        
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
