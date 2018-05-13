
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
}
