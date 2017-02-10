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
    var vars: [String]
    
    var variableDeclared:String?
    
    init(at i: Int, withContent c: String, inNote n:Int ) {
        note = n
        index = i
        content = c
        answer = nil
        vars = []
    }
    
    init(at i:Int, inNote n: Int) {
        note = n
        index = i
        content = ""
        answer = nil
        vars = []
    }
    
    func setAnswer() -> [(String,Variable)] {
        
        var varToRemove:[(Variable)] = []
        
        if !content.contains("=") && variableDeclared != nil  {
            let app = UIApplication.shared.delegate as! AppDelegate
            app.allData.notes[note].removeVariable(variableDeclared!)
            varToRemove.append(Variable(variableDeclared!,0))
            variableDeclared = nil
        }
        
        if content != "" {
            
            do {
                let result = try ParsedResult().execute(content, note: self.note, line: self.index)
                answer = Answer(t: "\(result.0)")
                if result.1.isEmpty {
                    return[("nothing", Variable("",0))]
                } else {
                    
                    if varToRemove.isEmpty {
                        return [("Add",(result.1)[0])]
                    } else {
                        var r: [(String,Variable)] = []
                        for v in varToRemove {
                            r.append(("Remove",v))
                        }
                        r.append(("Add",(result.1)[0]))
                        return r
                    }
                    
                    
                }
                
            } catch {

                print("Caught you!")
                self.answer = nil
                
            }
        } else {
            answer = nil
        }
        return[("nothing", Variable("",0))]
    }

    
}
