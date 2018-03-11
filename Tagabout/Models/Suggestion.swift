//
//  Suggestion.swift
//  Tagabout
//
//  Created by Karun Pant on 09/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

struct Suggestion : Codable{
    
    var sourceId : Int?
    var contactId : Int?
    var subcategoryId : Int?
    var catId : Int?
    var microCategoryId : Int?
    var businessName : String?
    var businessContact : String?
    var location : Location?
    
}

struct Location : Codable{
    var locationId : Int?
    var city : String?
    var area : String?
    var suburb : String?
    var locationName : String?
}


