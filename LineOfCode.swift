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
    @IBOutlet var lineAns: Answr!
    
    var indexProp:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let panning = UIPanGestureRecognizer (
            target: self,
            action:#selector(LineOfCode.reveal)
        )

        self.lineAns.addGestureRecognizer(panning)
        
    }
    
    
    
    func reveal(_ sender:UIPanGestureRecognizer) {
        
        if let ta = sender.view as? Answr {
            switch sender.state {
            case UIGestureRecognizerState.changed,
                 UIGestureRecognizerState.began:
                
                let delta = sender.translation(in: contentView).x-70
                ta.bounds.size.width = delta
                ta.translatesAutoresizingMaskIntoConstraints = true
                ta.center = CGPoint(x:245+(delta/2)+70, y: ta.center.y)
            case UIGestureRecognizerState.ended:
                
                // TODO: This v
//                let from: CGPoint = CGPoint(x: ta.layer.position.x, y: ta.layer.position.y)
//                let to: CGPoint = CGPoint(x: 290, y: ta.layer.position.y)
//                let position = CABasicAnimation(keyPath: "position")
//                position.isAdditive = true
//                position.fromValue = from
//                position.toValue = to
//                position.duration = 0.3
//                ta.layer.add(position, forKey: "pos")
                
                
                ta.center = ta.originPos
                ta.bounds.size = ta.originSize
                
            default:
                print("nothing")
            }
        }
    }
    
    func unselected() {
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
