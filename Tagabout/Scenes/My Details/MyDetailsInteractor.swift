//
//  MyDetailsInteractor.swift
//  Tagabout
//
//  Created by Madanlal on 14/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

class MyDetailsInteractor {
    
    func fetchMyDetails(with completion: ((User?) -> Void)?) {
        let url = API.getURL(to: "me")
        let request = URLRequest.init(url: url)
        let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success" {
                // save auth token to gateway for future use.
                if let completion = completion, let data = json["message"] as? [[String: Any]] {
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: data)
                        completion(user)
                    } catch {
                        completion(nil)
                    }
                    
                    
                }
                
            } else {
                if let completion = completion { completion(nil) }
            }
        }) { (error) in
            print("Error on fetch suggestion \(error.localizedDescription)")
            if let completion = completion { completion(nil) }
        }
        guard let _ = sessionTask else { return }
    }
    
}
