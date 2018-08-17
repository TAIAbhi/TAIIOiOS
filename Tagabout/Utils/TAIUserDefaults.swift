//
//  TAIUserDefaults.swift
//  Tagabout
//
//  Created by Arun Jangid on 09/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
extension UserDefaults {
    
    static let fcmToken                 :   String = "tofcm_Tokenken"
    
    
    //MARK: FCM TOKEN
    
    func saveFcmtoken(_ token:String){
        set(token, forKey: UserDefaults.fcmToken)
        synchronize()
    }
    
    func getFcmtoken() -> String{
        var token = ""
        if let savedToken = value(forKey: UserDefaults.fcmToken) as? String {
            token = savedToken
        }
        return token
    }

}
