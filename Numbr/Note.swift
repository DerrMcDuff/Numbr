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
    private var activeCell: Int
    private var lines: [Line]
    var varDictio:[(Variable)]
    
    // Initialisation
    init(at i:Int, withLines l:[Line]) {
        varDictio = []
        index = i
        lines = [Line(at:0, inNote: i)]
        activeCell = 0
    }
    
    init(at i:Int){
        varDictio = []
        index = i
        lines = [Line(at:0, inNote: i)]
        activeCell = 0
    }
    
    
    // Getters
    func getLinesCount()->Int {
        return lines.count
    }
    
    func getLine(at i:Int)->Line{
        return lines[i]
    }
    
    func getIndex() -> Int {
        return self.index
    }
    
    func addLine(at i: Int) {
        lines.append(Line(at: i, inNote: index))
    }
    
    func updateFromLine(at i: Int, with s: String) -> [Int] {
        
        lines[i].content = s
        let fetchedRefs = getReferences(from: i)
        
        for ref in fetchedRefs {
            let feedback = lines[ref].setAnswer()
            if feedback.0 == "Add" {
                saveVariable(feedback.1.name,feedback.1.value,feedback.1.references[0])
            } else if feedback.0 == "Remove" {
                removeVariable(feedback.1.name)
            }
        }
        print(fetchedRefs)
        return fetchedRefs
        
    }
    
    func getReferences(from i: Int) -> [Int] {
        
        if (self.lines[i].variableDeclared != nil) {
            let x = varDictio.filter({$0.name == self.lines[i].variableDeclared!})[0]
            return x.references
        } else {
            return [i]
        }
        
    }
    
    // Var stuff
    
    func removeVariable(_ name:String){
        varDictio = varDictio.filter({$0.name != name})
    }
    
    func getVarValue(_ name:String, _ askingLine: Int) -> Any {
        
        
        // Variable exists
        
        if varDictio.filter({$0.name == name}).count > 0 {
            
            let found = varDictio.filter({$0.name == name})[0]
            
            // Variable exists but ref is already in dictio
            if (found.references.contains(askingLine)) {
                
                // Variable exists but it's from askingLine
                if found.references.first == askingLine {
                    return name
                } else {
                    found.addReference(askingLine)
                }
            } else {
                found.addReference(askingLine)
            }
            return found.value
        }
        return name
    }
    
    // Data stuff
    
    func convertForSave() -> String {
        var converted = ""
        converted.append("\(index)|||")
        converted.append("\(activeCell)|||")
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
        
        for v in varDictio {
            converted.append("€€€\(v.convertForSave())")
        }
        
        return converted
    }
    
    init (forLoad s:String) {
        
        let containsVars:Int
        if s.contains("€€€") {containsVars = 2} else {containsVars = 1}
        
        let t = s.components(separatedBy: "|||")
        if t == [] {
            self.index = 0
            self.activeCell = 0
            self.lines = [Line(at: 0, inNote:index)]
            self.varDictio = []
        } else {
            self.index = Int(t[0])!
            self.activeCell = Int(t[1])!
            var l:[Line] = []
            for line in t[2...(t.count-containsVars)] {
                let brokenLine:[String] = line.components(separatedBy: "ÇÇÇ")
                if let test:Int = Int(brokenLine[0]) {
                    let ll = Line(at: test, inNote: index)
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
        
        var futurVD:[(Variable)] = []
        
        if containsVars == 2 {
            
            let vt:[String] = t[t.count-1].components(separatedBy: "€€€")
            
            for v in vt {
                
                if v != ""{
                    futurVD.append(Variable(forLoad: v))
                }
            }
        }
        
        varDictio = futurVD
        print(futurVD)
        
    }
    
    func saveVariable(_ name: String, _ value: Double,_ askingLine:Int) {
        
        if varDictio.contains(where: {$0.name == name}) {
            if let oldVar = varDictio.first(where: {$0.name == name}) {
                oldVar.value = value
                oldVar.references.remove(at: 0)
                oldVar.addReference(askingLine)
            }
            
        } else {
            let newVar = Variable(name,value)
            newVar.addReference(askingLine)
            varDictio.append(newVar)
            getLine(at: askingLine).variableDeclared = name
        }
        
    }
    
}
