
//
//  SugestionsListRouter.swift
//  Tagabout
//
//  Created by Madanlal on 07/04/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

struct SuggestionListRouter {
    
    private weak var viewController: SuggestionListViewController?
    
    init(with viewController: SuggestionListViewController) {
        self.viewController = viewController
    }
    
    func presentFilters() {
        viewController?.performSegue(withIdentifier: "SuggestionListToFilterSuggestion", sender: nil)
    }
    
    func selectTabBar(){
        viewController?.tabBarController?.selectedIndex = 1
    }
    
    func showRequestSuggestion(forCityId cityid:Int){
        viewController?.navigationController?.pushViewController(WebViewController.webViewController(forCityId: cityid), animated: true)
    }
}
