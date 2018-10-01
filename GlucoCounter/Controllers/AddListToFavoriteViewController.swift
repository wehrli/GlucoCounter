//
//  AddListToFavoriteViewController.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 18/08/2018.
//  Copyright © 2018 DiabHelp. All rights reserved.
//

import UIKit

class AddListToFavoriteViewController: UIViewController {

    @IBOutlet weak var nameOfTheList: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addListToFavorite(_ sender: UIButton) {

        let result = ListManager.sharedInstance.calculeResultDiabetValues()
        ListManager.sharedInstance.addFoodListToFavorite(name: nameOfTheList.text!, diabetValues: result)
        dismiss(animated: true, completion: nil)
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
