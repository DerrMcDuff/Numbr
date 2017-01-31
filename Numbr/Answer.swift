//
//  Answer.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-23.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation

class Answer {
    
    var text:String?
    
    init(t:String) {
        self.text = t
    }
    
    func getText()-> String? {
        
        if let t:String = text {
            
            if (t.hasSuffix(".0")) {
                return String(t.characters.dropLast(2))
            } else {
                return t
            }
        } else {
            return nil
        }
        
    }
    
    var value:Double?
    var fraction:String?
    
}
