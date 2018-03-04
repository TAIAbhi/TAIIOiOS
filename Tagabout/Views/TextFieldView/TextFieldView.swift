//
//  TextFieldView.swift
//  Tagabout
//
//  Created by Madanlal on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit


class TextFieldView: DesignableView {
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    private var key = ""
    public var secureEntry: Bool = false
    
    public func setHeader(_ header: String, withPlaceholder placeholder: String, forKey key: String) {
        label.text = header
        textField.placeholder = placeholder
        self.key = key
    }
    
    public var value: [String: String] {
        get{
            return [key: textField.text ?? ""]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSetup()
    }
    fileprivate func viewSetup(){
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
        textField.layer.masksToBounds = true
    }

}
