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
import LabelSwitch
import Contacts
import ContactsUI




class AddSuggestionViewController: UIViewController, CNContactPickerDelegate {
    
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
    var selectedSubCategory : Subcategory?
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
    fileprivate lazy var locationInteractor = AddLocationInteractor()
    fileprivate var previousSelectedSection : TAISection?
    
    fileprivate var selectionData : [String : Any] = [String : Any]()
    
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var addButton: TAIAction!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var section1: TAISection!
    @IBOutlet weak var section2: TAISection!
    @IBOutlet weak var section3: TAISection!
    @IBOutlet weak var scrollBarBottom: NSLayoutConstraint!
    
    @IBOutlet weak var microCat1: DropDownView!
    @IBOutlet weak var microCat1Height: NSLayoutConstraint!
    
    @IBOutlet weak var microCat2: DropDownView!
    @IBOutlet weak var microCat2Height: NSLayoutConstraint!
    
    @IBOutlet weak var isLocal: LabelSwitch!
    
    @IBOutlet weak var isAChain: LabelSwitch!
    var topDismissHandler:((SuggestionFilter) -> ())!
    @IBOutlet weak var name: TextFieldView!
    @IBOutlet weak var contact: TextFieldView!
    @IBOutlet weak var location: TextFieldView!
    
    @IBOutlet weak var details: FloatLabelTextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblSelectedCategory: UILabel!
    private var locationId : Int?
    private var selectedMicroCategoryName : String?
    
    private var tabController : TabbarController?
    
    private var locations: [Location]? {
        didSet {
            updateDataSourceForDropDown()
        }
    }
    
    private lazy var dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tabController = self.tabBarController as? TabbarController
        
        self.sectionView.backgroundColor = Theme.grey
        self.emptyStateLabel.text = "Loading categories..."
//        self.addButton.isEnabled = false
        DropDown.startListeningToKeyboard()
        
        self.scrollView.isHidden = true
        isLocal.delegate = self
        isAChain.delegate = self
        
        tabController?.showThemedLoader(true)
        interactor.getCategories { [weak self] categories in
            guard let strongSelf = self else{ return }
            strongSelf.tabController?.showThemedLoader(false)
            strongSelf.emptyStateLabel.text = "Select a category to continue."
            if let categories = categories{
                strongSelf.categories = categories
                if categories.count >= 3{
                    strongSelf.section1.setTitle(categories[0].name?.uppercased(), for: .normal)
                    strongSelf.section2.setTitle(categories[1].name?.uppercased(), for: .normal)
                    strongSelf.section3.setTitle(categories[2].name?.uppercased(), for: .normal)
                }
            }
        }
        
