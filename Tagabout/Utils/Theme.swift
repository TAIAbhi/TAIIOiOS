//
//  ViewExtensions.swift
//  Tagabout
//
//  Created by Karun Pant on 01/04/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    public static let blue = UIColor.init(red: 31.0/255.0, green: 134.0/255.0, blue: 176.0/255.0, alpha: 1.0)
    public static let disabledAction = UIColor.init(white: 0, alpha: 0.4)
    public static let disabledActionWhite = UIColor.init(white: 1, alpha: 0.5)
    public static let black = UIColor.init(white: 0, alpha: 1)
    public static let grey = UIColor.init(red: 241.0/255.0, green: 242.0/255.0, blue: 243.0/255.0, alpha: 1.0)
    public static let textGrey = UIColor.init(red: 129.0/255.0, green: 130.0/255.0, blue: 131.0/255.0, alpha: 1.0)
    public static let avenirTitle = UIFont.init(name: "Avenir-Book", size: 12)
    
}

extension UIView{
    public func round(radius : CGFloat){
        layer.cornerRadius = radius
    }
}

