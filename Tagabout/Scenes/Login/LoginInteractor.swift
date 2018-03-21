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
        let request = URLRequest.init(url: loginURL)
        let postParams = ["loginId": loginId, "password": password]
        let sessionTask : URLSessionTask? = APIManager.doPost(request: request, body: postParams, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success"{
                let decoder = JSONDecoder()
                do{
                    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let loginData = try decoder.decode(LoginData.self, from: data)
                    APIGateway.shared.loginData = loginData
                }catch{}
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
