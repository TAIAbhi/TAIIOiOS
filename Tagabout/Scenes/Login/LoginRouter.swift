//
//  LoginRouter.swift
//  Tagabout
//
//  Created by Madanlal on 11/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import UIKit

class LoginRouter {
    private weak var loginController: LoginViewController?
    
    init(with loginController: LoginViewController) {
        self.loginController = loginController
    }
    
    func navigateToAddSuggestion() {
        let storyBoard = UIStoryboard.init(name: "UserStory", bundle: Bundle.main)
        if let addSuggestionVc: AddSuggestionViewController = storyBoard.instantiateViewController(withIdentifier: "AddSuggestionViewController") as? AddSuggestionViewController, let window = UIApplication.shared.keyWindow {
            let navVc = UINavigationController(rootViewController: addSuggestionVc)
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navVc
            }, completion: nil)
        }
    }
    
    func navigateToSuggestionList() {
        let storyBoard = UIStoryboard.init(name: "UserStory", bundle: Bundle.main)
        if let addSuggestionVc: SuggestionListViewController = storyBoard.instantiateViewController(withIdentifier: "SuggestionListViewController") as? SuggestionListViewController, let window = UIApplication.shared.keyWindow {
            let navVc = UINavigationController(rootViewController: addSuggestionVc)
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navVc
            }, completion: nil)
        }
    }
}
