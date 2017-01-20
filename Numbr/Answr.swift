//
//  Answr.swift
//  Numbr
//
//  Created by Derr McDuff on 17-01-16.
//  Copyright © 2017 anonymous. All rights reserved.
//
import Foundation
import UIKit


@IBDesignable
class Answr: UILabel {

    
    @IBInspectable var cornerRadius:CGFloat = 5 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    let originPos: CGPoint = CGPoint(x:CGFloat(280), y:CGFloat(20))
    let originSize: CGSize = CGSize(width: 70, height: 30)
    
    @IBInspectable var position:CGPoint = CGPoint(x:CGFloat(280), y:CGFloat(20)) {
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
        self.layer.borderWidth = 0.5
        
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    

}
