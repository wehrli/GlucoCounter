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

        //let value = DBManager.sharedInstance.getAllFoodName()
        
    }
    
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFollow(_ sender: UIButton) {

        //print(titleInput.text?.trimmingCharacters(in: .whitespacesAndNewlines))
        
       // get all information about the food selected
        var value = DBManager.sharedInstance.fetchRequestor(fetchRequest: NSFetchRequest<RawFood>(entityName: "RawFood") as! NSFetchRequest<NSFetchRequestResult>, predicate: NSPredicate(format: "food_name_fr == %@", titleInput.text!.trimmingCharacters(in: .whitespacesAndNewlines))) as! [RawFood]
        

        if (value == [])
        {
            let myAlertController: UIAlertController = UIAlertController(title: "Hey..!", message: "No food found", preferredStyle: .alert)

            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Do some stuff


            }
            myAlertController.addAction(cancelAction)

            self.present(myAlertController, animated: true, completion: nil)

            print("no food founded for that selection")
            return
        }
        
        let numberFormatter = NumberFormatter()
        
        // Weight string to Float
        let quantityChooseByUser = numberFormatter.number(from: quantity.text!)?.floatValue
        
        // Get food composant string to format into Float, from RawFood
        let carbohydrateForCentGrams = numberFormatter.number(from: value[0].carbohydrate!)?.floatValue
        let fiberForCentGrams = numberFormatter.number(from: value[0].fibres!)?.floatValue
        let kcalForCentGrams = numberFormatter.number(from: value[0].kcal!)?.floatValue
        
        //calcul glucidique (
        let carbohydrate = (quantityChooseByUser! * carbohydrateForCentGrams!) / 100
        let fiber = (quantityChooseByUser! * fiberForCentGrams!) / 100
        let glucides = carbohydrate - fiber
        
        //calcul kCal
        let kCal = (quantityChooseByUser! * kcalForCentGrams!) / 100
        
        
        let itemToAdd = FoodItemMO(context: DBManager.sharedInstance.getContext())
        itemToAdd.name = titleInput.text
        itemToAdd.glucidicQuantity = glucides
        itemToAdd.kCalQuantity = kCal
        itemToAdd.weight = quantityChooseByUser!
        
            
            
            //FoodItem(title: value[0].food_name_fr!, quantity: quantityChooseByUser!, glucide: glucides, kcal: kCal)
        ListManager.sharedInstance.addFoodToActualList(food: itemToAdd)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissFromButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
