//
//  TextFieldView.swift
//  Tagabout
//
//  Created by Madanlal on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit


class TextFieldView: UIView {

    private let nibName = "TextFieldView"
    private var contentView: UIView?
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    private var key = ""
    var secureEntry: Bool = false
    
    func setHeader(_ header: String, withPlaceholder placeholder: String, forKey key: String) {
        label.text = header
        textField.placeholder = placeholder
        self.key = key
    }
    
    func value() -> [String: String] {
        return [key: textField.text ?? ""]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
        textField.layer.masksToBounds = true
        
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
