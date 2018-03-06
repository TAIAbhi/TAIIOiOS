//
//  LoginInteractor.swift
//  Tagabout
//
//  Created by Madanlal on 04/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

class LoginInteractor {
    func loginUserWithMobile(_ mobile: String, andPassword password: String) {
        
        let task = APIManager.doLogin(userName: mobile, password: password, completion: { (user) in
            
        }) { (error) in
            
        }
        
        task?.resume()
    }
}
