//
//  FavoritesMenusViewController.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 18/08/2018.
//  Copyright © 2018 DiabHelp. All rights reserved.
//

import UIKit

class FavoritesMenusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var listFood: [FoodListMO]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listFood = []
        
        // This allow the pull to refresh event
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
        listFood = ListManager.sharedInstance.getListFavorite()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*
     **  return number cell view (depends on section if there is)
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFood.count
    }
    
    /*
     ** Set a cell view
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListItem", for: indexPath) as! ItemTableViewCell
        
        let itm = listFood[indexPath.row]

        cell.itemTitle.text = itm.name
        cell.itemTotal.text = itm.totalweight.description
        cell.itemValues.text = "Total Glucides: " + itm.totalglucidic.description + " Total KCal: " + itm.totalkcal.description

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    /*
     ** give action on selecting a cell view
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        ListManager.sharedInstance.setFavoriteToActual(foodList: listFood[indexPath.row])
        tabBarController?.selectedIndex = 0
    }
    
    /*
     ** give action for editing, deleting a cell view
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            ListManager.sharedInstance.removeFoodToFavoriteList(nameList: listFood[indexPath.row].name!)
            listFood = ListManager.sharedInstance.getListFavorite()
            tableView.reloadData()
        }
        
    }
    
    func refreshTable(refreshControl: UIRefreshControl) {
        listFood = ListManager.sharedInstance.getListFavorite()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
