//
//  LoginInteractor.swift
//  Tagabout
//
//  Created by Madanlal on 04/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

class LoginInteractor {
    func loginUserWithMobile(_ mobile: String, andPassword password: String, withSuccessHandler success: ((_ data: NSDictionary)->Void), andfailureHandler failure: ((_ data: NSDictionary)->Void)) {
        let urlStr = "http://devapitai.us-east-1.elasticbeanstalk.com/api/values/login?userid=\(mobile)&password=\(password)"
        let url = URL.init(string: urlStr)
        var request = URLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.httpBody = NSKeyedArchiver.archivedData(withRootObject: ["mobile": mobile, "password": password])
        let task = APIGateway.shared.doDataCall(request: request, completion: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
        
    }
}
