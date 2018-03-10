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
    static let devURL = "http://devapitai.us-east-1.elasticbeanstalk.com/";
    static func getURL(to relativePath : String, queryParams: [String : String]? = nil) -> URL{
        var urlComponent = URLComponents.init(string: "\(devURL)\(relativePath)")
        if let queryParams = queryParams{
            let queryItems = queryParams.keys.map({ (keyName) -> URLQueryItem in
                return URLQueryItem.init(name: keyName, value: queryParams[keyName])
            })
            urlComponent?.queryItems = queryItems
        }
        return (urlComponent?.url)!
    }
}
