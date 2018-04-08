//
//  HelpRouter.swift
//  Tagabout
//
//  Created by Karun Pant on 07/04/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import UIKit

struct HelpRouter {
    static func helpScene(for help: Help) -> HelpScenePager?{
        let storyBoard = UIStoryboard.init(name: "HelpScenes", bundle: Bundle.main)
        if let helpScenes: HelpScenePager = storyBoard.instantiateViewController(withIdentifier: "HelpScenePager") as? HelpScenePager{
            helpScenes.forHelp = help
            return helpScenes
        }
        return nil
    }
    static func openDesiredScreen(moduleName : ModuleNames){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let tabBar = appDelegate.window?.rootViewController as? TabbarController else { return  }
        switch  moduleName{
        case .ASH:
            tabBar.selectedIndex = 1
            break
        case .ASW:
            tabBar.selectedIndex = 1
            break
        case .FBH:
            tabBar.selectedIndex = 2
            break
        case .FBW:
            tabBar.selectedIndex = 2
            break
        case .FSH:
            tabBar.selectedIndex = 2
            break
        case .FSW:
            tabBar.selectedIndex = 2
            break
        case .MDH:
            tabBar.selectedIndex = 2
            break
        case .MDW:
            tabBar.selectedIndex = 2
            break
        }
    }
}
