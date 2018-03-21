//
//  TAISection.swift
//  Tagabout
//
//  Created by Karun Pant on 20/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

class TAISection: UIButton {

    public var isSectionSelected : Bool?{
        didSet{
            if let isSelected = isSectionSelected, isSelected{
                backgroundColor = UIColor.init(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 0.8)
                setTitleColor(UIColor.init(white: 0, alpha: 0.3), for: .normal)
            }else{
                backgroundColor = UIColor.init(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
            }
        }
    }

}
