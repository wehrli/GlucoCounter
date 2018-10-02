//
//  FoodListMO+CoreDataProperties.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 26/09/2018.
//  Copyright © 2018 DiabHelp. All rights reserved.
//
//

import Foundation
import CoreData


extension FoodListMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodListMO> {
        return NSFetchRequest<FoodListMO>(entityName: "FoodList")
    }

    @NSManaged public var isCurrent: Bool
    @NSManaged public var name: String!
    @NSManaged public var totalglucidic: Float
    @NSManaged public var totalkcal: Float
    @NSManaged public var totalweight: Float
    @NSManaged public var foods: NSSet?

}

// MARK: Generated accessors for foods
extension FoodListMO {

    @objc(addFoodsObject:)
    @NSManaged public func addToFoods(_ value: FoodItemMO)

    @objc(removeFoodsObject:)
    @NSManaged public func removeFromFoods(_ value: FoodItemMO)

    @objc(addFoods:)
    @NSManaged public func addToFoods(_ values: NSSet)

    @objc(removeFoods:)
    @NSManaged public func removeFromFoods(_ values: NSSet)

}
