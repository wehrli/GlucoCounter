//
//  ListManager.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 13/08/2018.
//  Copyright © 2018 DiabHelp. All rights reserved.
//

import Foundation
import CoreData

class ListManager {
    
    private var favoriteListFood: [FoodList]
    private var actualListFood: [Food]
    
    public init() {
        favoriteListFood = []
        actualListFood = []
    }
    
    public func getListFavorite() -> [FoodList] {
        let foodList = DBManager.sharedInstance.fetchRequestor(fetchRequest: NSFetchRequest<Food>(entityName: "FoodList") as! NSFetchRequest<NSFetchRequestResult>, predicate: NSPredicate()) as! [FoodList]
        
        print(foodList)
        favoriteListFood = foodList
        return foodList
    }
    
    public func getListFood() -> [Food] {
        return actualListFood
    }
    
    public func addFoodToActualList(food: Food) {
        actualListFood.append(food)
    }
    
    public func removeFoodToActualList(nameFood: String) {
        var idx = -1
        for (index, value) in actualListFood.enumerated() {
            if (value.food_name_fr == nameFood) {
                idx = index
            }
        }
        
        if (idx != -1) {
            actualListFood.remove(at: idx)
        } else {
            print("food is not in the list")
        }
        
    }
    
    class var sharedInstance: ListManager {
        //2
        struct Singleton {
            //3
            static let instance = ListManager()
        }
        //4
        return Singleton.instance
    }
    
}
