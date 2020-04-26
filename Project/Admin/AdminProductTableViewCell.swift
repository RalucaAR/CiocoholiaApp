//
//  AdminProductTableViewCell.swift
//  Project
//
//  Created by Inovium Digital Vision on 26/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit

class AdminProductTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
