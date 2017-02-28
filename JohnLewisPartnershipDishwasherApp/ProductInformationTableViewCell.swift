//
//  ProductInformationTableViewCell.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 27/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import UIKit

class ProductInformationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var productDecLabel: UILabel!
    @IBOutlet weak var productCodeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
