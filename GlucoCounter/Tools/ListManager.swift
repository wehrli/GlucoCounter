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
    
    private var favoriteListFood: [FoodListMO]
    private var actualListFood: FoodListMO
    private var actualMainValue: ResultDiabetValues
    
    public init() {
        favoriteListFood = []
        actualListFood = FoodListMO(context: DBManager.sharedInstance.getContext())
        actualListFood.isCurrent = true
        actualListFood.name = ""
        actualMainValue = ResultDiabetValues(glucid: 0, kCal: 0, weight: 0)
        actualListFood.totalkcal = actualMainValue.kCalQuantity
        actualListFood.totalweight = actualMainValue.totalWeight
        actualListFood.totalglucidic = actualMainValue.glucidicQuantity
    }
    
    public func calculeResultDiabetValues() -> ResultDiabetValues {
        actualMainValue = ResultDiabetValues(glucid: 0, kCal: 0, weight: 0)
    
        for elem in actualListFood.foods?.allObjects as! [FoodItemMO] {
            actualMainValue.glucidicQuantity = actualMainValue.glucidicQuantity + elem.glucidicQuantity
            actualMainValue.kCalQuantity = actualMainValue.kCalQuantity + elem.kCalQuantity
            actualMainValue.totalWeight = actualMainValue.totalWeight + elem.weight
        }
        return actualMainValue
    }
    
    public func getListFavorite() -> [FoodListMO] {
        
        // Creation fetchRequestor and add some filter
        let fetchRequestor = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodList")
        fetchRequestor.predicate = NSPredicate(format: "isCurrent == %@", "0")
        
        //execution of the request
        do {
            favoriteListFood = try DBManager.sharedInstance.getContext().fetch(fetchRequestor) as! [FoodListMO]
            
        } catch {
            fatalError("Failed to fetch Favorite list: \(error)")
        }
        print("------------------------------------------")
        print(favoriteListFood)
        print("------------------------------------------")
        return favoriteListFood
    }
    
    public func getListFood() -> [FoodItemMO] {
        return actualListFood.foods?.allObjects as! [FoodItemMO]
    }
    
    public func addFoodToActualList(food: FoodItemMO) {
        actualListFood.addToFoods(food)
    }
    
    public func addFoodListToFavorite(name: String, diabetValues: ResultDiabetValues) {
        // TODO:
        let tmpNewList = FoodListMO(context: DBManager.sharedInstance.getContext())
        tmpNewList.isCurrent = false
        tmpNewList.name = name
        tmpNewList.totalglucidic = diabetValues.glucidicQuantity
        tmpNewList.totalweight = diabetValues.totalWeight
        tmpNewList.totalkcal = diabetValues.kCalQuantity
        tmpNewList.foods = actualListFood.foods

        DBManager.sharedInstance.Save()
    }
    
//    public func setFavoriteToActual(foodList: [FoodItem]) {
//        actualListFood.removeAll()
//        actualListFood = foodList
//    }
    
    public func removeFoodToActualList(nameFood: String) {
//        var idx = -1
//        for (index, value) in actualListFood.enumerated() {
//            if (value.title == nameFood) {
//                idx = index
//            }
//        }
//        
//        if (idx != -1) {
//            actualListFood.remove(at: idx)
//        } else {
//            print("food is not in the list")
//        }
        
    }
    
    public func removeFoodToFavoriteList(nameList: String) {
//        var idx = -1
//        for (index, value) in favoriteListFood.enumerated() {
//            if (value.name == nameList) {
//                idx = index
//            }
//        }
//
//        if (idx != -1) {
//            favoriteListFood.remove(at: idx)
//        } else {
//            print("food is not in the list")
//        }
        
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
