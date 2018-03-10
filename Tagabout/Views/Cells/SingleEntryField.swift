//
//  SingleTextFormViewCell.swift
//  Tagabout
//
//  Created by Karun Pant on 08/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SingleEntryField: UITableViewCell {

    @IBOutlet weak var field: SkyFloatingLabelTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
