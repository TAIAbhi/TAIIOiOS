//
//  TAINaviagtionbar.swift
//  Tagabout
//
//  Created by Karun Pant on 01/04/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import UIKit
extension UINavigationBar{
    
    func setupLogo(){
        let logoImage = UIImageView.init(image: #imageLiteral(resourceName: "head_blue"))
        self.addSubview(logoImage)
    }
    
}
