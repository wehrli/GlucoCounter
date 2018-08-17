//
//  ViewController.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 03/09/2017.
//  Copyright © 2017 DiabHelp. All rights reserved.
//

import UIKit
import CoreData

class CurrentMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var items = [FoodItem]()
    private let dbManager = DBManager()
    @IBOutlet weak var tableViewObject: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This allow the pull to refresh event
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableViewObject.refreshControl = refreshControl
        
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
        let cell: ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemTableViewCell
        
        let itm = items[indexPath.row]
        
        
        cell.itemTitle.text = itm.title
        cell.itemValues.text = "Quantité: " + String(itm.quantity) + "Glucides: " + String(itm.glucide)
        cell.itemTotal.text = String(itm.total)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
     ** give action for editing, deleting a cell view
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            ListManager.sharedInstance.removeFoodToActualList(nameFood: items[indexPath.row].title)
            self.getItemFromDb()
            tableViewObject.reloadData()
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
        let actualList = ListManager.sharedInstance.getListFood()
        actualList.forEach() {food in
            let formatter = NumberFormatter()
            formatter.decimalSeparator = ","
            let fat = formatter.number(from: food.fat!)
            
            items.append(FoodItem(title: food.food_name_fr!, quantity: 150, glucide: fat as! Double, total: 30))
        }
    }
    
    func refreshTable(refreshControl: UIRefreshControl) {
        getItemFromDb()
        tableViewObject.reloadData()
        refreshControl.endRefreshing()
    }
}

