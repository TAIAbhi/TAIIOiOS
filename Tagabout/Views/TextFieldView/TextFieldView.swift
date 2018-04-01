//
//  TextFieldView.swift
//  Tagabout
//
//  Created by KarunPant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import  SkyFloatingLabelTextField


class TextFieldView: DesignableView {
    
    //consts
    private let defaultViewHieght : CGFloat = 54.0
    
    //outlets
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    
    
    public var ownerHeightConstraint: NSLayoutConstraint?
    
    public var isMandatory = false
    typealias validator = ((String?) -> (Bool))
    public func isValid(_ validator : validator? = nil) -> Bool{
        guard let validator = validator else{
            return textField.text?.trimmingCharacters(in: .whitespaces) != "" || !isMandatory
        }
        let isValid = textField.text?.trimmingCharacters(in: .whitespaces) != "" ? validator(textField.text) : !isMandatory
        return isValid
    }
    
    public func hide(_ hide : Bool){
        if hide{
            ownerHeightConstraint?.constant = 0
            topConstraint.constant = 0
            height.constant = 0
        }else{
            ownerHeightConstraint?.constant = 52
            topConstraint.constant = 14
            height.constant = 38
        }
    }
    
    public var placeholder : String?{
        didSet{
            if let placeholder = placeholder{
                textField.placeholder = placeholder
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

