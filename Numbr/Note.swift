//
//  Note.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-21.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation

class Note {
    
    var varDictio:[(String, Double)] = []
    
    // Local Variables
    private var index: Int
    private var lines: [Line]
    
    // Initialisation
    init(at i:Int, withLines l:[Line]) {
        index = i
        lines = [Line(at:0), Line(at:1), Line(at:2)]
    }
    
    init(at i:Int){
        index = i
        lines = [Line(at:0), Line(at:1), Line(at:2)]
    }
    
    
    // Getters
    func getLinesCount()->Int {
        return lines.count
    }
    
    func getLine(at i:Int)->Line{
        return lines[i]
    }
    
    func addLine(at i: Int) {
        lines.append(Line(at: i))
    }
}
