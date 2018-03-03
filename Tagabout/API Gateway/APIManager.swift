//
//  APIManager.swift
//  Tagabout
//
//  Created by Karun Pant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

struct APIManager {

    static func doLogin(userName: String, password: String, completion:((User)->())?, onError: ((Error)->())?) -> URLSessionTask? {
        let request = URLRequest.init(url: API.loginUrl)
        let task = APIGateway.shared.doDataCall(request: request, completion: { (data) in
            // turn this data to User and pass over the main queue.
        }) { (error) in
            if let onError = onError{ onError(error) }
        }
        return task
    }
    
}
