//
//  ShoppingCartTableViewCell.swift
//  Project
//
//  Created by Inovium Digital Vision on 27/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit

class ShoppingCartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    @IBOutlet weak var stepperObj: UIStepper!
    @IBAction func stepperAction(_ sender: UIStepper) {
        var number = 0
        number = Int(sender.value)
        productQuantity.text = String(number)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
