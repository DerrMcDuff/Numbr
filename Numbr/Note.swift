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
        var fetchedRefs = getReferences(from: i)
        
        for ref in fetchedRefs {
            let feedback = lines[ref].setAnswer()
            for f in feedback {
                if f.0 == "Add" {
                    saveVariable(f.1.name,f.1.value,f.1.references[0])
                    
                } else if f.0 == "Remove" {
                    
                    removeVariable(f.1.name)
                }
            }
        }
        
        fetchedRefs = getReferences(from: i)
        return fetchedRefs
        
    }
    
    func getReferences(from i: Int) -> [Int] {
        
        if (self.lines[i].variableDeclared != nil) {
            let x = varDictio.index(where: {$0.name == self.lines[i].variableDeclared!})
            print("the refs fro getrefs\(varDictio[x!].references)")
            return varDictio[x!].references
        } else {
            return [i]
        }
        
    }
    
    // Var stuff
    
    func removeVariable(_ name:String){
        app.allData.notes[index].varDictio = app.allData.notes[index].varDictio.filter({$0.name != name})
    }
    
    func getVarValue(_ name:String, _ askingLine: Int) -> Any {
        
        let app = UIApplication.shared.delegate as! AppDelegate
        
        // Variable exists
        
        if app.allData.notes[index].varDictio.filter({$0.name == name}).count > 0 {
            
            let found = app.allData.notes[index].varDictio.index(where: {$0.name == name})!
            
            // Variable exists but ref is already in dictio
            if (app.allData.notes[index].varDictio[found].references.contains(askingLine)) {
                
                // Variable exists but it's from askingLine
                if app.allData.notes[index].varDictio[found].references.first == askingLine {
                    return name
                } else {
                    app.allData.notes[index].varDictio[found].addReference(askingLine)
                }
            } else {
                app.allData.notes[index].varDictio[found].addReference(askingLine)
            }
            return app.allData.notes[index].varDictio[found].value
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
        
        print(converted)
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
        
    }
    
    func saveVariable(_ name: String, _ value: Double,_ askingLine:Int) {
        
        if varDictio.contains(where: {$0.name == name}) {
            if let oldVarI = varDictio.index(where: {$0.name == name}) {
                varDictio[oldVarI].value = value
                varDictio[oldVarI].references.removeFirst(1)
                varDictio[oldVarI].addReference(askingLine)
            }
            
        } else {
            let newVar = Variable(name,value)
            newVar.addReference(askingLine)
            varDictio.append(newVar)
            getLine(at: askingLine).variableDeclared = name
        }
        
    }
    
}
