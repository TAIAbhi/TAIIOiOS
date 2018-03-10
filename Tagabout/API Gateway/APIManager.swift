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
        let loginURL = API.getURL(to: "login/api/login", queryParams: ["userid" : userName, "password":password])
        var request = URLRequest.init(url: loginURL)
        request.httpMethod = "GET"
        let task = APIGateway.shared.doDataCall(request: request, completion: { (data) in
            print(data)
        }) { (error) in
            if let onError = onError{ onError(error) }
        }
        return task
    }
    
}
