//
//  City.swift
//  Tagabout
//
//  Created by Arun Jangid on 04/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

struct City:Codable {
    var cityId : Int?
    var cityName : String?
    var cityURL : String?
    var maxGeoLat : Double?
    var maxGeoLong : Double?
    var minGeoLat : Double?
    var minGeoLong : Double?
}
