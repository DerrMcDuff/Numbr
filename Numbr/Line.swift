//
//  Line.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-21.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation

class Line {
    
    var index: Int
    var content: String
    var answer: Answer?
    
    var relationWith: [Int]?
    
    init(at i: Int, withContent c: String) {
        index = i
        content = c
        answer = nil
    }
    
    init(at i: Int) {
        index = i
        content = ""
        answer = nil
    }
    
    func setAnswer(with content:String) {
        self.content = content
        if content != "" {
            do {
                let result = try ParsedResult().execute(content)
                answer = Answer(t: " \(result)")
            } catch {
                self.answer = nil
                print("I don't giva damn")
            }
        } else {
            answer = nil
        }
    }
    
    func getAnswer()->String {
        return (answer?.text)!
    }

    
}
