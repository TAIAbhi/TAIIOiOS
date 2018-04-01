//
//  AddSuggestionViewController.swift
//  Tagabout
//
//  Created by Karun Pant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import DropDown
import SkyFloatingLabelTextField



class AddSuggestionViewController: UIViewController {
    
    enum AddSuggestionUIType : Int{
        case subCategory
        case microCategory
        case name
        case isCityLevel
        case contact
        case location
        case comments
    }
    
    fileprivate let selectedSubCategoryValue = "SubCategoryId"
    fileprivate let selectedCategoryValue = "CatId"
    fileprivate let selectedSubCategoryName = "~UIDATA~subCat"
    fileprivate let selectedMicroCategoryValue = "~UIDATA~microCat"
    fileprivate let commentValue = "comments"
    fileprivate let contactValue = "~UIDATA~contactValue"
    fileprivate let businessNameValue = "BusinessName"
    fileprivate let cityLevel = "CitiLevelBusiness"
    fileprivate let locationKey = "Location"
    
    var isForEdit: Bool = false
    var categories : [Category]?
    // fill contact details
    var selectedCategory : Category?
    var microCategories : [MicroCategory]?
    var viewList : [AddSuggestionUIType]{
        get{
            if let selectedCategory = selectedCategory{
                if let microcatAvailable = selectedCategory.isMicroCategoryAvailable, microcatAvailable {
                    return [.subCategory, .microCategory, .name, .isCityLevel, .contact, .location, .comments]
                }
                return [.subCategory, .name, .isCityLevel, .contact, .location, .comments]
            }
            return [AddSuggestionUIType]()
        }
    }
    fileprivate lazy var interactor = AddSuggestionInteractor()
    fileprivate var previousSelectedSection : TAISection?
    
    fileprivate var selectionData : [String : Any] = [String : Any]()
    
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var addButton: TAIAction!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var processing: UIActivityIndicatorView!
    @IBOutlet weak var section1: TAISection!
    @IBOutlet weak var section2: TAISection!
    @IBOutlet weak var section3: TAISection!
    @IBOutlet weak var scrollBarBottom: NSLayoutConstraint!
    
    @IBOutlet weak var microCat1: DropDownView!
    @IBOutlet weak var microCat1Height: NSLayoutConstraint!
    
    @IBOutlet weak var microCat2: DropDownView!
    @IBOutlet weak var microCat2Height: NSLayoutConstraint!
    
    @IBOutlet weak var isLocal: UISwitch!
    @IBOutlet weak var name: TextFieldView!
    @IBOutlet weak var contact: TextFieldView!
    @IBOutlet weak var location: DropDownView!
    
    @IBOutlet weak var details: FloatLabelTextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblSelectedCategory: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.processing.startAnimating()
        self.sectionView.backgroundColor = Theme.grey
        self.emptyStateLabel.text = "Loading categories..."
        self.addButton.isEnabled = false
        self.details.contentInset = UIEdgeInsets.init(top: 5, left: 8, bottom: 5, right: 8)
        self.details.titleFont = Theme.avenirTitle!
        self.navigationController?.navigationBar.setup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddSuggestionViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddSuggestionViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.scrollView.isHidden = true
        
