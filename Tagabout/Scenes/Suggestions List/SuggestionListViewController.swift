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
            hangoutsButton.setTitle("Hangouts (\(hangoutDatasource.count))".uppercased(), for: .normal)
        }
    }
    var servicesDatasource = [CategoryCountData](){
        didSet{
           servicesButton.setTitle("Services (\(servicesDatasource.count))".uppercased(), for: .normal)
        }
    }
    
    var shoppingDatasource = [CategoryCountData](){
        didSet{
            shoppingButton.setTitle("Shopping (\(shoppingDatasource.count))", for: .normal)
        }
    }
    
    @IBOutlet weak var hangoutsButton: UIButton!
    @IBOutlet weak var servicesButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var suggestionsTableView: UITableView!
    @IBOutlet weak var sugesstionsTypeSwitch: LabelSwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Suggestions"
        
        sugesstionsTypeSwitch.delegate = self
        
        
        if (self.tabBarController?.isKind(of: TabbarController.self))!{
            let tabVC = self.tabBarController as! TabbarController
            tabVC.landingViewController.dismissView = { filter, hangoutDatasource, serviceDatasource, shoppingdatasource in
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
            
        }
        
        
        
        suggestionsTableView.dataSource = tableViewDataSource
        suggestionsTableView.tableFooterView = UIView()
        tableViewDataSource.editHandler = { suggestion in
            self.routerEditSuggestion(suggestion)
        }
    }
    
    
    
    // MARK: IBActions
    // Tags provided in storyboard
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 1:
            openSubCatPickerFor(hangoutDatasource, withAnchor: hangoutsButton)
            break
        case 2:
            openSubCatPickerFor(servicesDatasource, withAnchor: servicesButton)
            break
        case 3:
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
        dropDown.dataSource = categories.map({$0.categoryName! == "0" ? "All" + "(\($0.suggCount!))" : $0.categoryName! + "(\($0.suggCount!))" })
        
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
