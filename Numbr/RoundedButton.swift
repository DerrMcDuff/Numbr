//
//  RoundedButton.swift
//  tabShortcuts
//
//  Created by Derr McDuff on 17-02-08.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
