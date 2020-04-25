//
//  AddLocationTableViewCell.swift
//  Project
//
//  Created by Inovium Digital Vision on 25/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit

class AddLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationSubtitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.reloadInputViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
