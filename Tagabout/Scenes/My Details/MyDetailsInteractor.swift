//
//  MyDetailsInteractor.swift
//  Tagabout
//
//  Created by Madanlal on 14/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

struct MyDetailsInteractor {
    
    func fetchMyDetails(with completion: ((User?) -> Void)?) {
        let url = API.getURL(to: "me")
        let request = URLRequest.init(url: url)
        let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success" {
                // save auth token to gateway for future use.
                if let completion = completion, let data = json["data"] as? [String: Any] {
                    let user = User(dict: data)
                    completion(user)
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
    
    func updateMyDetailsWithData(_ data: [String: Any], completion: @escaping ((Bool)->Void)) {
        let url = API.getURL(to: "me")
        let request = URLRequest.init(url: url)
        _ = APIManager.doPut(request: request, body: data, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action.lowercased() == "success" {
                completion(true)
            } else {
                completion(false)
            }
        }, onError: { (error) in
            completion(false)
        })
    }
    
    func addContactDetailsWithData(_ data: [String: Any], completion: @escaping ((Bool)->Void)) {
        let url = API.getURL(to: "me")
        let request = URLRequest.init(url: url)
        
        _ = APIManager.doPost(request: request, body: data, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action.lowercased() == "success" {
                completion(true)
            } else {
                completion(false)
            }
        }, onError: { (error) in
            completion(false)
        })                        
    }
}
