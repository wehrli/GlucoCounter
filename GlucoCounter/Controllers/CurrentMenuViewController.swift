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
    
    
    @IBOutlet weak var glucidicTotalDisplay: UILabel!
    @IBOutlet weak var kcalTotalDisplay: UILabel!
    @IBOutlet weak var weightTotalDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
        ** procedure of erasing value into core data (only FoodList)
        */
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try DBManager.sharedInstance.getContext().execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
        }
        
        /*
        ** End of procedure
        */
        
        items = []
        
        // This allow the pull to refresh event
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableViewObject.refreshControl = refreshControl
        
        // Add target on addToFavorite button
//        favoriteButton.addTarget(self, action: #selector(putToFavorite), for: .touchUpInside)
        
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
            
            //valeur en dur a modifié
            glucidicTotalDisplay.text = "Apport glucidique total : " + tmp.glucidicQuantity.description
            kcalTotalDisplay.text = "Apport caloriques total : " + tmp.kCalQuantity.description
            weightTotalDisplay.text = "Poids Total : " + tmp.totalWeight.description
        }
    }
    
    /*
     ** give action for editing, deleting a cell view
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //ListManager.sharedInstance.removeFoodToActualList(nameFood: items[indexPath.row].title)
            //self.getItemFromDb()
            //tableViewObject.reloadData()
        }
 
    }
    
    /*
     ** give action on selecting a cell view
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if (deviceSort[indexPath.row].getId() != -1) {
         self.performSegueWithIdentifier("editDeviceSegue", sender: indexPath)
         }
        
        let test: NotificationCenter!
        test.post(Notification.init(name: Notification.Name(rawValue: "Cailloux !!!!!!")))
        */
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.getItemFromDb()
        tableViewObject.reloadData()
    }
    
    func getItemFromDb() {
        items.removeAll()
        items = ListManager.sharedInstance.getListFood()
    }
    
    func refreshTable(refreshControl: UIRefreshControl) {
        getItemFromDb()
        tableViewObject.reloadData()
        refreshControl.endRefreshing()
    }
    
    func putToFavorite() {
        
    }
}

