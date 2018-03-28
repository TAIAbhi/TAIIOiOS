//
//  AddLocationInteractor.swift
//  Tagabout
//
//  Created by Madanlal on 28/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

struct AddLocationInteractor {
    
    func fetchSuburbs(_ completion: (([Suburb])->Void)?) {
        let url = API.getURL(to: "suburbs")
        let request = URLRequest.init(url: url)
        let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success" {
                if let completion = completion, let data = json["data"] as? [[String: Any]] {
                    var suburbs = [Suburb]()
                    let decoder = JSONDecoder()
                    for d in data {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                            let suggestion = try decoder.decode(Suburb.self, from: data)
                            suburbs.append(suggestion)
                        } catch { }
                    }
                    completion(suburbs)
                    return
                }
            }
            if let completion = completion { completion([Suburb]()) }
        }) { (error) in
            if let completion = completion { completion([Suburb]()) }
        }
        
        guard let _ = sessionTask else { return }
    }
    
}
