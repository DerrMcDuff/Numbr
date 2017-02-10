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
    
    var note: Int
    var index: Int
    var content: String
    var answer: Answer?
    
    var variableDeclared:String?
    
    init(at i: Int, withContent c: String, inNote n:Int ) {
        note = n
        index = i
        content = c
        answer = nil
    }
    
    init(at i:Int, inNote n: Int) {
        note = n
        index = i
        content = ""
        answer = nil
    }
    
    func setAnswer() -> (String,Variable) {
        
        if !content.contains("=") && variableDeclared != nil  {
            let app = UIApplication.shared.delegate as! AppDelegate
            app.allData.notes[note].removeVariable(variableDeclared!)
            //app.allData.removeVariable(variableDeclared!)
            variableDeclared = nil
        }
        
        if content != "" {
            do {
                let result = try ParsedResult().execute(content, note: self.note, line: self.index)
                answer = Answer(t: "\(result.0)")
                if result.1.isEmpty {
                    return("nothing", Variable("",0))
                } else {
                    return ("Add",(result.1)[0])
                }
                
            } catch {
                
                if variableDeclared != nil {
                    self.answer = nil
                    let varde = variableDeclared!
                    variableDeclared = nil
                    return ("Remove",Variable(varde,0))
                }
                
            }
        } else {
            answer = nil
        }
        return("nothing", Variable("",0))
    }

    
}
