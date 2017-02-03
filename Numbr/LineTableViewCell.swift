//
//  LineTableViewCell.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-23.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

// UI representation of a note line
class LineTableViewCell: UITableViewCell {
    
    // UI Variables
    
    // Index of line in aTableView
    @IBOutlet var index: UILabel!
    // Content of the line
    @IBOutlet var content: UITextField!
    // Answer of the line
    @IBOutlet var answer: AnswerLabel!
    
    
    // Interaction with the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set PanGesture on cell
        let panning:UIPanGestureRecognizer = UIPanGestureRecognizer (
            target: self,
            action: #selector(LineTableViewCell.reveal)
        )
        self.answer.addGestureRecognizer(panning)
    }
    
    // Expands UI Label when panning
    func reveal(_ sender:UIPanGestureRecognizer) {
        
        // Recognizes the sender as UILabel
        if let ta:AnswerLabel = sender.view as? AnswerLabel {
            
            // Recognizes the possible states of the dragging
            switch sender.state {
                
            // Panning is in progress
            case UIGestureRecognizerState.changed, UIGestureRecognizerState.began:
                
                // Will keep track of horizontal delta
                var delta: CGFloat
                
                // Makes sure it doesn't collapse and only expands
                if sender.translation(in: contentView).x < 0 {
                    
                    // Coordinates the expansion of the AnswerLabel
                    delta = sender.translation(in: contentView).x-70
                    ta.bounds.size.width = delta
                    ta.translatesAutoresizingMaskIntoConstraints = true
                    ta.position = CGPoint(x:ta.originPos.x+(delta/2)+ta.originSize.width/2, y: ta.originPos.y)
                    
                }
                
            // Panning has ended
            case UIGestureRecognizerState.ended:
                
                // AnswerLabel goes back to base form
                ta.position = ta.originPos
                ta.bounds.size = ta.originSize
                
                
            default:
                print("nothing")
            }
        }
    }
    
    
    
}
