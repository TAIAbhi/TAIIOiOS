//
//  LandingRouter.swift
//  Tagabout
//
//  Created by Arun Jangid on 04/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

class LandingRouter{
 
    
    private var landingViewController : LandingViewController!
    
    init(with landingViewController: LandingViewController) {
        self.landingViewController = landingViewController
    }
    
    func navigateToTabbar(_ city:City, bindFilter:BindFilter, filter:SuggestionFilter){
        self.landingViewController.navigationController?.pushViewController(TabbarController.tabBarController(withSelectedIndex: 0, city: city, bindfilter: bindFilter, filter: filter), animated: true)
        
    }
    
    func navigateToTabbarMydetails(_ city:City, bindFilter:BindFilter, filter:SuggestionFilter){
        self.landingViewController.navigationController?.pushViewController(TabbarController.tabBarController(withSelectedIndex: 2, city: city,bindfilter: bindFilter, filter: filter), animated: true)
    }
    
    func navigateToAddSuggestion(){
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
    
}
