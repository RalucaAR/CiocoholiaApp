//
//  OrdersViewCell.swift
//  Project
//
//  Created by Inovium Digital Vision on 29/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit

class OrdersViewCell: UITableViewCell {

    @IBOutlet weak var orderTotal: UILabel!
    @IBOutlet weak var orderName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
