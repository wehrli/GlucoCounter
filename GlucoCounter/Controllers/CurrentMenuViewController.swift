//
//  ViewController.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 03/09/2017.
//  Copyright © 2017 DiabHelp. All rights reserved.
//

import UIKit
import CoreData

// TODO: get name of the favorist list food if come from favorite pages

class CurrentMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var items : [FoodItemMO]!
    private let dbManager = DBManager()
    @IBOutlet weak var tableViewObject: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    @IBOutlet weak var glucidicTotalDisplay: UILabel!
    @IBOutlet weak var kcalTotalDisplay: UILabel!
    @IBOutlet weak var weightTotalDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
        ** procedure of erasing value into core data (only FoodList)
        */
        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodList")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        
//        do {
//            try DBManager.sharedInstance.getContext().execute(deleteRequest)
//        } catch let error as NSError {
//            // TODO: handle the error
//        }
        
        /*
        ** End of procedure
        */
        
        items = []
        
        trashButton.action = #selector(eraseAllFoodFromCurrentList)
        
        // This allow the pull to refresh event
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableViewObject.refreshControl = refreshControl
        
        //get all food from last used (current or fav)
        self.getItemFromDb()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     **  return number cell view (depends on section if there is)
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    /*
     ** Set a cell view
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FoodItem", for: indexPath) as! ItemTableViewCell
        
        let itm = items[indexPath.row]
        
        print(itm.name)
        cell.itemTitle.text = itm.name
        
        cell.itemValues.text = "KCal: " + String(itm.kCalQuantity)
                                + " Glucides: " + String(itm.glucidicQuantity)
        
        cell.itemTotal.text = "Poids: " + String(itm.weight)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // willDisplay function
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            let tmp = ListManager.sharedInstance.calculeResultDiabetValues()
            print(tmp)
            
            glucidicTotalDisplay.text = "Apport glucidique total : " + String(format: "%.2f", tmp.glucidicQuantity)
            kcalTotalDisplay.text = "Apport caloriques total : " + String(format: "%.2f", tmp.kCalQuantity)
            weightTotalDisplay.text = "Poids Total : " + String(format: "%.2f", tmp.totalWeight)
        }
    }
    
    /*
     ** give action for editing, deleting a cell view
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            ListManager.sharedInstance.removeFoodToActualList(nameFood: items[indexPath.row].name)
            self.getItemFromDb()
            tableViewObject.reloadData()
        }
 
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.getItemFromDb()
        tableViewObject.reloadData()
    }
    
    func getItemFromDb() {
        items.removeAll()
        
        glucidicTotalDisplay.text = "Apport glucidique total : 0.0"
        kcalTotalDisplay.text = "Apport caloriques total : 0.0"
        weightTotalDisplay.text = "Poids Total : 0.0"
        
        items = ListManager.sharedInstance.getListFood()
    }
    
    func refreshTable(refreshControl: UIRefreshControl) {
        self.getItemFromDb()
        tableViewObject.reloadData()
        refreshControl.endRefreshing()
    }
    
    func eraseAllFoodFromCurrentList() {
        ListManager.sharedInstance.cleanActualList()
        self.getItemFromDb()
        tableViewObject.reloadData()
    }
}

