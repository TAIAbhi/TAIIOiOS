//
//  ViewController.swift
//  Tagabout
//
//  Created by Arun Jangid on 02/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var logoTappedHandler:(() -> ())!
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
        self.navigationItem.leftBarButtonItem = setupLogo()
        self.navigationItem.rightBarButtonItems = [getnotificationButton(), getCallButton()]
    }
    
    
    func setupLogo() -> UIBarButtonItem{
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "head_blue"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(logoButtonTapped(_:)), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 184, height: 44) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        return barButton
    }
    
    @objc func logoButtonTapped(_ sender:UIButton){
        if logoTappedHandler != nil {
            logoTappedHandler!()
        }
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
