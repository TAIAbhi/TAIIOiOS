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
    fileprivate var previousSelectedSection : TAISection!
    
    fileprivate var selectionData : [String : Any] = [String : Any]()
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var processing: UIActivityIndicatorView!
    @IBOutlet weak var section1: TAISection!
    @IBOutlet weak var section2: TAISection!
    @IBOutlet weak var section3: TAISection!
    @IBOutlet weak var stickeyButtonBottom: NSLayoutConstraint!
    
    @IBOutlet weak var subcategorySelection: TextFieldView!
    @IBOutlet weak var microCat1: TextFieldView!
    @IBOutlet weak var microCat1Height: NSLayoutConstraint!
    
    @IBOutlet weak var microCat2: TextFieldView!
    @IBOutlet weak var microCat2Height: NSLayoutConstraint!
    
    @IBOutlet weak var isLocal: UISwitch!
    @IBOutlet weak var name: SkyFloatingLabelTextField!
    @IBOutlet weak var contact: SkyFloatingLabelTextField!
    @IBOutlet weak var location: TextFieldView!
    
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.processing.startAnimating()
        sectionView.isHidden = true
        self.addButton.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddSuggestionViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddSuggestionViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.scrollView.isHidden = true
       interactor.getCategories { [unowned self] categories in
            self.processing.stopAnimating()
            if let categories = categories{
                self.sectionView.isHidden = false
                self.addButton.isHidden = false
                self.scrollView.isHidden = false
                self.categories = categories
                if categories.count >= 3{
                    self.section1.setTitle(categories[0].name!, for: .normal)
                    self.section2.setTitle(categories[1].name!, for: .normal)
                    self.section3.setTitle(categories[2].name!, for: .normal)
                }
                self.selectedCategory = categories[0] // preselection
                self.previousSelectedSection = self.section1
                self.section1.isSectionSelected = true
                self.configureForm()
            }
        }
    }
    
    
    @IBAction func doCategorySelection(sender : TAISection){
        if let categories = categories, categories.count >= 3{
            let tag = sender.tag
            selectedCategory = categories[tag]
            self.previousSelectedSection.isSectionSelected = false
            sender.isSectionSelected = true
            self.previousSelectedSection = sender
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            stickeyButtonBottom.constant = keyboardSize.height
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            stickeyButtonBottom.constant = 0
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
    
    func configureForm(){
        guard let category = selectedCategory, let subCats = category.subCategories, subCats.count > 0 else { return }
        subcategorySelection.hookDropdown(placeHolder: "Select a category",
                                          dataSource: subCats.map({ (subCat) in
                                            if let name = subCat.name {
                                                return name
                                            }
                                            return ""
                                          }),
                                          selectionCompletion: {[unowned self] (index, item) in
                                            self.selectionData[self.selectedSubCategoryName] = item
                                            let selectedSubCat = subCats[index]
                                            if let subCatId = selectedSubCat.subCatId {
                                                self.selectionData[self.selectedSubCategoryValue] = subCatId
                                            }
                                            if let isMicroCategoryAvailable = category.isMicroCategoryAvailable, isMicroCategoryAvailable {
                                                let selectedSubCat = subCats[index]
                                                if let subCatId = selectedSubCat.subCatId {
                                                    // get micro categories for selected subcategory.
                                                    self.interactor.getMicroCategoriesFor(subcategoryId: subCatId, completion: { (microCategories) in
                                                        self.microCategories = microCategories
                                                    })
                                                }
                                            }
                                            
        })
        
        if let isMicroCategoryAvailable = category.isMicroCategoryAvailable, isMicroCategoryAvailable {
            microCat1.viewHeight = 0
            microCat1Height.constant = 0
            microCat1.viewHeight = 0
            microCat2Height.constant = 46
            microCat2.viewHeight = 46
            microCat2.hookDropdown(placeHolder: "Select a subcategory", dataSource: nil, selectionCompletion: nil)
        }else{
            microCat1Height.constant = 0
            microCat1.viewHeight = 0
            microCat2Height.constant = 0
            microCat2.viewHeight = 0
        }
        name.setCutomDefaultValues()
        name.placeholder = "Tag name"
        contact.setCutomDefaultValues()
        contact.placeholder = "Tag contact"
        details.layer.cornerRadius = 4
        details.layer.borderColor = UIColor.lightGray.cgColor
        details.layer.borderWidth = 0.9
        location.hookDropdown(placeHolder: "Tag location", dataSource: nil, selectionCompletion: nil)
        
    }
}
