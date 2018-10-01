//
//  ResultDiabetValues.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 18/08/2018.
//  Copyright © 2018 DiabHelp. All rights reserved.
//

import Foundation

class ResultDiabetValues {
    var glucidicQuantity: Float!
    var kCalQuantity: Float!
    var totalWeight: Float!
    
    init(glucid: Float, kCal: Float, weight: Float) {
        self.glucidicQuantity = glucid
        self.kCalQuantity = kCal
        self.totalWeight = weight
    }
}
