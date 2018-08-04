//
//  AppStoyboard.swift
//  Tagabout
//
//  Created by Arun Jangid on 03/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

enum AppStoryboard : String {
    case UserStory = "UserStory"
    case LandingScene = "LandingScene"
    case VideoplayerScene = "VideoplayerScene"
    
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : ViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as ViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> ViewController? {
        return instance.instantiateInitialViewController() as? ViewController
    }
}
