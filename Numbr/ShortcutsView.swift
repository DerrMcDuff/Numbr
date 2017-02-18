//
//  ShortcutsView.swift
//  tabShortcuts
//
//  Created by Derr McDuff on 17-02-06.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

var kbH:CGFloat = 0

class ShortcutsView: UIView {
    
    var localShortCuts:[String] = []
    var origin:CGFloat
    var kbIcon:UIButton!
    
    init(_ o:CGFloat) {
        
        origin = o
        
        let panelRect:CGRect = CGRect(x: Double(0), y: Double(origin), width: Double(UIScreen.main.bounds.width), height: Double(40))
        super.init(frame: panelRect)
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize.init(width: 0, height: -5)
        
        let image = UIImage(named: "popKeyboard.png")
        kbIcon = UIButton(type: .custom)
        kbIcon.setBackgroundImage(image, for: .normal)
        kbIcon.frame = CGRect(x: self.bounds.maxX-40, y: self.bounds.minY+8, width: 30, height: 27)
        kbIcon.addTarget(self, action: #selector(self.popKeyboard), for: .touchUpInside)
        self.addSubview(kbIcon)
        
        refreshShortcuts()
    }
    
    
    func refreshShortcuts() {
        
        var contentWidth:CGFloat = 0
        var buttons:[RoundedButton] = []
        

        
        if let pc = self.parentViewController() {
            let group = pc.passedNote.varDictio
            
            for (i,one) in localShortCuts.enumerated() {
                if !group.contains(where: {$0.name == one}) {
                    self.subviews.filter({
                        if let b = $0 as?UIButton {
                            return b.titleLabel?.text == one
                        }
                        return false
                    }).first!.removeFromSuperview()
                    localShortCuts.remove(at: i)
                }
            }
            
            for sall in group {
                
                let s = sall.name
                
                if localShortCuts.contains(s) {
                    
                    let found = (self.subviews.filter({
                        if let this = $0 as? RoundedButton {
                            if this.titleLabel!.text == s {
                                return true
                            }
                        }
                        return false
                    })[0])
                    
                    buttons.append((found as! RoundedButton))
                    contentWidth += found.bounds.width
                    continue
                }
                
                let newButton:RoundedButton = RoundedButton(frame: CGRect(x: UIScreen.main.bounds.width, y: 4 , width: 30, height: 30))
                newButton.setTitle(s, for: .normal)
                if newButton.titleLabel!.text!.characters.count > 2 {
                    newButton.sizeToFit()
                }
                contentWidth += newButton.bounds.width
                newButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                newButton.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
                newButton.addTarget(self, action: #selector(ShortcutsView.buttonTapped(_:)), for: .touchUpInside)
                
                if contentWidth > UIScreen.main.bounds.width - 80 {
                    contentWidth -= newButton.bounds.width
                    break
                } else {
                    buttons.append(newButton)
                }
            }
            
            let c:Double = Double(buttons.count)
            let blank = (UIScreen.main.bounds.width-30-contentWidth)/(CGFloat(c+1))
            var cumulativeWidth:CGFloat = 0
            var newPos:[(CGFloat)] = []
            
            for (index,b) in buttons.enumerated() {
                
                let wasShortcut = localShortCuts.contains(b.titleLabel!.text!)
                
                if !wasShortcut {
                    self.addSubview(b)
                    localShortCuts.append(b.titleLabel!.text!)
                }
                
                let thisButtonWidth = b.bounds.width
                
                cumulativeWidth += thisButtonWidth
                
                let p1 =  blank*(CGFloat(index+1))
                
                let p2 = cumulativeWidth - (thisButtonWidth/2)
                
                let sum = p1+p2
                newPos.append(sum)
                
            }
            
            
            UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseInOut, animations: {
                for (i,b) in buttons.enumerated() {
                    b.layer.position.x = newPos[i]
                    b.layer.position.y = 20
                }
            }, completion: nil)
            
            
            print("------")
        }
    }
    
    enum location {
        case overKeyboard
        case origin
    }
    
    func moveTo(_ l:location) {
        
        UIView.animate(withDuration: 0.2, delay: 0.01, options: .curveEaseOut, animations: {
            switch l {
            case .overKeyboard:
                self.layer.position.y = UIScreen.main.bounds.height - kbH - self.bounds.size.height/2
                self.kbIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            case .origin:
                print(self.origin)
                self.layer.position.y = self.origin + 20
                self.kbIcon.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            }
        }, completion: nil)
        
        
    }
    
    func buttonTapped(_ sender:UIButton!) {
        let pv = self.parentViewController()
        let ac = (pv?.activeCell)!
        if let p = pv?.aTableView.cellForRow(at: IndexPath(row: ac, section: 0)) as? LineTableViewCell {
            let field = p.content!
            let newChar = sender.titleLabel?.text ?? ""
            field.text?.append("\(newChar)")
            pv?.passedNote.getLine(at: ac).content = field.text!
        }

    }
    
    func popKeyboard() {
        let pv = self.parentViewController()
        let ac = (pv?.activeCell)!
        if let p = pv?.aTableView.cellForRow(at: IndexPath(row: ac, section: 0)) as? LineTableViewCell {
            let field = p.content!
            if (field.isUserInteractionEnabled) {
                field.resignFirstResponder()
            } else {
                field.isUserInteractionEnabled = true
                field.becomeFirstResponder()
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
