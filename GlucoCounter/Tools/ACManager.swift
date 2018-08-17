//
//  CSVManager.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 06/08/2018.
//  Copyright © 2018 DiabHelp. All rights reserved.
//

import Foundation
import CoreData
import CSV

class ACManager {
    private var version: String
    private let streamerCSV: CSVReader
    //private let dbContext: NSManagedObjectContext
    
    public init(elemToRead: String, separator: UnicodeScalar) {
        
        do {
            version = ""

            //Open and get stream of a file
            let stream = InputStream(fileAtPath: Bundle.main.path(forResource: elemToRead, ofType: "csv")!)
            
            //Get pointer on begining of the file parsed
            streamerCSV = try! CSVReader(stream: stream!, delimiter: separator)
            
        } catch {
            print("[ACManager] init() -> Error on opening file")
        }
        
    }
    /*
     **  return values : 1 -> saved new list in db, 0 -> List up to date nothing change, -1 -> error on execution
    */
    public func process() -> Int8 {
        //Get version of the list in DB
        getVersion()

        while let row = streamerCSV.next() {
            if (row[0] == "Version") {
                if (version == row[1]) { return 0 }
                
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
                let requestDeleteFood = NSBatchDeleteRequest(fetchRequest: fetch)
                
                do {
                    try DBManager.sharedInstance.getContext().execute(requestDeleteFood)
                } catch {
                    print("error on delete old sources")
                }
                
                setVersion(newVersionList: row[1])
                
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "Food", in: DBManager.sharedInstance.getContext())
                let newFood = NSManagedObject(entity: entity!, insertInto: DBManager.sharedInstance.getContext())
                
                setObjectInDatabase(newFood: newFood, row: row)
            }
            
            do {
                //TODO : See if we will let this or just had an instance of DBManager
                try DBManager.sharedInstance.Save()
            } catch {
                print("errror on save context")
            }
        }
        return 1
    }
    
    private func setObjectInDatabase(newFood: NSManagedObject, row: [String]) {
        newFood.setValue(row[0], forKey: "food_name_eng")
        newFood.setValue(row[1], forKey: "food_name_fr")
        newFood.setValue(row[2], forKey: "kj")
        newFood.setValue(row[3], forKey: "kcal")
        newFood.setValue(row[4], forKey: "water")
        newFood.setValue(row[5], forKey: "protein")
        newFood.setValue(row[6], forKey: "carbohydrate")
        newFood.setValue(row[7], forKey: "fat")
        newFood.setValue(row[8], forKey: "sugars")
        newFood.setValue(row[9], forKey: "starch")
        newFood.setValue(row[10], forKey: "fibres")
        newFood.setValue(row[11], forKey: "polyols")
        newFood.setValue(row[12], forKey: "ash")
        newFood.setValue(row[13], forKey: "alcohol")
        newFood.setValue(row[14], forKey: "organic_acids")
        newFood.setValue(row[15], forKey: "fa_saturated")
        newFood.setValue(row[16], forKey: "fa_mono")
        newFood.setValue(row[17], forKey: "fa_poly")
        newFood.setValue(row[18], forKey: "cholesterol")
        newFood.setValue(row[19], forKey: "calcium")
        newFood.setValue(row[20], forKey: "chloride")
        newFood.setValue(row[21], forKey: "copper")
        newFood.setValue(row[22], forKey: "iron")
        newFood.setValue(row[23], forKey: "iodine")
        newFood.setValue(row[24], forKey: "magnesium")
        newFood.setValue(row[25], forKey: "manganese")
        newFood.setValue(row[26], forKey: "phosphorus")
        newFood.setValue(row[27], forKey: "potassium")
        newFood.setValue(row[28], forKey: "selenium")
        newFood.setValue(row[29], forKey: "sodium")
        newFood.setValue(row[30], forKey: "zinc")
        newFood.setValue(row[31], forKey: "retinol")
        newFood.setValue(row[32], forKey: "beta_carotene")
        newFood.setValue(row[33], forKey: "vitamin_d")
        newFood.setValue(row[34], forKey: "vitamin_e")
        newFood.setValue(row[35], forKey: "vitamin_k1")
        newFood.setValue(row[36], forKey: "vitamin_k2")
        newFood.setValue(row[37], forKey: "vitamin_c")
        newFood.setValue(row[38], forKey: "vitamin_b1")
        newFood.setValue(row[39], forKey: "vitamin_b2")
        newFood.setValue(row[40], forKey: "vitamin_b3")
        newFood.setValue(row[41], forKey: "vitamin_b5")
        newFood.setValue(row[42], forKey: "vitamin_b6")
        newFood.setValue(row[43], forKey: "vitamin_b9")
        newFood.setValue(row[44], forKey: "vitamin_b12")
    }
    
    private func getVersion() {
        
        //TODO : See if it is possible to reduce this part, instance of DBManager instead of just the context ?
        let fetchRequest = NSFetchRequest<VersionPlateList>(entityName: "VersionPlateList")
        let sort = NSSortDescriptor(key: #keyPath(VersionPlateList.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchLimit = 1
        
        do {
            //TODO : see if it is possible to get directly the object
            let versionResponse = try DBManager.sharedInstance.getContext().fetch(fetchRequest) as [VersionPlateList]
            version = versionResponse[0].version! //if not any save data in db what happend ?
        } catch {
            print("fetch problem")
        }
    }
    
    private func setVersion(newVersionList: String) {
        let entity = NSEntityDescription.entity(forEntityName: "VersionPlateList", in: DBManager.sharedInstance.getContext())
        let newVersion = NSManagedObject(entity: entity!, insertInto: DBManager.sharedInstance.getContext())
        
        newVersion.setValue(newVersionList, forKey: "version")
        newVersion.setValue(Date(), forKey: "date")
    }
}
