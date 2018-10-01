//
//  DBManager.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 06/08/2018.
//  Copyright © 2018 DiabHelp. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DBManager {

    private let appDelegate: AppDelegate
    private let context: NSManagedObjectContext
    
    public init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    public func getAllFoodName() -> [String] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RawFood")
        fetchRequest.propertiesToFetch = ["food_name_fr"]
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        var elemToReturn = [String]()
        
        do {
            let listOfName = try context.fetch(fetchRequest) as! [[String: String]]
            for r in listOfName {
                elemToReturn.append(r["food_name_fr"]!)
            }
            return elemToReturn
        } catch {
            print("error on fetching all food name")
        }
        return []
    }
    
    public func fetchRequestor(fetchRequest: NSFetchRequest<NSFetchRequestResult>, predicate: NSPredicate) -> [Any] {
        if (predicate != nil) {
            print("je suis pas null")
            fetchRequest.predicate = predicate
        }
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Error on fetch request")
        }
        return []
    }
//
//    public func Write() {
//
//    }

    public func getContext() -> NSManagedObjectContext {
        return context
    }
    
    public func Save() {
        do {
            try context.save()
        } catch {
            print("[DBManager] - save context failed")
        }
    }
    
    class var sharedInstance: DBManager {
        //2
        struct Singleton {
            //3
            static let instance = DBManager()
        }
        //4
        return Singleton.instance
    }
}
