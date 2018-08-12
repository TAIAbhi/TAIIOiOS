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
        self.landingViewController.navigationController?.pushViewController(TabbarController.tabBarController(withSelectedIndex: 0), animated: true)
        
    }
    
    func navigateToTabbarMydetails(){
        self.landingViewController.navigationController?.pushViewController(TabbarController.tabBarController(withSelectedIndex: 2), animated: true)
    }
    
    
}
