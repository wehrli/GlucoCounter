//
//  AddFoodViewController.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 20/11/2017.
//  Copyright © 2017 DiabHelp. All rights reserved.
//

import UIKit
import CoreData
import MultiAutoCompleteTextSwift

class AddFoodViewController: UIViewController {

    @IBOutlet weak var titleInput: MultiAutoCompleteTextField!
    @IBOutlet weak var quantity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleInput.maximumAutoCompleteCount = 5
        titleInput.autoCompleteTableView?.frame.origin.y = 60
        titleInput.autoCompleteTableView?.frame.origin.x = -100
        let value = DBManager.sharedInstance.getAllFoodName()
        titleInput.autoCompleteStrings = value
    }
    
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFollow(_ sender: UIButton) {

        var value = DBManager.sharedInstance.fetchRequestor(fetchRequest: NSFetchRequest<Food>(entityName: "Food") as! NSFetchRequest<NSFetchRequestResult>, predicate: NSPredicate(format: "food_name_fr == %@", titleInput.text!)) as! [Food]
        
        ListManager.sharedInstance.addFoodToActualList(food: value[0])
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissFromButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
