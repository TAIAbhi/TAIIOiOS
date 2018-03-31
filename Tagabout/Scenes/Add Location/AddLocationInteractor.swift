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
                            let suburb = try decoder.decode(Suburb.self, from: data)
                            suburbs.append(suburb)
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
    
    
    func fetchLocationFromQuery(_ query: String, completion: (([Location])->Void)?) {
        let url = API.getURL(to: "location", queryParams: ["query": query])
        let request = URLRequest.init(url: url)
        let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success" {
                if let completion = completion, let data = json["data"] as? [[String: Any]] {
                    var locations = [Location]()
                    let decoder = JSONDecoder()
                    for d in data {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                            let location = try decoder.decode(Location.self, from: data)
                            locations.append(location)
                        } catch { }
                    }
                    completion(locations)
                    return
                }
            }
            if let completion = completion { completion([Location]()) }
        }) { (error) in
            if let completion = completion { completion([Location]()) }
        }
        
        guard let _ = sessionTask else { return }
    }
    
    func addLocation(suburb: String, location: String, completion: @escaping ((Bool)->())) {
        let url = API.getURL(to: "location")
        let request = URLRequest.init(url: url)
        let postParams = ["suburb": suburb, "locationName": location]
        _ = APIManager.doPost(request: request, body: postParams, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action.lowercased() == "success" {
                completion(true)
            } else {
                completion(false)
            }
        }) { (error) in
            completion(false)
        }
    }
    
}
