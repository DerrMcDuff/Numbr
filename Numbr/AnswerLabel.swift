//
//  AnswerLabel.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-23.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class AnswerLabel: UILabel {
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    let originPos: CGPoint = CGPoint(x:CGFloat(281), y:CGFloat(16.5))
    let originSize: CGSize = CGSize(width: 75, height: 30)
    
    @IBInspectable var position:CGPoint = CGPoint(x:CGFloat(281), y:CGFloat(16.5)) {
        didSet {
            self.layer.position.x = position.x
            self.layer.position.y = position.y
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.drawText(in: rect)
        
        let image = UIImage(named: "handle.png")
        var handle: UIImageView?
        handle = UIImageView(image: image)
        handle!.frame = CGRect(x: self.bounds.minX, y: self.bounds.minY+2, width: 10, height: self.bounds.height-4)
        handle?.isOpaque = true
        
        self.addSubview(handle!)
        self.roundCorners(corners: [.topLeft,.bottomLeft], radius: 5.0)
    }

}

extension UILabel {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
    }
}
