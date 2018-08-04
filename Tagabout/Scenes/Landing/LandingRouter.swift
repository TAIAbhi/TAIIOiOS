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
        if let navTabVC = storyBoard.instantiateViewController(withIdentifier: "parentNavigation") as? UINavigationController, let window = UIApplication.shared.keyWindow {
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight, animations: {
                window.rootViewController = navTabVC
            }, completion: nil)
        }
    }
    
    
}
