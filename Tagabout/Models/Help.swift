//
//  Help.swift
//  Tagabout
//
//  Created by Karun Pant on 07/04/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

enum ModuleNames : String {
    case ASH = "ASH"
    case ASW = "ASW"
    case MDH = "MDH"
    case MDW = "MDW"
    case FBH = "FBH"
    case FBW = "FBW"
    case FSH = "FSH"
    case FSW = "FSW"
    
    static let allValues : [ModuleNames] = [.ASH,.ASW,.MDH,.MDW,.FBH,.FBW,.FSH,.FSW]
    
}

struct Help : Codable{
    var moduleName : String?
    var moduleTitle : String?
    var pageData : [PageData]?
}
struct PageData : Codable {
    var link : String?
    var text: String?
}

