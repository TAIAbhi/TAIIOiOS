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
        let sessionTask : URLSessionTask? = APIManager.doLogin(userName: mobile, password: password, completion: { (user) in
            
        }) { (error) in
            print("Error on Login \(error.localizedDescription)")
        }
        guard let task = sessionTask else { return }
        task.resume()
    }
}
