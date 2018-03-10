//
//  Category.swift
//  Tagabout
//
//  Created by Karun Pant on 10/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

struct Category : Codable{
    var catId : Int?
    var name : String?
    var isMicroCategoryAvailable : Bool?
}

struct Subcategory : Codable{
    var subCatId : Int?
    var catId : Int?
    var name : String?
    var microCategoryToolTip : String?
    var comments : String?
    var commentsToolTip : String?
}

struct MicroCategory : Codable {
    var microId : Int?
    var name: String?
}
