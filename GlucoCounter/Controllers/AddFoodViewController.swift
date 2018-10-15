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
        
       // get all information about the food selected
        var value = DBManager.sharedInstance.fetchRequestor(fetchRequest: NSFetchRequest<RawFood>(entityName: "RawFood") as! NSFetchRequest<NSFetchRequestResult>, predicate: NSPredicate(format: "food_name_fr == %@", titleInput.text!.trimmingCharacters(in: .whitespacesAndNewlines))) as! [RawFood]
        
        if (quantity.text! == "") {
            let myAlertController: UIAlertController = UIAlertController(title: "Hey..!", message: "Please add a quantity", preferredStyle: .alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Do Nothing
            }
            myAlertController.addAction(cancelAction)
            self.present(myAlertController, animated: true, completion: nil)
            return
        }
        if (value == [])
        {
            let myAlertController: UIAlertController = UIAlertController(title: "Hey..!", message: "No food found", preferredStyle: .alert)

            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Do Nothing
            }
            myAlertController.addAction(cancelAction)
            self.present(myAlertController, animated: true, completion: nil)
            return
        }
        
        let numberFormatter: NumberFormatter! = NumberFormatter()
        
        // Weight string to Float
        let quantityChooseByUser = numberFormatter.number(from: quantity.text!)?.floatValue
        
        // Get food composant string to format into Float, from RawFood
        var carbohydrate: Float! = 0
        var fibre: Float! = 0
        var kcal: Float! = 0
        
        var tmp = value[0].carbohydrate!.description
        carbohydrate = (tmp as NSString).floatValue
        tmp = value[0].fibres!.description
        fibre = (tmp as NSString).floatValue
        tmp = value[0].kcal!.description
        kcal = (tmp as NSString).floatValue
        
//        if let carboValueOptionalValue = value[0].carbohydrate?.description {
//            carbohydrate = numberFormatter.number(from:carboValueOptionalValue)?.floatValue ?? 0
//        }
//        if let fiberValueOptionalValue = value[0].fibres {
//            fibre = numberFormatter.number(from:fiberValueOptionalValue)?.floatValue ?? 0
//        }
//        if let kcalValueOptionalValue = value[0].kcal {
//            kcal = numberFormatter.number(from:kcalValueOptionalValue)?.floatValue ?? 0
//        }
        
//        let carbohydrateForCentGrams = numberFormatter.number(from: value[0].carbohydrate!)!.floatValue
//        let fiberForCentGrams = numberFormatter.number(from: value[0].fibres!)?.floatValue
//        let kcalForCentGrams = numberFormatter.number(from: value[0].kcal!)?.floatValue
        
        //calcul glucidique (
        let carbohydrateQ = (quantityChooseByUser! * carbohydrate) / 100
        let fiberQ = (quantityChooseByUser! * fibre) / 100
        let glucides = carbohydrateQ - fiberQ
        
        //calcul kCal
        let kCalQ = (quantityChooseByUser! * kcal) / 100
        
        
        let itemToAdd = FoodItemMO(context: DBManager.sharedInstance.getContext())
        itemToAdd.name = titleInput.text
        itemToAdd.glucidicQuantity = glucides
        itemToAdd.kCalQuantity = kCalQ
        itemToAdd.weight = quantityChooseByUser!
        
            
            
            //FoodItem(title: value[0].food_name_fr!, quantity: quantityChooseByUser!, glucide: glucides, kcal: kCal)
        ListManager.sharedInstance.addFoodToActualList(food: itemToAdd)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissFromButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
