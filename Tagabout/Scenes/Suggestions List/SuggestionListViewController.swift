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
    var hangoutDatasource = [CategoryCountData](){
        didSet{
            if let hangoutItem = hangoutDatasource.filter({ $0.categoryName == "0"}).first, let count = hangoutItem.suggCount{
                hangoutsButton.setTitle("Hangouts (\(count))".uppercased(), for: .normal)
            }
        }
    }
    var servicesDatasource = [CategoryCountData](){
        didSet{
            if let serviceItem = servicesDatasource.filter({ $0.categoryName == "0"}).first, let count = serviceItem.suggCount{
                servicesButton.setTitle("Services (\(count))".uppercased(), for: .normal)
            }
        }
    }
    
    var shoppingDatasource = [CategoryCountData](){
        didSet{
            if let shoppingItem = shoppingDatasource.filter({ $0.categoryName == "0"}).first, let count = shoppingItem.suggCount{
                shoppingButton.setTitle("Shopping (\(count))", for: .normal)
            }
            
        }
    }
    
    @IBOutlet weak var hangoutsButton: UIButton!
    @IBOutlet weak var servicesButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var suggestionsTableView: UITableView!
    @IBOutlet weak var sugesstionsTypeSwitch: LabelSwitch!
    var isProvideSuggestion : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Suggestions"
        
        sugesstionsTypeSwitch.delegate = self
        
        self.swipeActionFromLandingScreen()
        
        suggestionsTableView.dataSource = tableViewDataSource
        suggestionsTableView.tableFooterView = UIView()
        tableViewDataSource.editHandler = { suggestion in
            self.routerEditSuggestion(suggestion)
        }
    }
    
    
    func swipeActionFromLandingScreen(){
        if (self.tabBarController?.isKind(of: TabbarController.self))!{
            let tabVC = self.tabBarController as! TabbarController
            tabVC.landingViewController.dismissView = { filter, hangoutDatasource, serviceDatasource, shoppingdatasource in
                self.tabBarController?.selectedIndex = 0
                self.isProvideSuggestion = false
                self.filter = filter
                self.hangoutDatasource = hangoutDatasource
                self.servicesDatasource = serviceDatasource
                self.shoppingDatasource = shoppingdatasource
                if self.sugesstionsTypeSwitch.curState == .R {
                    self.filter.contactId = nil
                }else{
                    self.filter.contactId = APIGateway.shared.loginData?.loginDetail?.contactId
                }
                self.fetchSuggestions()
            }
            
            tabVC.landingViewController.downDismisHandler = { filter, hangoutDatasource, serviceDatasource, shoppingdatasource in
                self.tabBarController?.selectedIndex = 0
                self.isProvideSuggestion = false
                self.filter = filter
                self.hangoutDatasource = hangoutDatasource
                self.servicesDatasource = serviceDatasource
                self.shoppingDatasource = shoppingdatasource
                if self.sugesstionsTypeSwitch.curState == .R {
                    self.filter.contactId = nil
                }else{
                    self.filter.contactId = APIGateway.shared.loginData?.loginDetail?.contactId
                }
                self.fetchSuggestions()
                
            }
            
            tabVC.landingViewController.rightDismissHandler = { cityId in
                self.tabBarController?.selectedIndex = 0
                self.suggestions.removeAll()
                self.interactor.getCategories(forCityId: cityId, completion: { (category) in
                    self.isProvideSuggestion = true
                    if let categories = category{
                        self.updateCategoryButtons(categories)
                    }
                    guard let cat = category?.first else { return }
                    if let catId = cat.catId, let subCat = cat.subCategories?.first, let subCatId = subCat.subCatId {
                        self.filter.setCat(catId, andSubCat: subCatId)
                        self.fetchSuggestions()
                    }
                })
            }
            
            tabVC.landingViewController.topDismissHandler = { selectedFilter in
                self.tabBarController?.selectedIndex = 1
                if let viewController  = self.tabBarController?.viewControllers?[1] as? AddSuggestionViewController{
                    if viewController.topDismissHandler != nil {
                        viewController.topDismissHandler(selectedFilter)
                    }
                    
                }
                
            }
            
            
            tabVC.landingViewController.leftDismissHandler = { cityId in
                self.router.showRequestSuggestion(forCityId: cityId)
            }
        }

    }
    
    
    // MARK: IBActions
    // Tags provided in storyboard
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 1:
            if isProvideSuggestion {
                openSubCatPickerFor(hangoutsCategory, withAnchor: hangoutsButton)
                return
            }
            openSubCatPickerFor(hangoutDatasource, withAnchor: hangoutsButton)
            break
        case 2:
            if isProvideSuggestion {
                openSubCatPickerFor(servicesCategory, withAnchor: servicesButton)
                return
            }
            openSubCatPickerFor(servicesDatasource, withAnchor: servicesButton)
            break
        case 3:
            if isProvideSuggestion {
                openSubCatPickerFor(shoppingCategory, withAnchor: shoppingButton)
                return
            }
            
            openSubCatPickerFor(shoppingDatasource, withAnchor: shoppingButton)
            break
        default:
            break
        }
    }
    
    @IBAction func filtersButtonTapped(_ sender: Any) {
        router.presentFilters()
    }
    
    func routerEditSuggestion(_ suggestion:Suggestion){
        router.selectTabBar()
    }
    
    func fetchSuggestions() {
        if isProvideSuggestion {
            interactor.fetchRequestSuggestionsWithFilter(filter) {[weak self] (suggestions,pageInfo) in
                guard let strongSelf = self else { return }
                if strongSelf.filter.pageNumber > 1 {
                    strongSelf.suggestions.append(contentsOf: suggestions)
                    strongSelf.tableViewDataSource.setData(strongSelf.suggestions)
                    threadOnMain {
                        strongSelf.suggestionsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
                    }
                    
                } else {
                    strongSelf.suggestions = suggestions
                    strongSelf.tableViewDataSource.setData(suggestions)
                    strongSelf.suggestionsTableView.setContentOffset(.zero, animated: false)
                    strongSelf.suggestionsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
                }
                if let pageinfo = pageInfo{
                    if (pageinfo.noOfRecord)! > strongSelf.suggestions.count{
                        strongSelf.filter.setNextPage()
                        strongSelf.fetchSuggestions()
                    }
                }
            }
        }else{
        
        interactor.fetchSuggestionsWithFilter(filter) { [weak self] (suggestions,pageInfo) in
            guard let strongSelf = self else { return }
            if strongSelf.filter.pageNumber > 1 {
                strongSelf.suggestions.append(contentsOf: suggestions)
                strongSelf.tableViewDataSource.setData(strongSelf.suggestions)
                threadOnMain {
                    strongSelf.suggestionsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
                }
                
            } else {
                strongSelf.suggestions = suggestions
                strongSelf.tableViewDataSource.setData(suggestions)
                strongSelf.suggestionsTableView.setContentOffset(.zero, animated: false)
                strongSelf.suggestionsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
            }
            if let pageinfo = pageInfo{
                if (pageinfo.noOfRecord)! > strongSelf.suggestions.count{
                    strongSelf.filter.setNextPage()
                    strongSelf.fetchSuggestions()
                    }
                }
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
    
    func openSubCatPickerFor(_ categories: [CategoryCountData]?, withAnchor anchor: UIButton) {
        
        guard let categories = categories, categories.count > 0 else { return }
        
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = anchor // UIView or UIBarButtonItem
        dropDown.direction = .bottom
        dropDown.shadowRadius = 1
        dropDown.shadowOpacity = 0.2
        dropDown.bottomOffset = CGPoint(x: 0, y:38)
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = categories.map({$0.categoryName! == "0" ? "All" + " (\($0.suggCount!))" : $0.categoryName! + " (\($0.suggCount!))" })
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self else{ return }
            let selectedCategories = categories[index]
            strongSelf.filter.catId = selectedCategories.catId
            strongSelf.filter.subCatId = selectedCategories.subCatId
            strongSelf.filter.pageNumber = 1
            strongSelf.filter.isLocal = selectedCategories.isLocal
            if strongSelf.sugesstionsTypeSwitch.curState == .R {
                strongSelf.filter.contactId = nil
            }else{
                strongSelf.filter.contactId = APIGateway.shared.loginData?.loginDetail?.contactId
            }
            strongSelf.fetchSuggestions()
        }
        
        dropDown.show()
    }
    
    func openSubCatPickerFor(_ category: Category?, withAnchor anchor: UIButton) {
            guard let category = category, let subCats = category.subCategories, subCats.count > 0 else { return }
                let dropDown = DropDown()
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
        
        if sugesstionsTypeSwitch.curState == .R {
            filter.contactId = nil
        }else{
            filter.contactId = APIGateway.shared.loginData?.loginDetail?.contactId
        }
        filter.pageNumber = 1
        fetchSuggestions()
    }
}

// MARK: Tableview delegate
extension SuggestionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
