//
//  API.swift
//  Tagabout
//
//  Created by Karun Pant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

struct API{
    static let baseURL = "https://www.tai.com/"
    static var loginUrl : URL{
        get{
            return URL.init(string: "http://devapitai.us-east-1.elasticbeanstalk.com/api/values/login")!
        }
    }
}
