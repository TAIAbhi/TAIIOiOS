//
//  SkyFloatingLabelTextFieldExtension.swift
//  Tagabout
//
//  Created by Madanlal on 04/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

extension SkyFloatingLabelTextField {
    
    open override func awakeFromNib() {
        setCustomDefaultValues()
        super.awakeFromNib()
    }
    
    func setCustomDefaultValues() {
        // black
        textColor = Theme.black
        // gray
        titleColor = Theme.blue
        // light gray
        lineColor = Theme.blue
        disabledColor = Theme.blue
        // blue
        selectedLineColor = Theme.black
        selectedTitleColor = Theme.blue
        // red
        errorColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1.0)
        placeholderColor = Theme.textGrey
        
        lineHeight = 2.0
        selectedLineHeight = 2.0
        
        titleFont = UIFont(name: "Avenir-Book", size: 10.0)!
        placeholderFont = UIFont(name: "Avenir-Book", size: 16.0)!
    }
    
}

