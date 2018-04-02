//
//  TabbarController.swift
//  Tagabout
//
//  Created by Karun Pant on 18/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import UIKit
class TabbarController : UITabBarController{
    override func viewDidLoad() {
        self.navigationController?.navigationBar.setupLogo()
        self.navigationItem.rightBarButtonItems = [getnotificationButton(), getCallButton()]
        super.viewDidLoad()
    }
    
    @objc func barButtonClicked(sender: UIButton){
        print("\(sender.tag == 1 ? "call" : "notification") clicked")
    }
    func getCallButton() -> UIBarButtonItem{
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "call"), for: UIControlState.normal)
        button.tag = 1
        button.addTarget(self, action:#selector(TabbarController.barButtonClicked), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        return barButton
    }
    func getnotificationButton() -> UIBarButtonItem{
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "bell"), for: UIControlState.normal)
        button.tag = 2
        button.addTarget(self, action:#selector(TabbarController.barButtonClicked), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        return barButton
    }
}
