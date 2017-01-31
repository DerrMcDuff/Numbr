//
//  Variable.swift
//  Numbr
//
//  Created by Derr McDuff on 17-01-29.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation


class Variable {
    
    let name: String
    var value: Double
    var references: [Int] = []
    
    
    init(_ n:String, _ v:Double) {
        self.name = n
        self.value = v
    }
    
    func addReference(_ i:Int) {
        
        guard references.contains(i) else {
            references.append(i)
            references = references.sorted()
            return
        }
        
        
    }
    
    func removeReference(_ i: Int) {
        references = references.filter({$0 != i})
    }
    
    
    func convertForSave() -> String {
        var converted = "\(name)&&&\(value)"
        for reference in references {
            converted.append("&&&\(reference)")
        }
        return converted
    }
    
    
    init(forLoad s:String) {
        let t = s.components(separatedBy: "&&&")
        
        self.name = t[0]
        self.value = Double(t[1])!
        
        var refsToLoad:[Int] = []
        
        for reference in t.dropFirst(2) {
            refsToLoad.append(Int(reference)!)
        }
        
        self.references = refsToLoad
    }
    
    func printVariable() {
        print("\(self.name) will update : \(self.references)")
    }
}
