//
//  LoginInteractor.swift
//  Tagabout
//
//  Created by Madanlal on 04/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

class LoginInteractor {
    func loginUserWithMobile(_ loginId: String, andPassword password: String, withSuccessHandler completion: ((Bool)->())?) {
        let loginURL = API.getURL(to: "login")
        var request = URLRequest.init(url: loginURL)
        let postParams = "loginId=\(loginId)&password=\(password)"
        guard let postData = postParams.data(using: String.Encoding.ascii, allowLossyConversion: true) else{ return }
        request.httpBody = postData
        let sessionTask : URLSessionTask? = APIManager.doPost(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success", let authToken = json["authToken"] as? String{
                // save auth token to gateway for future use.
                print("auth token == \(authToken)")
                APIGateway.shared.authToken = authToken
                if let completion = completion{ completion(true) }
            }else{
                if let completion = completion{ completion(false) }
            }
        }) { (error) in
            print("Error on Login \(error.localizedDescription)")
            if let completion = completion{ completion(false) }
        }
        guard let _ = sessionTask else { return }
        // do something with task if needed.
    }
}
