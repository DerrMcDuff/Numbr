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
        
    }
    
    func saveData() {
        
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "activeNote")
        defaults.removeObject(forKey: "notes")
        
        defaults.set(activeNote, forKey: "activeNote")
        
        var convertedNode:[String] = []
        for note in notes {
            convertedNode.append(note.convertForSave())
        }
        defaults.set(convertedNode, forKey: "notes")
        
    }
    
    
    //-----------------------------------------------------
    
    
        
    
}

