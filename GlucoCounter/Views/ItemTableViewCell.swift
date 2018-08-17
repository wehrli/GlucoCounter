//
//  ItemTableViewCell.swift
//  GlucoCounter
//
//  Created by Guillaume Wehrling on 20/11/2017.
//  Copyright © 2017 DiabHelp. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemValues: UILabel!
    @IBOutlet weak var itemTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
