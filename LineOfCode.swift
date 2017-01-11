//
//  LineOfCode.swift
//  Numbr
//
//  Created by Derr McDuff on 16-12-29.
//  Copyright © 2016 anonymous. All rights reserved.
//

import Foundation
import UIKit

class LineOfCode: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var lineIndex: UILabel!
    @IBOutlet var lineContent: UITextField!
    @IBOutlet var lineAns: UILabel!
    
    var indexProp:Int = 0
    
    @IBAction func unselected(_ sender: UITextField) {
        let i = Int(lineIndex.text!)
        let c = lineContent.text
        data.nowBlock.setLineCon(at: i!, with: c!)
        data.nowBlock.setLineAns(at: i!, with: c!)
    }
    
    
    func lineManaging() -> Bool {
        let i = Int(lineIndex.text!)
        let c = lineContent.text
        data.nowBlock.setLineCon(at: i!, with: c!)
        data.nowBlock.setLineAns(at: i!, with: c!)
        
        if (i == data.nowBlock.getNumberOfLines()-1) {
            data.nowBlock.newLine()
            return true
        }
        return false
    }
    
}
