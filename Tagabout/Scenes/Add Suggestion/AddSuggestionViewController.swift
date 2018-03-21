//
//  AddSuggestionViewController.swift
//  Tagabout
//
//  Created by Karun Pant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit



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
    
    var isForEdit: Bool = false
    var categories : [Category]?
    // fill contact details
    var selectedCategory : Category?
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
    
    @IBOutlet weak var processing: UIActivityIndicatorView!
    @IBOutlet weak var section1: TAISection!
    @IBOutlet weak var section2: TAISection!
    @IBOutlet weak var section3: TAISection!
    @IBOutlet weak var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.processing.startAnimating()
        self.tableView.tableHeaderView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: UIScreen.main.bounds.size.width, height: 40)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddSuggestionViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddSuggestionViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       interactor.getCategories { [unowned self] categories in
            self.processing.stopAnimating()
            if let categories = categories{
                self.categories = categories
                self.selectedCategory = categories[0] // preselection
                self.previousSelectedSection = self.section1
                self.section1.isSectionSelected = true
                if categories.count >= 3{
                    self.section1.setTitle(categories[0].name!, for: .normal)
                    self.section2.setTitle(categories[1].name!, for: .normal)
                    self.section3.setTitle(categories[2].name!, for: .normal)
                }
                self.tableView.reloadData()
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
            
            self.tableView.reloadData()
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddSuggestionViewController : UITabBarDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var isSubCatAvailable = false
        if let selectedCategory = selectedCategory{
            if let microcatAvailable = selectedCategory.isMicroCategoryAvailable, microcatAvailable {
                isSubCatAvailable = true
            }
        }
        switch indexPath.row {
        case 0:
            return configureCell(.subCategory, for: tableView)
        case 1:
            if isSubCatAvailable{
                return configureCell(.microCategory, for: tableView)
            }else{
                return configureCell(.name, for: tableView)
            }
        case 2:
            if isSubCatAvailable{
                return configureCell(.name, for: tableView)
            }else{
                return configureCell(.isCityLevel, for: tableView)
            }
        case 3:
            if isSubCatAvailable{
                return configureCell(.isCityLevel, for: tableView)
            }else{
                return configureCell(.contact, for: tableView)
            }
        case 4:
            if isSubCatAvailable{
                return configureCell(.contact, for: tableView)
            }else{
                return configureCell(.location, for: tableView)
            }
        case 5:
            if isSubCatAvailable{
                return configureCell(.location, for: tableView)
            }else{
                return configureCell(.comments, for: tableView)
            }
        case 6:
            return configureCell(.comments, for: tableView)
        default:
            return configureCell(.subCategory, for: tableView)
        }
    }
    
    func configureCell(_ cellIndex : AddSuggestionUIType, for tableView : UITableView) -> UITableViewCell{
        switch cellIndex {
        case .subCategory:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEntryField") as? SingleEntryField
            cell?.field.placeholder = "Category"
            return cell!
        case .microCategory:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MicroCategoryEntry") as? MicroCategoryEntry
            cell?.field1.placeholder = "Subcategory"
            cell?.field1.placeholder = "Enter tag type"
            return cell!
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEntryField") as? SingleEntryField
            cell?.field.placeholder = "Tag name"
            return cell!
        case .contact:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEntryField") as? SingleEntryField
            cell?.field.placeholder = "Tag contact"
            return cell!
        case .comments:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EntryForDetail") as? EntryForDetail
            cell?.title.text = "Tag details"
            cell?.details.layer.cornerRadius = 4
            cell?.details.layer.borderColor = UIColor.lightGray.cgColor
            cell?.details.layer.borderWidth = 0.9
            return cell!
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EntryWithAccessory") as? EntryWithAccessory
            cell?.field.placeholder = "Tag location"
            return cell!
        case .isCityLevel:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ISCityLevelEntryCell") as? ISCityLevelEntryCell
            if let isLocal = selectedCategory?.isLocal{
                cell?.isCityLevel.isOn = isLocal
            }else{
                cell?.isCityLevel.isOn = true
            }
            return cell!
            
        }
    }
}
