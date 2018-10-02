//
//  FoodItemMO+CoreDataProperties.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 26/09/2018.
//  Copyright © 2018 DiabHelp. All rights reserved.
//
//

import Foundation
import CoreData


extension FoodItemMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodItemMO> {
        return NSFetchRequest<FoodItemMO>(entityName: "FoodItem")
    }

    @NSManaged public var glucidicQuantity: Float
    @NSManaged public var kCalQuantity: Float
    @NSManaged public var name: String!
    @NSManaged public var weight: Float
    @NSManaged public var foodList: FoodListMO?

}
