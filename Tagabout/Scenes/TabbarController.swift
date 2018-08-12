//
//  TabbarController.swift
//  Tagabout
//
//  Created by Karun Pant on 18/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import UIKit
import DropDown
//import Crashlytics

class TabbarController : UITabBarController{
    
    
    static func tabBarController(withSelectedIndex index:Int) -> TabbarController{
        let storyBoard = UIStoryboard.init(name: "UserStory", bundle: Bundle.main)
        let tabVC = storyBoard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        tabVC.selectedIndex = index
        return tabVC
    }
    
    
    var helpBarList: [Help]?
    var helpButton : UIButton?
    private var helpDropDown : DropDown?
    public var themedLoader : LoadingInteractor?
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.setupLogo()        
        self.navigationItem.rightBarButtonItems = [getnotificationButton(), getCallButton()]
        super.viewDidLoad()
        helpButton?.isEnabled = false
        HelpInteractor().fetchHelpData {[weak self] (helpArray) in
            guard let strongSelf = self else { return }
            strongSelf.helpBarList = helpArray
            strongSelf.helpButton?.isEnabled = true
        }
    }
    
    @objc func barButtonClicked(sender: UIButton){
        switch sender.tag {
        case 1:
            openHelpDropDown()
            break
        case 2:

            break
        default:
            print("something random happened")
        }
    }
    
    func showThemedLoader(_ shouldShowLoader : Bool){
        let topBar : CGFloat = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.bounds.size.height)!
        LoadingInteractor.shared.viewFrame = CGRect.init(x: 0, y: topBar, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - topBar - self.tabBar.bounds.size.height)
        LoadingInteractor.shared.color = UIColor.init(white: 0, alpha: 0.4)
        if shouldShowLoader {
            LoadingInteractor.shared.show()
        }else{
            LoadingInteractor.shared.hide()
        }
    }
    
    func openHelpDropDown(){
        guard let helpDatasource = helpBarList, helpDatasource.count > 0 else { return }
        if let helpDropDown = helpDropDown{
            helpDropDown.dataSource = helpDatasource.map({ (help) -> String in
                if let title = help.moduleTitle { return title } else { return "" }
            })
        }else{
            DropDown.startListeningToKeyboard()
            // The view to which the drop down will appear on
            helpDropDown = DropDown()
            helpDropDown?.anchorView = helpButton!
            helpDropDown?.shadowRadius = 1
            helpDropDown?.shadowOpacity = 0.2
            helpDropDown?.bottomOffset = CGPoint(x: 0, y:44)
            helpDropDown?.dismissMode = .automatic
            helpDropDown?.contentMode = .bottom
            helpDropDown?.dataSource = helpDatasource.map({ (help) -> String in
                if let title = help.moduleTitle { return title } else { return "" }
            })
            helpDropDown?.selectionAction = { [weak self] (index: Int, item: String) in
                guard let strongSelf = self else { return }
                strongSelf.openHelpScenes(for: index)
            }
        }
        helpDropDown?.show()
    }
    
    func openHelpScenes(for index: Int){
        
        guard let helpDataSource = helpBarList,
            let helpScene = HelpRouter.helpScene(for: helpDataSource[index]) else { return }
        self.present(helpScene, animated: true, completion: nil)
    }
    
    func getCallButton() -> UIBarButtonItem{
        helpButton = TAIAction.init(type: .custom)
        helpButton?.setImage(#imageLiteral(resourceName: "call"), for: UIControlState.normal)
        helpButton?.tag = 1
        helpButton?.addTarget(self, action:#selector(TabbarController.barButtonClicked), for:.touchUpInside)
        helpButton?.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: helpButton!)
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
