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
    
    
    //value provider
    private var value : String?{
        get{
            if takeFreeText {
                return textField.text
            }else{
                return nil
            }
        }
    }
    
    //outlets
    @IBOutlet private weak var textField: SkyFloatingLabelTextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //dropdown and view
    private var dropDown : DropDown?
    private var dataSource : Array<String>?
    public var viewHeight : CGFloat{
        didSet{
            if viewHeight == 0{
                topConstraint.constant = 0
            }else{
                topConstraint.constant = 8
            }
        }
    }
    
    override init(frame: CGRect) {
        self.viewHeight = defaultViewHieght
        self.takeFreeText = false
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        self.viewHeight = defaultViewHieght
        self.takeFreeText = false
        super.init(coder: aDecoder)
        
    }
    
    // setup method
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
        dropDown?.bottomOffset = CGPoint(x: 0, y:defaultViewHieght)
        dropDown?.dismissMode = .automatic
        // The list of items to display. Can be changed dynamically
        dropDown?.dataSource = newDataSource
        
        self.dataSource = dataSource
        dropDown?.selectionAction = {[unowned self] (index: Int, item: String) in
            if item == self.OTHERS {
                self.takeFreeText = true
                return
            }
            if let selectionCompletion = selectionCompletion{
                selectionCompletion(index, item)
            }
            self.isDropDownHidden = true
            self.textField.text = item
        }
    }
    
}

extension TextFieldView : UITextFieldDelegate{
    // Text field delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let dropdown = dropDown{
            isDropDownHidden = false
            guard let dataSource = dataSource else { return }
            dropdown.dataSource = dataSource
            dropdown.show()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let dataSource = dataSource, let dropDown = self.dropDown else {
            return false
        }
        var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        newString = newString.trimmingCharacters(in: .whitespaces)
        
        if newString == ""{
            dropDown.dataSource = dataSource
            dropDown.show()
        }else{
            let filteredDataSource = dataSource.filter{ $0.lowercased().contains(newString.lowercased()) }
            dropDown.dataSource = filteredDataSource
            dropDown.show()
            
        }
        return true
    }
}

