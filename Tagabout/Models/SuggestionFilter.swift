//
//  SuggestionFilter.swift
//  Tagabout
//
//  Created by Madanlal on 08/04/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

struct SuggestionFilter {
    
    var catId: Int?
    var subCatId: Int?
    var businessName: String?
    var isLocal: Bool?
    var location: String?
    var microcate: Int?
    var pageSize: Int = 20
    var pageNumber: Int = 1
    var getAll: Bool = true
    var sugId :Int?
    var contactId:Int?
    var sourceId:Int?
    var cityId:Int?
    var microName :String?
    var areaShortCode:String?
    
    

    func toDict() -> [String: String] {
        var dict = [String: String]()

        if let businessName = businessName { dict["businessName"] = businessName }
        if let location = location { dict["location"] = location }
        if let microcate = microcate { dict["microcate"] = "\(microcate)" }
        if let isLocal = isLocal { dict["isLocal"] = NSNumber(value: isLocal).stringValue }
        if let catId = catId { dict["catId"] = "\(catId)" }
        if let subCatId = subCatId { dict["subCatId"] = "\(subCatId)" }
        if let sugId = sugId { dict["sugId"] = "\(sugId)" }
        if let contactId = contactId { dict["contactId"] = "\(contactId)" }
        if let sourceId = sourceId { dict["sourceId"] = "\(sourceId)" }
        if let cityId = cityId { dict["cityId"] = "\(cityId)" }
        if let microName = microName { dict["microName"] = microName }
        if let areaShortCode = areaShortCode { dict["areaShortCode"] = areaShortCode }
        
        dict["pageSize"] = "\(pageSize)"
        dict["pageNumber"] = "\(pageNumber)"
        dict["getAll"] = NSNumber(value: getAll).stringValue
        
        return dict
    }
    
    mutating func setNextPage() {
        pageNumber = pageNumber + 1
    }
    
    mutating func toggleGetAll() {
        getAll = !getAll
        businessName = nil
        location = nil
        microcate = nil
        pageNumber = 1
        isLocal = nil
    }
    
    mutating func setCat(_ cat: Int, andSubCat subCat: Int, cityId:Int,areacode:String, microcategory:Int?,microName:String?,businessName:String?,location:String) {
        catId = cat
        subCatId = subCat
        pageNumber = 1
        microcate = microcategory
        contactId = APIGateway.shared.loginData?.loginDetail?.contactId
        areaShortCode = areacode
        self.microName = microName
        self.businessName = businessName
        self.location = location
    }
    
    mutating func setCat(_ cat: Int, andSubCat subCat: Int){
        catId = cat
        subCatId = subCat
        pageNumber = 1
    }
}
