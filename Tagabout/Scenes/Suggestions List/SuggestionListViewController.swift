//
//  SuggestionListViewController.swift
//  Tagabout
//
//  Created by Madanlal on 11/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import DropDown

class SuggestionListViewController: UIViewController {

    lazy var interactor = SuggestionListInteractor()
    var hangoutsCategory: Category? {
        didSet {
            hangoutsButton.setTitle(hangoutsCategory?.name?.uppercased(), for: .normal)
        }
    }
    var servicesCategory: Category? {
        didSet {
            servicesButton.setTitle(servicesCategory?.name?.uppercased(), for: .normal)
        }
    }
    var shoppingCategory: Category? {
        didSet {
            shoppingButton.setTitle(shoppingCategory?.name?.uppercased(), for: .normal)
        }
    }
    
    lazy var tableViewDataSource = SuggestionListTableViewDataSource()
    
    @IBOutlet weak var hangoutsButton: UIButton!
    @IBOutlet weak var servicesButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var suggestionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Suggestions"
        
        interactor.fetchSuggestionCategories { [weak self] (categories) in
            guard let strongSelf = self else{ return }
            strongSelf.updateCategoryButtons(categories)
        }
        
        suggestionsTableView.dataSource = tableViewDataSource
        suggestionsTableView.tableFooterView = UIView()
        
<<<<<<< HEAD
        interactor.fetchAllMySuggestions { [weak self] (suggestions) in
            guard let strongSelf = self else{ return }
            strongSelf.setTableViewData(suggestions)
=======
        interactor.fetchAllSuggestions { [unowned self] (suggestions) in
            var tDict = [String: Any]()
            for s in suggestions {
                guard let subCatId = s.subCategoryId else { break }
                
            }
            self.setTableViewData(suggestions)
>>>>>>> WIP suggestions list
        }
    }
    
    // MARK: IBActions
    // Tags provided in storyboard
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 1:
            openSubCatPickerFor(hangoutsCategory, withAnchor: hangoutsButton)
            break
        case 2:
            openSubCatPickerFor(servicesCategory, withAnchor: servicesButton)
            break
        case 3:
            openSubCatPickerFor(shoppingCategory, withAnchor: shoppingButton)
            break
        default:
            break
        }
    }
    
    func setTableViewData(_ suggestions: [Suggestion]) {
        self.tableViewDataSource.setData(suggestions)
        self.suggestionsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
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
    
    func openSubCatPickerFor(_ category: Category?, withAnchor anchor: UIButton) {
        
        guard let category = category, let subCats = category.subCategories, subCats.count > 0 else { return }
        
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = anchor // UIView or UIBarButtonItem
        dropDown.direction = .bottom
        dropDown.shadowRadius = 1
        dropDown.shadowOpacity = 0.2
        dropDown.bottomOffset = CGPoint(x: 0, y:38)
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = subCats.map({ (subCat) in
            if let name = subCat.name {
                return name
            }
            return ""
        })
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self else{ return }
            let selectedSubCat = subCats[index]
            if let catId = selectedSubCat.catId, let subCatId = selectedSubCat.subCatId {
                strongSelf.interactor.fetchSuggestionsFor(category: catId, and: subCatId, with: { (suggestions) in
                    strongSelf.setTableViewData(suggestions)
                })
            }
        }
        
        dropDown.show()
    }
}
