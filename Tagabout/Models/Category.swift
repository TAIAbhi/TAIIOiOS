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
    var subCategories: [Subcategory]?
    
    init(_ data: [String: Any]) {
        self.catId = data["catId"] as? Int ?? 0
        self.name = data["name"] as? String ?? ""
        self.isMicroCategoryAvailable = data["isMicroCategoryAvailable"] as? Bool ?? false
        
        var subCatArray = [Subcategory]()
        if let subCats = data["subCategories"] as? [[String: Any]], subCats.count > 0 {
            for s in subCats {
                subCatArray.append(Subcategory(s))
            }
        }
        self.subCategories = subCatArray
    }
}

struct Subcategory : Codable{
    var subCatId : Int?
    var catId : Int?
    var name : String?
    var microCategoryToolTip : String?
    var comments : String?
    var commentsToolTip : String?
    
    init(_ data: [String: Any]) {
        self.catId = data["catId"] as? Int ?? 0
        self.commentsToolTip = data["commesntsToolTip"] as? String ?? ""
        self.microCategoryToolTip = data["microCategoryToolTip"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.subCatId = data["subCatId"] as? Int ?? 0
    }
}

struct MicroCategory : Codable {
    var microId : Int?
    var name: String?
}
