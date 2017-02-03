//
//  ClavierView.swift
//  Numbr
//
//  Created by Derr McDuff on 17-02-01.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

class ClavierView: UIView {
    
    @IBOutlet var numberKeys: [UIButton]!
    @IBOutlet var otherKeys: [UIButton]!
    
    func parentViewController()-> NoteController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? NoteController {
                return viewController
            }
        }
        return nil
    }


    @IBAction func touchNumberKey(_ sender: UIButton) {
        
        let pv = self.parentViewController()
        let ac = (pv?.activeCell)!
        if let p = pv?.aTableView.cellForRow(at: IndexPath(row: ac, section: 0)) as? LineTableViewCell {
            let field = p.content!
            let newChar = sender.titleLabel?.text ?? ""
            if numberKeys.contains(sender) {
                field.text?.append("\(newChar)")
            } else if otherKeys.contains(sender){
                switch newChar {
                case "del":
                    field.text! = String(field.text!.characters.dropLast(1))
                case "v":
                    pv?.switchLine(field)
                    pv?.continuousEditing(field)
                case "sub":
                    field.text?.append("-")
                case "mul":
                    field.text?.append("*")
                case "div":
                    field.text?.append("/")
                case "add":
                    field.text?.append("+")
                case "abc":
                    field.isUserInteractionEnabled = true
                    field.becomeFirstResponder()
                default:
                    print("lol")
                    field.text?.append("\(newChar)")
                }
            }
            pv?.passedNote.getLine(at: ac).content = field.text!
        }
        
        
        
    }

    
}
