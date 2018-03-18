//
//  MyDetailsInteractor.swift
//  Tagabout
//
//  Created by Madanlal on 14/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

class MyDetailsInteractor {
    
    func fetchMyDetails(with completion: (() -> Void)?) {
        let url = API.getURL(to: "me")
        let request = URLRequest.init(url: url)
        let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success" {
                // save auth token to gateway for future use.
                if let completion = completion, let data = json["message"] as? [[String: Any]] {
                    
                    print("me == \(data)")
                    
                    completion()
                }
                
            } else {
                if let completion = completion { completion() }
            }
        }) { (error) in
            print("Error on fetch suggestion \(error.localizedDescription)")
            if let completion = completion { completion() }
        }
        guard let _ = sessionTask else { return }
    }
    
}
