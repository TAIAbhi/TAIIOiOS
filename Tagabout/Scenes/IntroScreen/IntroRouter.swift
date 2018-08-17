//
//  IntroRouter.swift
//  Tagabout
//
//  Created by Arun Jangid on 04/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class IntroRouter{
    private var introViewController : IntroViewController!
    
    init(with introViewController: IntroViewController) {
        self.introViewController = introViewController
    }
    
    func navigateToLanding(){
        if let window = UIApplication.shared.keyWindow {
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight, animations: {
                window.rootViewController = LandingViewController.landingViewController()
            }, completion: nil)
        }
    }
    
    func navigateToVideo(){
       
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        self.navigateToLanding()
    }
    
}