       interactor.getCategories { [unowned self] categories in
            self.processing.stopAnimating()
            self.emptyStateLabel.text = "Select a category to continue."
            if let categories = categories{
                self.categories = categories
                if categories.count >= 3{
                    self.section1.setTitle(categories[0].name?.uppercased(), for: .normal)
                    self.section2.setTitle(categories[1].name?.uppercased(), for: .normal)
                    self.section3.setTitle(categories[2].name?.uppercased(), for: .normal)
                }
            }
        }
    }
    
    
    private func clearAll(){
        self.location.textField.text = ""
        self.name.textField.text = ""
        self.microCat1.textField.text = ""
        self.microCat2.textField.text = ""
        self.contact.textField.text = ""
        self.details.text = ""
    }
    
    @IBAction func doCategorySelection(sender : TAISection){
        self.view.endEditing(true)
        clearAll()
        if let categories = categories, categories.count >= 3{
            let tag = sender.tag
            selectedCategory = categories[tag]
            guard let selectedCategory = selectedCategory,
                let subcats = selectedCategory.subCategories,
                subcats.count > 0  else{
                self.lblSelectedCategory.text = "Suggestion"
                if let previousSelected = self.previousSelectedSection{
                    previousSelected.isSectionSelected = false
                }
                sender.isSectionSelected = true
                self.previousSelectedSection = sender
                self.configureForm()
                self.scrollView.isHidden = false
                return
            }
            
            let dropDown = DropDown()
            dropDown.dataSource = subcats.map{ $0.name ?? "" }
            dropDown.shadowRadius = 1
            dropDown.shadowOpacity = 0.2
            dropDown.bottomOffset = CGPoint(x: 0, y:(sender.bounds.size.height + 5))
            dropDown.dismissMode = .automatic
            dropDown.show()
            dropDown.anchorView = sender
            dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
                self.selectionData[self.selectedSubCategoryName] = item
                let selectedSubCat = subcats[index]
                if let subCatId = selectedSubCat.subCatId {
                    self.selectionData[self.selectedSubCategoryValue] = subCatId
                }
                
                // configure
                self.lblSelectedCategory.text = "\(item)"
                if let previousSelected = self.previousSelectedSection{
                    previousSelected.isSectionSelected = false
                }
                sender.isSectionSelected = true
                self.previousSelectedSection = sender
                self.configureForm()
                self.scrollView.isHidden = false
                
                if let isMicroCategoryAvailable = selectedCategory.isMicroCategoryAvailable, isMicroCategoryAvailable {
                    let selectedSubCat = subcats[index]
                    if let subCatId = selectedSubCat.subCatId {
                        // get micro categories for selected subcategory.
                        self.interactor.getMicroCategoriesFor(subcategoryId: subCatId, completion: { (microCategories) in
                            self.microCategories = microCategories
                        })
                    }
                }
            }
            
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollBarBottom.constant = keyboardSize.height
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollBarBottom.constant = 0
        }
    }
    @IBAction func addLocation(_ sender: UIButton) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddSuggestionViewController{
    // drop down
    
    
    func openMicroCatPickerFor(_ microCategories: [MicroCategory]?, withAnchor anchor: UITextField) {
        
        guard let microCategories = microCategories, microCategories.count > 0 else { return }
        
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = anchor // UIView or UIBarButtonItem
        dropDown.shadowRadius = 1
        dropDown.shadowOpacity = 0.2
        dropDown.bottomOffset = CGPoint(x: 0, y:38)
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = microCategories.map({ (microCat) in
            if let name = microCat.name {
                return name
            }
            return ""
        })
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectionData[self.selectedMicroCategoryValue] = item
        }
        
        dropDown.show()
    }
}

extension AddSuggestionViewController{
    
    func validateAllMandatoryFields() {
        let isValidForm = name.isValid() && contact.isValid() && microCat1.isValid() && (details != nil)
        
        self.addButton.isEnabled = true
    }
    
    func configureForm(){
        guard let category = selectedCategory, let subCats = category.subCategories, subCats.count > 0 else { return }
        
        microCat1.ownerHeightConstraint = microCat1Height
        microCat2.ownerHeightConstraint = microCat2Height
        if let isMicroCategoryAvailable = category.isMicroCategoryAvailable, isMicroCategoryAvailable {
            microCat1.hide(false)
            microCat1.hookDropdown(placeHolder: "Subcategory *", dataSource: nil, selectionCompletion: nil)
            microCat2.hide(true)
        }else{
            microCat1.hide(true)
            microCat2.hide(true)

        }
        name.placeholder = "Name (Individual or Company) *"
        name.isMandatory = true
        contact.placeholder = "Contact number"
        details.layer.cornerRadius = 4
        details.layer.borderColor = UIColor.lightGray.cgColor
        details.layer.borderWidth = 0.9
        location.hookDropdown(placeHolder: "Location (Mumbai only) *", dataSource: nil, selectionCompletion: nil)
        
    }
}
