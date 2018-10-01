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
                
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RawFood")
                let requestDeleteFood = NSBatchDeleteRequest(fetchRequest: fetch)
                
                do {
                    try DBManager.sharedInstance.getContext().execute(requestDeleteFood)
                } catch {
                    print("error on delete old sources")
                }
                
                setVersion(newVersionList: row[1])
                
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "RawFood", in: DBManager.sharedInstance.getContext())
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
        print("ecriture")
        return 1
    }
    
    private func setObjectInDatabase(newFood: NSManagedObject, row: [String]) {
        newFood.setValue(row[0], forKey: "food_name_eng")
        newFood.setValue(row[1], forKey: "food_name_fr")
        newFood.setValue(row[2].replacingOccurrences(of: ",", with: "."), forKey: "kj")
        
        //newFood.setValue(row[3].replacingOccurrences(of: ",", with: "."), forKey: "kcal")
        if (row[3].contains("<")) {
            let value = row[3].replacingOccurrences(of: "<", with: "")
            newFood.setValue(value.replacingOccurrences(of: ",", with: "."), forKey: "kcal")
        } else if (row[3].contains("traces") || row[3] == "" || row[3].contains("-")) {
            newFood.setValue("0", forKey: "kcal")
        } else {
            newFood.setValue(row[3].replacingOccurrences(of: ",", with: "."), forKey: "kcal")
        }
        
        newFood.setValue(row[4].replacingOccurrences(of: ",", with: "."), forKey: "water")
        newFood.setValue(row[5].replacingOccurrences(of: ",", with: "."), forKey: "protein")
        
        //newFood.setValue(row[6].replacingOccurrences(of: ",", with: "."), forKey: "carbohydrate")
        if (row[6].contains("<")) {
            let value = row[6].replacingOccurrences(of: "<", with: "")
            newFood.setValue(value.replacingOccurrences(of: ",", with: "."), forKey: "carbohydrate")
        } else if (row[6].contains("traces") || row[6] == "" || row[6].contains("-")) {
            newFood.setValue("0", forKey: "carbohydrate")
        } else {
            newFood.setValue(row[6].replacingOccurrences(of: ",", with: "."), forKey: "carbohydrate")
        }
        
        newFood.setValue(row[7].replacingOccurrences(of: ",", with: "."), forKey: "fat")
        newFood.setValue(row[8].replacingOccurrences(of: ",", with: "."), forKey: "sugars")
        newFood.setValue(row[9].replacingOccurrences(of: ",", with: "."), forKey: "starch")
        
        //newFood.setValue(row[10].replacingOccurrences(of: ",", with: "."), forKey: "fibres")
        if (row[10].contains("<")) {
            let value = row[10].replacingOccurrences(of: "<", with: "")
            newFood.setValue(value.replacingOccurrences(of: ",", with: "."), forKey: "fibres")
        } else if (row[10].contains("traces") || row[10] == "" || row[10].contains("-")) {
            newFood.setValue("0", forKey: "fibres")
        } else {
            newFood.setValue(row[10].replacingOccurrences(of: ",", with: "."), forKey: "fibres")
        }
        
        newFood.setValue(row[11].replacingOccurrences(of: ",", with: "."), forKey: "polyols")
        newFood.setValue(row[12].replacingOccurrences(of: ",", with: "."), forKey: "ash")
        newFood.setValue(row[13].replacingOccurrences(of: ",", with: "."), forKey: "alcohol")
        newFood.setValue(row[14].replacingOccurrences(of: ",", with: "."), forKey: "organic_acids")
        newFood.setValue(row[15].replacingOccurrences(of: ",", with: "."), forKey: "fa_saturated")
        newFood.setValue(row[16].replacingOccurrences(of: ",", with: "."), forKey: "fa_mono")
        newFood.setValue(row[17].replacingOccurrences(of: ",", with: "."), forKey: "fa_poly")
        newFood.setValue(row[18].replacingOccurrences(of: ",", with: "."), forKey: "cholesterol")
        newFood.setValue(row[19].replacingOccurrences(of: ",", with: "."), forKey: "calcium")
        newFood.setValue(row[20].replacingOccurrences(of: ",", with: "."), forKey: "chloride")
        newFood.setValue(row[21].replacingOccurrences(of: ",", with: "."), forKey: "copper")
        newFood.setValue(row[22].replacingOccurrences(of: ",", with: "."), forKey: "iron")
        newFood.setValue(row[23].replacingOccurrences(of: ",", with: "."), forKey: "iodine")
        newFood.setValue(row[24].replacingOccurrences(of: ",", with: "."), forKey: "magnesium")
        newFood.setValue(row[25].replacingOccurrences(of: ",", with: "."), forKey: "manganese")
        newFood.setValue(row[26].replacingOccurrences(of: ",", with: "."), forKey: "phosphorus")
        newFood.setValue(row[27].replacingOccurrences(of: ",", with: "."), forKey: "potassium")
        newFood.setValue(row[28].replacingOccurrences(of: ",", with: "."), forKey: "selenium")
        newFood.setValue(row[29].replacingOccurrences(of: ",", with: "."), forKey: "sodium")
        newFood.setValue(row[30].replacingOccurrences(of: ",", with: "."), forKey: "zinc")
        newFood.setValue(row[31].replacingOccurrences(of: ",", with: "."), forKey: "retinol")
        newFood.setValue(row[32].replacingOccurrences(of: ",", with: "."), forKey: "beta_carotene")
        newFood.setValue(row[33].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_d")
        newFood.setValue(row[34].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_e")
        newFood.setValue(row[35].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_k1")
        newFood.setValue(row[36].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_k2")
        newFood.setValue(row[37].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_c")
        newFood.setValue(row[38].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_b1")
        newFood.setValue(row[39].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_b2")
        newFood.setValue(row[40].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_b3")
        newFood.setValue(row[41].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_b5")
        newFood.setValue(row[42].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_b6")
        newFood.setValue(row[43].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_b9")
        newFood.setValue(row[44].replacingOccurrences(of: ",", with: "."), forKey: "vitamin_b12")
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
            if (versionResponse != []) {
                version = versionResponse[0].version! //if not any save data in db what happend ?
            } else {
                version = "No Version"
            }

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
