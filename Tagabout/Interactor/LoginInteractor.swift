//
//  LoginInteractor.swift
//  Tagabout
//
//  Created by Madanlal on 04/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

class LoginInteractor {
    func loginUserWithMobile(_ loginId: String, andPassword password: String) {
        let loginURL = API.getURL(to: "login")
        var request = URLRequest.init(url: loginURL)
        let postParams = "loginId=\(loginId)&password=\(password)"
        guard let postData = postParams.data(using: String.Encoding.ascii, allowLossyConversion: true) else{ return }
        request.httpBody = postData
        let sessionTask : URLSessionTask? = APIManager.doPost(request: request, completion: { (response) in
            if let response = response, response["action"] == "success", authToken = response["authToken"] as? String{
                // save auth token to gateway for future use.
                APIGateway.shared.authToken = authToken
            }
        }) { (error) in
            print("Error on Login \(error.localizedDescription)")
        }
        guard let _ = sessionTask else { return }
        // do something with task if needed.
    }
}
