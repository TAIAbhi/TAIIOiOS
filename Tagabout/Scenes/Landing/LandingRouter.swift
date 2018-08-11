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
    
    func navigateToTabbar(){
        let storyBoard = UIStoryboard.init(name: "UserStory", bundle: Bundle.main)
        if let tabVC = storyBoard.instantiateViewController(withIdentifier: "TabbarController") as? TabbarController{
            self.landingViewController.navigationController?.pushViewController(tabVC, animated: true)
        }
    }
    
    
}
