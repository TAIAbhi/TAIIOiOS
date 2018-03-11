//
//  SuggestionListInteractor.swift
//  Tagabout
//
//  Created by Madanlal on 11/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

class SuggestionListInteractor {
    
    func fetchSuggestions(with completion:  (([Suggestion])->Void)?) {
        let url = API.getURL(to: "suggestion")
        let request = URLRequest.init(url: url)
        let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success" {
                // save auth token to gateway for future use.
//                if let completion = completion { completion(true) }
                print(json)
            } else {
//                if let completion = completion { completion(false) }
            }
        }) { (error) in
            print("Error on Login \(error.localizedDescription)")
//            if let completion = completion { completion(false) }
        }
        guard let _ = sessionTask else { return }
        
    }
    
}
