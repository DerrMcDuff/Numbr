//
//  LineTableViewCell.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-23.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit


class LineTableViewCell: UITableViewCell {
    
    @IBOutlet var index: UILabel!
    @IBOutlet var content: UITextField!
    @IBOutlet var answer: AnswerLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let panning = UIPanGestureRecognizer (
            target: self,
            action:#selector(LineTableViewCell.reveal)
        )
        
        self.answer.addGestureRecognizer(panning)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    
    
    func reveal(_ sender:UIPanGestureRecognizer) {
        
        if let ta = sender.view as? AnswerLabel {
            switch sender.state {
            case UIGestureRecognizerState.changed,
                 UIGestureRecognizerState.began:
                
                var delta: CGFloat
                if sender.translation(in: contentView).x < 0 {
                    delta = sender.translation(in: contentView).x-70
                    ta.bounds.size.width = delta
                    ta.translatesAutoresizingMaskIntoConstraints = true
                    ta.position = CGPoint(x:ta.originPos.x+(delta/2)+ta.originSize.width/2, y: ta.originPos.y)
                }
            case UIGestureRecognizerState.ended:
                
                ta.position = ta.originPos
                ta.bounds.size = ta.originSize
                
            default:
                print("nothing")
            }
        }
    }
    
    
    
}
