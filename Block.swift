//
//  Block.swift
//  Numbr
//
//  Created by Derr McDuff on 16-12-29.
//  Copyright © 2016 anonymous. All rights reserved.
//

import Foundation

class Block {
    private var lines:[(Line)]
    
    init() {
        lines = []
        let line1 = Line(0)
        let line2 = Line(1)
        let line3 = Line(2)
        let line4 = Line(3)
        let line5 = Line(4)
        let line6 = Line(5)
        self.lines.append(line1)
        self.lines.append(line2)
        self.lines.append(line3)
        self.lines.append(line4)
        self.lines.append(line5)
        self.lines.append(line6)
    }
    
    func getNumberOfLines() -> Int {
        return lines.count
    }
    
    func setLineAns(at index:Int, with this:String) {
        
        lines.filter{ $0.id == index }.first!.fill(this)
    }
    
    func getLineAns(at index:Int)->String {
        return (lines.filter{ $0.id == index }.first!.getAnswer())
    }
    
    func setLineCon(at index:Int, with this:String) {
        lines.filter{ $0.id == index }.first!.setContent(this)
    }
    
    func getLineCon(at index:Int)->String {
        return (lines.filter{ $0.id == index }.first!.getContent())
    }
    
    func newLine() {
        let newLine = Line(lines.count)
        self.lines.append(newLine)
    }
}
