//
//  TextFieldView.swift
//  Tagabout
//
//  Created by KarunPant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import DropDown
import  SkyFloatingLabelTextField


protocol DropDownViewTextDelegate {
    func dropDownTextFieldDidBeginEditing(_ textField: UITextField);
    func dropDownTextFieldDidEndEditing(_ textField: UITextField);
    func dropDownSearchPrefix(_ textField: UITextField) -> String;
}

extension DropDownViewTextDelegate{
    func dropDownSearchPrefix(_ textField: UITextField) -> String{
        return ""
    }
}

class DropDownView: DesignableView {
    
    //consts
    private let defaultViewHieght : CGFloat = 54.0
    private let OTHERS = "Others"
    
    //flags
    private var isDropDownHidden : Bool = true
    public var secureEntry: Bool = false
    public var isOtherNeeded : Bool = false
    public var takeFreeText : Bool{
        didSet{
            if takeFreeText {
                dropDown = nil
            }
        }
    }
    
    fileprivate var isSelectedFromDropDown = false
    fileprivate var otherSelectedFromDropDown = false
    
    
    public var isMandatory = true
    public func isValid() -> Bool{
        let isValid = isSelectedFromDropDown || (takeFreeText && textField.text?.trimmingCharacters(in: .whitespaces) != "") || (textField.text?.trimmingCharacters(in: .whitespaces) == "" && !isMandatory)
        return isValid
    }
    
    //value provider
    public var text : String?{
        get{
            return textField.text
        }
    }
    
    //outlets
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    public var ownerHeightConstraint: NSLayoutConstraint?
    
    //dropdown and view
    private var dropDown : DropDown?
    private var dataSource : Array<String>?
    public var textDelegate : DropDownViewTextDelegate?
   
    
    public func hide(_ hide : Bool){
        if hide{
            isMandatory = false
            ownerHeightConstraint?.constant = 0
            topConstraint.constant = 0
            height.constant = 0
        }else{
            isMandatory = true
            ownerHeightConstraint?.constant = 52
            topConstraint.constant = 14
            height.constant = 38
        }
    }
    
    var onTextFieldChange: ((_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool)?
    
    override init(frame: CGRect) {
        self.takeFreeText = false
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        self.takeFreeText = false
        super.init(coder: aDecoder)
        
    }
    
    func updateDataSource(_ dataSource: Array<String>){
        if let dropDown = dropDown{
            self.dataSource = dataSource
            dropDown.dataSource = dataSource
//            dropDown.show()
        }else{
            assert(true, "Call hook dropdown before calling updateDataSource")
        }
    }
    
    // setup method
    func hookDropdown(placeHolder:String, dataSource : Array<String>?, selectionCompletion: ((Int, String)-> ())?){
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
        dropDown?.bottomOffset = CGPoint(x: 0, y:defaultViewHieght)
        dropDown?.direction = .bottom
//        dropDown?.topOffset = CGPoint(x: 0, y:defaultViewHieght)
        dropDown?.offsetFromWindowBottom = 64.0
        dropDown?.dismissMode = .automatic
        // The list of items to display. Can be changed dynamically
        dropDown?.dataSource = newDataSource
        dropDown?.width = self.textField.frame.size.width
        
        self.dataSource = dataSource
        dropDown?.selectionAction = {[weak self] (index: Int, item: String) in
            guard let strongSelf = self else{ return }
            
            if item == strongSelf.OTHERS {
                strongSelf.takeFreeText = true
                return
            }
            
            strongSelf.takeFreeText = false
            strongSelf.isSelectedFromDropDown = true
            strongSelf.isDropDownHidden = true
            strongSelf.textField.text = item
            if let selectionCompletion = selectionCompletion{
                selectionCompletion(index, item)
            }
        }
    }
    
}

extension DropDownView : UITextFieldDelegate{
    // Text field delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if let textDelegate = textDelegate{
            textDelegate.dropDownTextFieldDidBeginEditing(textField)
        }
        if let dropdown = dropDown{
            isDropDownHidden = false
            guard let dataSource = dataSource else { return }
            dropdown.dataSource = dataSource
            dropdown.show()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textDelegate = textDelegate{
            textDelegate.dropDownTextFieldDidEndEditing(textField)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isSelectedFromDropDown = false
        guard let dataSource = dataSource, let dropDown = self.dropDown else {
            return false
        }
        var prefix = ""
        if let textDelegate = textDelegate {
            prefix = textDelegate.dropDownSearchPrefix(textField)
        }
        var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        newString = newString.trimmingCharacters(in: .whitespaces)
        newString = prefix == "" ? newString : "\(prefix)~\(newString)"
        
        if newString == ""{
            dropDown.dataSource = dataSource
            dropDown.show()
        }else{
            let filteredDataSource = dataSource.filter{ $0.lowercased().contains(newString.lowercased()) }
            dropDown.dataSource = filteredDataSource
            dropDown.show()
            
        }
        
        if onTextFieldChange != nil {
            return onTextFieldChange!(textField, range, string)
        }
        
        return true
    }
}

