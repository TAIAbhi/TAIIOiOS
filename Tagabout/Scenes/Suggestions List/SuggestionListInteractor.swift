//
//  SuggestionListInteractor.swift
//  Tagabout
//
//  Created by Madanlal on 11/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

class SuggestionListInteractor {
    
    func fetchSuggestionCategories(with completion:  (([Category])->Void)?) {
        let url = API.getURL(to: "suggestion")
        let request = URLRequest.init(url: url)
        let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success" {
                // save auth token to gateway for future use.
                if let completion = completion, let data = json["data"] as? [[String: Any]] {
                    
                    var catArray = [Category]()
                    let decoder = JSONDecoder()
                    for d in data {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                            let cat = try decoder.decode(Category.self, from: data)
                            catArray.append(cat)
                        } catch { }
                    }
                    
                    completion(catArray)
                }
                
            } else {
                if let completion = completion { completion([]) }
            }
        }) { (error) in
            print("Error on fetch suggestion \(error.localizedDescription)")
            if let completion = completion { completion([]) }
        }
        guard let _ = sessionTask else { return }
        
    }
    
    func fetchAllMySuggestions(_ completion:  (([Suggestion])->Void)?) {
        let url = API.getURL(to: "getsuggestion")
        fetchSuggestionsForUrl(url, with: completion)
    }
    
    func fetchSuggestionsFor(category: Int, and subCategory: Int, with completion:  (([Suggestion])->Void)?) {
        let url = API.getURL(to: "getsuggestion", queryParams: ["catId": "\(category)", "subCatId": "\(subCategory)"])
        fetchSuggestionsForUrl(url, with: completion)
    }
    
    func fetchSuggestionsForUrl(_ url: URL, with completion:  (([Suggestion])->Void)?) {
        let request = URLRequest.init(url: url)
        let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success" {
                // save auth token to gateway for future use.
                if let completion = completion, let data = json["data"] as? [[String: Any]] {
                    
                    var suggestionArray = [Suggestion]()
                    let decoder = JSONDecoder()
                    for d in data {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                            let suggestion = try decoder.decode(Suggestion.self, from: data)
                            suggestionArray.append(suggestion)
                        } catch { }
                    }
                    
                    completion(suggestionArray)
                }
            } else {
                if let completion = completion { completion([]) }
            }
        }) { (error) in
            print("Error on fetch suggestion \(error.localizedDescription)")
            if let completion = completion { completion([]) }
        }
        guard let _ = sessionTask else { return }
    }
}
