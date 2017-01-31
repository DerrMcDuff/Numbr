//
//  Note.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-21.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

class Note: NSObject {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
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
    
    func updateFromLine(at i: Int, with s: String) -> [Int] {
        
        lines[i].content = s
        let fetchedRefs = getReferences(from: i)
        
        for ref in fetchedRefs {
            lines[ref].setAnswer()
        }
        print(fetchedRefs)
        return fetchedRefs
        
    }
    
    func getReferences(from i: Int) -> [Int] {
        
        if (self.lines[i].variableDeclared != nil) {
            if let x = app.allData.varDictio[self.lines[i].variableDeclared!] {
                return x.references
            }
        } else {
            return [i]
        }
        return [i]
    }
    
    func convertForSave() -> String {
        var converted = ""
        converted.append("\(index)")
        converted.append("|||")
        for (i,line) in lines.enumerated() {
            converted.append("\(i)ÇÇÇ\(line.content)")
            if line.answer != nil  {
                
                converted.append("ÇÇÇ\(line.answer?.getText() ?? "0")")
                
                if line.variableDeclared != nil {
                    converted.append("ÇÇÇ\(line.variableDeclared!)|||")
                } else {
                    converted.append("|||")
                }
                
            } else {
                converted.append("|||")
            }
        }
        return converted
    }
    
    init (forLoad s:String) {
        let t = s.components(separatedBy: "|||")
        if t == [] {
            self.index = 0
            self.lines = [Line(at: 0),Line(at: 1),Line(at: 2)]
        } else {
            self.index = Int(t[0])!
            var l:[Line] = []
            for line in t[1...(t.count-1)] {
                let brokenLine:[String] = line.components(separatedBy: "ÇÇÇ")
                if let test:Int = Int(brokenLine[0]) {
                    let ll = Line(at: test)
                    ll.content = brokenLine[1]
                    if brokenLine.count == 3 {
                        ll.answer = Answer(t: brokenLine[2])
                    } else if brokenLine.count == 4 {
                        ll.answer = Answer(t: brokenLine[2])
                        ll.variableDeclared = brokenLine[3]
                    }
                    l.append(ll)
                }
                
                
            }
            self.lines = l
        }
    }
    
}
