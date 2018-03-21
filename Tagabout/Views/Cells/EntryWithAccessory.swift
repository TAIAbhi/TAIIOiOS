//
//  TextWithAccesoryFormViewCell.swift
//  Tagabout
//
//  Created by Karun Pant on 08/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EntryWithAccessory: UITableViewCell {

    @IBOutlet weak var field: SkyFloatingLabelTextField!
    @IBOutlet weak var btnAccessory: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

class ISCityLevelEntryCell: UITableViewCell {
    @IBOutlet weak var isCityLevel : UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
