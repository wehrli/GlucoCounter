//
//  AddFoodViewController.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 20/11/2017.
//  Copyright © 2017 DiabHelp. All rights reserved.
//

import UIKit
import CoreData

class AddFoodViewController: UIViewController {

    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var quantity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
