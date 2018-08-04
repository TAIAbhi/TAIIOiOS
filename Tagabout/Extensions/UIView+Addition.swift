//
//  UIView+Addition.swift
//  Tagabout
//
//  Created by Arun Jangid on 03/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

extension UIView {
    func addDropWhiteShadow() {
        layer.cornerRadius    = 5
        layer.shadowColor     = UIColor(red: 225/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1.0).cgColor
        layer.shadowOpacity   = 1.0
        layer.shadowRadius    = 5
        layer.shadowOffset    = CGSize(width: 5.0, height: 5.0)
    }
    
    func addDropBlackShadow() {
        layer.cornerRadius    = 5
        layer.shadowColor     = UIColor(white: 0.35, alpha: 0.85).cgColor
        layer.shadowOpacity   = 1.0
        layer.shadowRadius    = 5
        layer.shadowOffset    = CGSize(width: 5.0, height: 5.0)
    }
    
    func curveBorders(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
