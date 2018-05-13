//
//  SuggestionListViewController.swift
//  Tagabout
//
//  Created by Madanlal on 11/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import DropDown
import LabelSwitch

class SuggestionListViewController: UIViewController {

    lazy var interactor = SuggestionListInteractor()
    lazy var router = SuggestionListRouter(with: self)
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
    lazy var filter = SuggestionFilter()
    lazy var suggestions = [Suggestion]()
    
    @IBOutlet weak var hangoutsButton: UIButton!
    @IBOutlet weak var servicesButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var suggestionsTableView: UITableView!
    @IBOutlet weak var sugesstionsTypeSwitch: LabelSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Suggestions"
        
        sugesstionsTypeSwitch.delegate = self
        
        interactor.fetchSuggestionCategories { [weak self] (categories) in
            guard let strongSelf = self else{ return }
            strongSelf.updateCategoryButtons(categories)
            guard let cat = categories.first else { return }
            if let catId = cat.catId, let subCat = cat.subCategories?.first, let subCatId = subCat.subCatId {
                strongSelf.filter.setCat(catId, andSubCat: subCatId)
                strongSelf.fetchSuggestions()
            }
        }
        
        suggestionsTableView.dataSource = tableViewDataSource
        suggestionsTableView.tableFooterView = UIView()
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
    
    @IBAction func filtersButtonTapped(_ sender: Any) {
        router.presentFilters()
    }
    
    func fetchSuggestions() {
        interactor.fetchSuggestionsWithFilter(filter) { [weak self] (suggestions) in
            guard let strongSelf = self else { return }
            if strongSelf.filter.pageNumber > 1 {
                strongSelf.suggestions.append(contentsOf: suggestions)
                // think about realoading sections
            } else {
                strongSelf.suggestions = suggestions
                strongSelf.tableViewDataSource.setData(suggestions)
                strongSelf.suggestionsTableView.setContentOffset(.zero, animated: false)
                strongSelf.suggestionsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
            }
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
                strongSelf.filter.setCat(catId, andSubCat: subCatId)
                strongSelf.fetchSuggestions()
            }
        }
        
        dropDown.show()
    }
    
}

extension SuggestionListViewController: LabelSwitchDelegate {
    func switchChangeToState(_ state: SwitchState, control: LabelSwitch) {
        filter.toggleGetAll()
        fetchSuggestions()
    }
}

// MARK: Tableview delegate
extension SuggestionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
