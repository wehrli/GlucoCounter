//
//  FoodItem.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 07/08/2018.
//  Copyright © 2018 DiabHelp. All rights reserved.
//

import Foundation

class FoodItem {
    var title: String!
    var quantity: Double!
    var glucide: Double!
    var total: Double!
    
    init(title: String, quantity: Double, glucide: Double, total: Double) {
        self.title = title
        self.quantity = quantity
        self.glucide = glucide
        self.total = total
    }
}
