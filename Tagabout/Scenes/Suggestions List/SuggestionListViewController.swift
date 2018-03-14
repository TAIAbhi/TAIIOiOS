//
//  SuggestionListViewController.swift
//  Tagabout
//
//  Created by Madanlal on 11/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

class SuggestionListViewController: UIViewController {

    lazy var interactor = SuggestionListInteractor()
    var hangoutsCategory: Category? {
        didSet {
            hangoutsButton.setTitle(hangoutsCategory?.name, for: .normal)
        }
    }
    var servicesCategory: Category? {
        didSet {
            servicesButton.setTitle(servicesCategory?.name, for: .normal)
        }
    }
    var shoppingCategory: Category? {
        didSet {
            shoppingButton.setTitle(shoppingCategory?.name, for: .normal)
        }
    }
    
    var selectedCategory: Category? {
        didSet {
            showSubCatPicker()
        }
    }
    var selectedSubCategory: Subcategory?
    lazy var tableViewDataSource = SuggestionListTableViewDataSource()
    
    @IBOutlet weak var hangoutsButton: UIButton!
    @IBOutlet weak var servicesButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var suggestionsTableView: UITableView!
    
    var subCatPicker: UIPickerView?
    lazy var subCategoryPickerView: UIView = {
        let viewWidth = self.view.bounds.width
        
        let wrapperView = UIView.init(frame: CGRect.init(x: 0, y: self.view.bounds.height, width: viewWidth, height: 289))
        
        subCatPicker = UIPickerView.init(frame: CGRect.init(x: 0, y: 39, width: viewWidth, height: 251))
        subCatPicker?.dataSource = self
        subCatPicker?.delegate = self
        subCatPicker?.showsSelectionIndicator = false
        wrapperView.addSubview(subCatPicker!)
        
        let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: viewWidth, height: 38))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SuggestionListViewController.pickerDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SuggestionListViewController.pickerCancel))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        wrapperView.addSubview(toolBar)
        
        return wrapperView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.fetchSuggestionCategories { (categories) in
            self.updateCategoryButtons(categories)
        }
        
        view.addSubview(subCategoryPickerView)
        
        suggestionsTableView.dataSource = tableViewDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: IBActions
    // Tags provided in storyboard
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 1:
            openSubCatPickerFor(hangoutsCategory)
            break
        case 2:
            openSubCatPickerFor(servicesCategory)
            break
        case 3:
            openSubCatPickerFor(shoppingCategory)
            break
        default:
            break
        }
    }
    
}

// MARK: Category handling
extension SuggestionListViewController {
    func updateCategoryButtons(_ categories: [Category]) {
        for category in categories {
            guard let catId = category.catId else { return }
            switch catId {
            case 1:
                hangoutsCategory = category
                break
            case 2:
                servicesCategory = category
                break
            case 3:
                shoppingCategory = category
                break
            default:
                break
            }
        }
    }
    
    func openSubCatPickerFor(_ category: Category?) {
        guard let category = category else { return }
        selectedCategory = category
    }
}

// MARk: UIPickerview
extension SuggestionListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func showSubCatPicker() {
        subCatPicker?.reloadAllComponents()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.subCategoryPickerView.frame = CGRect.init(x: 0, y: self.view.bounds.height - 289, width: self.view.bounds.width, height: 289)
        }, completion: { (done) in
            
        })
    }
    
    func hideSubCatPicker() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.subCategoryPickerView.frame = CGRect.init(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 289)
        }, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedCategory?.subCategories?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let subCats = selectedCategory?.subCategories {
            return subCats[row].name ?? ""
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let subCats = selectedCategory?.subCategories {
            selectedSubCategory = subCats[row]
        }
        
    }
    
    @objc func pickerDone() {
        hideSubCatPicker()
        if let catId = selectedSubCategory?.catId, let subCatId = selectedSubCategory?.subCatId {
            interactor.fetchSuggestionsFor(category: catId, and: subCatId, with: { (suggestions) in
                self.tableViewDataSource.setData(suggestions)
                self.suggestionsTableView.reloadData()
            })
        }
        
    }
    
    @objc func pickerCancel() {
        hideSubCatPicker()
    }
}
