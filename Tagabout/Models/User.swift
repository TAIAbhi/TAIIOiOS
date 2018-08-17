//
//  User.swift
//  Tagabout
//
//  Created by Karun Pant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit


struct LoginData : Codable{
    var action : String?
    var authToken : String?
    var message : String?
    var loginDetail : LoginDetails?
}

struct LoginDetails: Codable {
    var contactId : Int?
    var contactName : String?
    var mobile : String?
    var platform : Int?
    var role : Int?
    var skipVideo : Bool?
    var showVideo : Bool?
    var sourceId : Int?
    var sourceImage: String?
    var sourceName : String?
    var videoUrl : String?
    var sourceType : Int?
    var sourceTypeText : String?
    
    // swift 4 decoder was not working -- can't help it -- no time
    init(dict: [String: Any]) {
        if let contactId = dict["contactId"] as? Int { self.contactId = contactId }
        if let contactName = dict["contactName"] as? String { self.contactName = contactName }
        if let mobile = dict["mobile"] as? String { self.mobile = mobile }
        
        if let platform = dict["platform"] as? Int { self.platform = platform }
        if let role = dict["role"] as? Int { self.role = role }
        if let skipVideo = dict["skipVideo"] as? Bool { self.skipVideo = skipVideo }
        if let showVideo = dict["showVideo"] as? Bool { self.showVideo = showVideo }
        if let sourceId = dict["sourceId"] as? Int { self.sourceId = sourceId }
        if let sourceType = dict["sourceType"] as? Int { self.sourceType = sourceType }
        if let sourceImage = dict["sourceImage"] as? String { self.sourceImage = sourceImage }            
        if let sourceTypeText = dict["sourceTypeText"] as? String { self.sourceTypeText = sourceTypeText }
    }
}

struct User: Codable {
    
    var contact: String?
    var contactComments: String?
    var contactId: Int?
    var platform: Int?
    var contactLevelUnderstanding: String?
    var contactNumber: String?
    var isContactDetailsAdded: Bool?
    var location1: String?
    var location2: String?
    var location3: String?
    var notification: String?
    var source: String?
    var sourceId: Int?
    var allowProvideSuggestion:Int?
    
    // swift 4 decoder was not working -- can't help it -- no time
    init(dict: [String: Any]) {
        if let contact = dict["contact"] as? String { self.contact = contact }
        if let contactComments = dict["contactComments"] as? String { self.contactComments = contactComments }
        if let contactId = dict["contactId"] as? Int { self.contactId = contactId }
        if let contactLevelUnderstanding = dict["contactLevelUnderstanding"] as? String { self.contactLevelUnderstanding = contactLevelUnderstanding }
        if let contactNumber = dict["contactNumber"] as? String { self.contactNumber = contactNumber }
        if let isContactDetailsAdded = dict["isContactDetailsAdded"] as? Bool { self.isContactDetailsAdded = isContactDetailsAdded }
        if let location1 = dict["location1"] as? String { self.location1 = location1 }
        if let location2 = dict["location2"] as? String { self.location2 = location2 }
        if let location3 = dict["location3"] as? String { self.location3 = location3 }
        if let notification = dict["notification"] as? String { self.notification = notification }
        if let source = dict["source"] as? String { self.source = source }
        if let sourceId = dict["sourceId"] as? Int { self.sourceId = sourceId }
        if let platform = dict["platform"] as? Int { self.platform = platform }
        if let allowProvideSuggestion = dict["allowProvideSuggestion"] as? Int { self.allowProvideSuggestion = allowProvideSuggestion }
        
    }
}
