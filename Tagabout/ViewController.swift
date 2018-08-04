//
//  ViewController.swift
//  Tagabout
//
//  Created by Arun Jangid on 02/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }

    func setupNavigationBar(){
        self.navigationController?.navigationBar.setupLogo()
        self.navigationItem.rightBarButtonItems = [getnotificationButton(), getCallButton()]
    }
    
    func getCallButton() -> UIBarButtonItem{
        let button = TAIAction.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "call"), for: UIControlState.normal)
        button.tag = 1
        button.addTarget(self, action:#selector(TabbarController.barButtonClicked), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        return barButton
        
    }
    func getnotificationButton() -> UIBarButtonItem{
        let button = TAIAction.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "bell"), for: UIControlState.normal)
        button.tag = 2
        button.addTarget(self, action:#selector(TabbarController.barButtonClicked), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        return barButton
    }
}
