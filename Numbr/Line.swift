//
//  Line.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-21.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

class Line {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    var index: Int
    var content: String
    var answer: Answer?
    
    var variableDeclared:String?
    
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
    
    func setAnswer() {
        
        if !content.contains("=") && variableDeclared != nil  {
            let app = UIApplication.shared.delegate as! AppDelegate
            app.allData.removeVariable(variableDeclared!)
            variableDeclared = nil
        }
        
        if content != "" {
            do {
                let result = try ParsedResult().execute(content, self.index)
                answer = Answer(t: " \(result)")
            } catch {
                
                if variableDeclared != nil {
                    self.answer = nil
                    app.allData.removeVariable(variableDeclared!)
                    variableDeclared = nil
                }
                
            }
        } else {
            answer = nil
        }
    }

    
}
