//
//  Data.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-21.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation

class Data: NSData {
    
    var notes:[Note]
    var varDictio:[(String, Double)] = []
    
    override init() {
        notes = [Note(at: 0)]
        super.init()
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(notes, forKey: "notes")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        notes = aDecoder.decodeObject(forKey: "notes") as! [Note]
        
    }
    
}

var instancedData = Data()
