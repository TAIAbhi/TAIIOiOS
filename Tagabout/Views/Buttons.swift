//
//  TAISection.swift
//  Tagabout
//
//  Created by Karun Pant on 20/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

// section button
class TAISection: UIButton {
    
    override func awakeFromNib() {
        self.round(radius: 4.0)
        backgroundColor = Theme.black
        setTitleColor(.white, for: .normal)
        super.awakeFromNib()
    }

    public var isSectionSelected : Bool?{
        didSet{
            if let isSelected = isSectionSelected, isSelected{
                backgroundColor = Theme.blue
                setTitleColor(.white, for: .normal)
            }else{
                backgroundColor = Theme.black
            }
        }
    }

}

class TAIAction: UIButton{
    override func awakeFromNib() {
        self.round(radius: 4.0)
        backgroundColor = Theme.blue
        setTitleColor(.white, for: .normal)
        super.awakeFromNib()
    }
    
    override var isEnabled: Bool{
        didSet{
            if !isEnabled {
                backgroundColor = Theme.disabledAction
            }else{
                backgroundColor = Theme.blue
                
            }
        }
    }
    
}
