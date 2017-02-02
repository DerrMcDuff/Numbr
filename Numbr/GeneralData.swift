//
//  GeneralData.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-21.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation

class GeneralData /*: NSObject, NSCoding */ {
    
    var activeNote:Int = 0
    
    var notes:[Note] = [Note(at:0)]
    
    var varDictio:[String:(Variable)] = [:]
    
    
    
    
    
    // Data managing ------------------------------------------
    
    func loadData() {
        let defaults = UserDefaults.standard
        activeNote = defaults.integer(forKey: "activeNote") 
        
        if let rawNotes:[String] = defaults.stringArray(forKey:"notes") {
            var convertedNotes:[Note] = []
            for n in rawNotes {
                convertedNotes.append(Note(forLoad:n))
            }
            notes = convertedNotes
        } else {
            notes = [Note(at:0)]
        }
        
        if let rawDictio:[String] = defaults.stringArray(forKey: "varDictio") {
            
            var convertedDictio:[String:Variable] = [:]
            for e in rawDictio {
                let key = (e.components(separatedBy: "&&&"))[0]
                convertedDictio.updateValue(Variable(forLoad:e), forKey: key)
            }
            app.allData.varDictio = convertedDictio
        }
        
        
    }
    
    func saveData() {
        
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "activeNote")
        defaults.removeObject(forKey: "notes")
        defaults.removeObject(forKey: "varDictio")
        
        defaults.set(activeNote, forKey: "activeNote")
        
        var convertedNode:[String] = []
        for note in notes {
            convertedNode.append(note.convertForSave())
        }
        defaults.set(convertedNode, forKey: "notes")
        
        var rawDictio:[String] = []
        for v in varDictio {
            rawDictio.append(v.value.convertForSave())
        }
        if !rawDictio.isEmpty {
            defaults.set(rawDictio, forKey: "varDictio")
        }
        
        
    }
    
    
    //-----------------------------------------------------
    
    
    // Variable stuff -------------------------------------
    
    func saveVariable(_ name: String, _ value: Double,_ askingLine:Int) {

        if varDictio[name] != nil {
            let oldVar = varDictio[name]!
            oldVar.value = value
            oldVar.references.removeFirst()
            oldVar.addReference(askingLine)
            varDictio.updateValue(oldVar, forKey: name)
        } else {
            let newVar = Variable(name,value)
            newVar.addReference(askingLine)
            self.varDictio.updateValue(newVar, forKey: name)
            self.notes[activeNote].getLine(at: askingLine).variableDeclared = name
        }
        
    }
    
    func removeVariable(_ name:String){
        varDictio.removeValue(forKey: name)
    }
    
    func getVarValue(_ name:String, _ askingLine: Int) -> Any {
        
        // Variable exists
        if varDictio[name] != nil {
            
            // Variable exists but ref is already in dictio
            if (varDictio[name]?.references.contains(askingLine))! {
                
                // Variable exists but it's from askingLine
                if varDictio[name]?.references.first == askingLine {
                    return name
                } else {
                    varDictio[name]!.addReference(askingLine)
                }
            } else {
                varDictio[name]!.addReference(askingLine)
            }
            return varDictio[name]!.value
        }
        return name
        
    }
    
    
}

