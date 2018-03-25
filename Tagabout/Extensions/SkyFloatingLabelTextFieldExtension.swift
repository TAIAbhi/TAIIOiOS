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
        super.awakeFromNib()
        
        setCutomDefaultValues()
    }
    
    func setCutomDefaultValues() {
        // black
        textColor = UIColor(red: 56/255.0, green: 56/255.0, blue: 56/255.0, alpha: 1.0)
        // gray
        titleColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1.0)
        // light gray
        lineColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        // blue
        selectedLineColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        selectedTitleColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        // red
        errorColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1.0)
        
        lineHeight = 2.0
        selectedLineHeight = 2.0
        
        titleFont = UIFont(name: "Avenir-Book", size: 16.0)!
        placeholderFont = UIFont(name: "Avenir-Book", size: 16.0)!
    }
    
}

