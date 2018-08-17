//
//  AddFoodView.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 20/11/2017.
//  Copyright © 2017 DiabHelp. All rights reserved.
//

import UIKit

@IBDesignable class AddFoodView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
        
}
