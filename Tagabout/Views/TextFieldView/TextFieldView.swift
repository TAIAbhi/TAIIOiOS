//
//  TextFieldView.swift
//  Tagabout
//
//  Created by Madanlal on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import DropDown
import  SkyFloatingLabelTextField


class TextFieldView: DesignableView {
    
    @IBOutlet private weak var textField: SkyFloatingLabelTextField!
    private var dropDown : DropDown?
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    private var isDropDownHidden : Bool = true
    
    private var key = ""
    public var secureEntry: Bool = false
    public var isOtherNeeded : Bool = false
    
    private var dataSource : Array<String>?
    public var filteredDataSource : [String]?
    public var viewHeight : CGFloat{
        didSet{
            if viewHeight == 0{
                topConstraint.constant = 0
            }else{
                topConstraint.constant = 8
            }
        }
    }
    
    func hookDropdown(placeHolder:String, dataSource : Array<String>?, selectionCompletion: ((Int, String)-> ())?){
        textField.setCutomDefaultValues()
        textField.placeholder = placeHolder
        guard let dataSource = dataSource else { return }
        textField.delegate = self
        
        var newDataSource = dataSource
        if isOtherNeeded{
            newDataSource.append("Other")
        }
        DropDown.startListeningToKeyboard()
        // The view to which the drop down will appear on
        dropDown = DropDown()
        dropDown?.anchorView = self
        dropDown?.shadowRadius = 1
        dropDown?.shadowOpacity = 0.2
        dropDown?.bottomOffset = CGPoint(x: 0, y:54)
        dropDown?.dismissMode = .automatic
        // The list of items to display. Can be changed dynamically
        dropDown?.dataSource = newDataSource
        
        self.dataSource = dataSource
        dropDown?.selectionAction = {[unowned self] (index: Int, item: String) in
            if let selectionCompletion = selectionCompletion{
                selectionCompletion(index, item)
            }
            self.isDropDownHidden = true
            self.textField.text = item
        }
    }
    
    override init(frame: CGRect) {
        self.viewHeight = 46
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        self.viewHeight = 46
        super.init(coder: aDecoder)
 
    }
    
}

extension TextFieldView : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let dropdown = dropDown{
            isDropDownHidden = false
            guard let dataSource = dataSource else { return }
            dropdown.dataSource = dataSource
            dropdown.show()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let dataSource = dataSource else {
            return false
        }
        var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        newString = newString.trimmingCharacters(in: .whitespaces)
        filteredDataSource = dataSource.filter{ $0.lowercased().contains(newString.lowercased())  || "Other".lowercased().contains(newString.lowercased()) }
        dropDown?.dataSource = filteredDataSource!
        if newString == ""{
           dropDown?.dataSource = dataSource
        }
        if isDropDownHidden {
            if let dropdown = dropDown{
                isDropDownHidden = false
                dropdown.show()
            }
        }
        return true
    }
}