        topDismissHandler = { selectedFilter in
            if selectedFilter.catId == 1 {
                self.doCategorySelectionFromLanding(sender: self.section1, filter: selectedFilter)
            }else if selectedFilter.catId == 2{
               self.doCategorySelectionFromLanding(sender: self.section2, filter: selectedFilter)
            }else{
               self.doCategorySelectionFromLanding(sender: self.section3, filter: selectedFilter)
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
    
    func doCategorySelectionFromLanding(sender : TAISection, filter:SuggestionFilter){
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
                    
                    self.scrollView.isHidden = false
                    return
            }
            
//            self.selectionData[self.selectedSubCategoryName] =
            
//            {[weak self] (index: Int, item: String) in
//                guard let strongSelf = self else{ return }
//                strongSelf.selectionData[strongSelf.selectedSubCategoryName] = item
            
            if let selectedSubCat = subcats.filter( { $0.subCatId! == filter.subCatId!}).first{
                self.selectionData[self.selectedSubCategoryValue] = filter.subCatId
                self.lblSelectedCategory.text = selectedSubCat.name
                if let previousSelected = self.previousSelectedSection{
                    previousSelected.isSectionSelected = false
                }
                isLocal.curState = (selectedSubCat.isLocal)! == true ? .L : .R
                sender.isSectionSelected = true
                previousSelectedSection = sender
                scrollView.isHidden = false
                if let subCatId = selectedSubCat.subCatId{
                    // get micro categories for selected subcategory.
                    tabController?.showThemedLoader(true)
                    interactor.getMicroCategoriesFor(subcategoryId: subCatId, completion: { (microCategories) in
                        self.tabController?.showThemedLoader(false)
                        self.microCategories = microCategories
                        if let microCategories = microCategories, microCategories.count > 0{
                            self.configureForm(isMicroCatAvailable: true)
                        }else{
                            self.configureForm(isMicroCatAvailable: false)
                        }
                    })
                }
            }
        }
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
                    
                    self.scrollView.isHidden = false
                    return
            }
            
//            if tag == 0 {
//                self.configureForm(isMicroCatAvailable: false)
//            }else{
//                self.configureForm(isMicroCatAvailable: true)
//            }
            let dropDown = DropDown()
            dropDown.dataSource = subcats.map{ $0.name ?? "" }
            dropDown.shadowRadius = 1
            dropDown.shadowOpacity = 0.2
            dropDown.bottomOffset = CGPoint(x: 0, y:(sender.bounds.size.height + 5))
            dropDown.dismissMode = .automatic
            dropDown.show()
            dropDown.anchorView = sender
            dropDown.selectionAction = {[weak self] (index: Int, item: String) in
                guard let strongSelf = self else{ return }
                strongSelf.selectionData[strongSelf.selectedSubCategoryName] = item
                let selectedSubCat = subcats[index]
                if let subCatId = selectedSubCat.subCatId {
                    strongSelf.selectionData[strongSelf.selectedSubCategoryValue] = subCatId
                }
                
                // configure
                strongSelf.lblSelectedCategory.text = "\(item)"
                if let previousSelected = strongSelf.previousSelectedSection{
                    previousSelected.isSectionSelected = false
                }
                strongSelf.isLocal.curState = (selectedSubCat.isLocal)! == true ? .L : .R
                sender.isSectionSelected = true
                strongSelf.previousSelectedSection = sender
                strongSelf.scrollView.isHidden = false
//                if let isMicroCategoryAvailable = selectedCategory.isMicroCategoryAvailable, isMicroCategoryAvailable {
//                    let selectedSubCat = subcats[index]
                    if let subCatId = selectedSubCat.subCatId{
                        // get micro categories for selected subcategory.
                        strongSelf.tabController?.showThemedLoader(true)
                        strongSelf.interactor.getMicroCategoriesFor(subcategoryId: subCatId, completion: { (microCategories) in
                            strongSelf.tabController?.showThemedLoader(false)
                            strongSelf.microCategories = microCategories
                            if let microCategories = microCategories, microCategories.count > 0{
                                strongSelf.configureForm(isMicroCatAvailable: true)
                            }else{
                                strongSelf.configureForm(isMicroCatAvailable: false)
                            }
                        })
                    }
            }
            
        }
    }
    @IBAction func addSuggestion(_ sender: Any) {
        
        guard name.isValid() && (details.text.count > 5) else {
            
            return
        }
        
        var postParam =  [String:Any]()
        if let contactID = APIGateway.shared.loginData?.loginDetail?.contactId{
            postParam["contactId"] = contactID
            postParam["sourceId"] = contactID
        }
        if let catId = selectedCategory?.catId {
            postParam["catId"] = catId
        }
        
        if let subCategoryId = selectedSubCategory?.subCatId{
            postParam["subCategoryId"] = subCategoryId
        }
        if let microCategory = selectedMicroCategoryName{
            postParam["microcategory"] = microCategory
        }
        
        postParam["businessName"] = name.textField.text
        if let local = selectedSubCategory?.isLocal{
            postParam["citiLevelBusiness"] = local == true ? "true" : "false"
        }
//         = )! == true ? "true" : "false"
        postParam["businessContact"] = contact.textField.text
        postParam["location"] = location.textField.text
        postParam["comments"] = details.text
        postParam["isAChain"] = isAChain.curState == .L ? "true" : "false"
        postParam["platForm"] = "1"
        postParam["city"] = "1"
//        postParam["usedTagSuggetion"] = "false"
//        postParam["requestID"] = "1"
        if let locID = locationId{
            postParam["locationId"] = "\(locID)"
        }
        
        postParam["areaShortCode"] = "HAR"
        
        interactor.postSuggestion(forparams: postParam) { (success) in
            let alert = UIAlertController(title: "Success", message: "Added Suggestion Succesfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func addLocation(_ sender: UIButton) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addContact(_ sender: UIButton) {
        let contactsPicker = CNContactPickerViewController()
        contactsPicker.isEditing = true
        
        contactsPicker.delegate = self
        self.present(contactsPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let fetchName = contact.givenName
        _ = contact.phoneNumbers
        var phoneNo = ""
        for number in contact.phoneNumbers{
            if contact.givenName.count > 0 && number.value.stringValue.count > 8{
                var numString = number.value.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
                // print("\(numString) - \(numString.letterize().count)")
                numString = numString.replacingOccurrences(of: "(", with: "")
                numString = numString.replacingOccurrences(of: ")", with: "")
                numString = numString.replacingOccurrences(of: "-", with: "")
                numString = numString.replacingOccurrences(of: " ", with: "")
                numString = numString.replacingOccurrences(of: "\u{00a0}", with: "")
                
                //print("\(numString) - \(numString.letterize().count)")
                phoneNo = numString
                
                print("contact details are \(contact.givenName) \(numString) ")
                break
            }
        }
        
        
        self.contact.textField.text = phoneNo
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
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
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self else{ return }
            strongSelf.selectionData[strongSelf.selectedMicroCategoryValue] = item
        }
        
        dropDown.show()
    }
}

extension AddSuggestionViewController{
    
    func validateAllMandatoryFields() {
        let isValidForm = name.isValid() && contact.isValid() && microCat1.isValid() && (details.text.count > 5)
        if isValidForm {
            self.addButton.isEnabled = true
        }else{
            self.addButton.isEnabled = false
        }
        
    }
    
    func configureForm(isMicroCatAvailable: Bool){
        guard let category = selectedCategory, let subCats = category.subCategories, subCats.count > 0 else { return }
        
        microCat1.ownerHeightConstraint = microCat1Height
        microCat2.ownerHeightConstraint = microCat2Height
        microCat2.isOtherNeeded = true
        if let microCategories = self.microCategories, isMicroCatAvailable{
            microCat1.hide(true)
            microCat1.textField.tag = 1001
            microCat2.hide(false)
            microCat2.textDelegate = self
            microCat2.textField.tag = 1001
            microCat1.textField.isEnabled = false
            microCat2.hookDropdown(placeHolder: "Subcategory *", dataSource: microCategories.map({ (microCategory) -> String in
                self.selectedMicroCategoryName = microCategory.name
                if let name = microCategory.name{
                    return name.replacingOccurrences(of: " © ", with: "~")
                }
                return ""
            }), selectionCompletion: {[weak self] (index, item) in
                guard let strongSelf = self else { return }
                strongSelf.microCat1.hide(false)
                strongSelf.microCat2.textDelegate = self
                let microCatComponents = item.components(separatedBy: "~")
                if let microCatPart1 = microCatComponents.first{
                    strongSelf.microCat1.textField.text = microCatPart1
                }
                if microCatComponents.count > 1 {
                    let microCatPart2 = microCatComponents[1]
                    strongSelf.microCat2.textField.text = microCatPart2
                }
            })
        }else{
            microCat1.hide(true)
            microCat1.hookDropdown(placeHolder: "", dataSource: nil, selectionCompletion: nil)
            microCat2.hookDropdown(placeHolder: "", dataSource: nil, selectionCompletion: nil)
            microCat2.hide(true)
            
        }
        name.placeholder = "Name (Individual or Company) *"
        name.isMandatory = true
        name.textField.delegate = self
        contact.placeholder = "Contact number"
        contact.textField.delegate = self
        details.layer.cornerRadius = 4
        details.layer.borderColor = Theme.blue.cgColor
        details.layer.borderWidth = 0.9
        details.delegate = self
        details.contentInset = UIEdgeInsets.init(top: 5, left: 8, bottom: 5, right: 8)
        details.titleFont = Theme.avenirTitle!
        location.placeholder = "Location *"

//        print( isLocal.curState.hashValue)
//        isLocal.curState = .L
//        print( isLocal.curState.hashValue)
//        isLocal.curState = .R
//        print( isLocal.curState.hashValue)
        location.isMandatory = true
        location.textField.delegate = self
        
    }
}


extension AddSuggestionViewController : UITextFieldDelegate, DropDownViewTextDelegate, UITextViewDelegate{
    func dropDownSearchPrefix(_ textField : UITextField) -> String {
        if textField.tag == 1001 {
            return microCat1.textField.text ?? ""
        }
        return ""
    }
    
    func dropDownTextFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 251, 0)
        if textField.tag == 1001 {
            scrollView.scrollToView(view: contact, animated: true)
        }
    }
    
    func dropDownTextFieldDidEndEditing(_ textField: UITextField) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        validateAllMandatoryFields()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 251, 0)
        if textField == location.textField{
            setDropDownForSelectedTextField()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == location.textField{
            let query = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            
            if query.trimmingCharacters(in: .whitespaces) != ""{
                locationInteractor.fetchLocationFromQuery(query) { [weak self] (locations) in
                    guard let strongSelf = self else{ return }
                    strongSelf.locations = locations
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var tag = textField.tag
        tag += 1
        
        if tag < 7 {
            if let view = view.viewWithTag(tag) as? UITextField {
                view.becomeFirstResponder()
            }
        } else if tag == 7 {
            if let view = view.viewWithTag(tag) as? UITextView {
                view.becomeFirstResponder()
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
    
    // TextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 251, 0)
        scrollView.scrollToView(view: contact, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
}

extension AddSuggestionViewController: AddLocationProtocol {
    func updateLocation(_ location: String) {
        print(location)
    }
}
extension AddSuggestionViewController {
    
    func setDropDownForSelectedTextField() {
        
        // The view to which the drop down will appear ondropDown = DropDown()
        dropDown.anchorView = location
        dropDown.shadowRadius = 1
        dropDown.shadowOpacity = 0.2
        dropDown.bottomOffset = CGPoint(x: 0, y:60)
        dropDown.dismissMode = .automatic
        dropDown.direction = .bottom
    }
    
    func updateDataSourceForDropDown() {
        
        // The list of items to display. Can be changed dynamically
        guard let locations = locations else { return }
        if location.textField.text?.trimmingCharacters(in: .whitespaces) != ""{
            dropDown.dataSource = locations.map({ (location) in
                if let name = location.locationName, let suburb = location.suburb{
                    if name.count > 0 {
                        return "\(name) - \(suburb)"
                    }
                    return "\(suburb)"
                }
                return ""
            })
        }else{
            dropDown.dataSource = []
        }
        
        dropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let strongSelf = self else{
                return
            }
            let selectedLocation = locations[index]
            strongSelf.location.textField.text = selectedLocation.locSuburb
            strongSelf.locationId = selectedLocation.locationId
        }
        
        dropDown.show()
    }
    
}

extension AddSuggestionViewController : LabelSwitchDelegate{
    func switchChangeToState(_ state: SwitchState, control: LabelSwitch) {
        
    }
    
    
}
