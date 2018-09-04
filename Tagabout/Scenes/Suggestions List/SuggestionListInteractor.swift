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
    
    func fetchSuggestionsWithFilter(_ filter: SuggestionFilter, completion:  (([Suggestion],PageInfo?)->Void)?) {
        let url = API.getURL(to: "getsuggestionwithcount", queryParams: filter.toDict())
        fetchSuggestionsForUrl(url, with: completion)
    }
    
    func fetchSuggestionsForUrl(_ url: URL, with completion:  (([Suggestion],PageInfo?)->Void)?) {
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
                    var pageInfo : PageInfo?
                    if let pageInfoJson = json["pageInfo"] as? [String: Any] {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: pageInfoJson, options: .prettyPrinted)
                            pageInfo = try decoder.decode(PageInfo.self, from: data)
                        } catch { }
                    }
                    
                    
                    completion(suggestionArray,pageInfo)
                }
            } else {
                if let completion = completion { completion([],nil) }
            }
        }) { (error) in
            print("Error on fetch suggestion \(error.localizedDescription)")
            if let completion = completion { completion([],nil) }
        }
        guard let _ = sessionTask else { return }
    }
    
    func getCategories(forCityId cityId:Int, completion: (([Category]?)->())?){
        let categoriesURL = API.getURL(to: "categories", queryParams: ["isRequest":"true","cityId":"\(cityId)"])
        let request = URLRequest.init(url: categoriesURL)
//                api/categories/{isRequest=isRequest}/{cityId=cityId}/{areaShortCode=areaShortCode}/{location=location}
//                let param = ["isRequest"]
//        
        
        let _ : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success", let data = json["data"] as? [[String : Any]] {
                // save auth token to gateway for future use.
                var allCategories : [Category] = [Category]()
                let decoder = JSONDecoder()
                for d in data {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                        let cat = try decoder.decode(Category.self, from: data)
                        allCategories.append(cat)
                    } catch {
                        print("Error in Categories")
                    }
                }
                if let completion = completion{ completion(allCategories) }
            }else{
                if let completion = completion{ completion(nil) }
            }
        }) { (error) in
            print("Error getting categories \(error.localizedDescription)")
            if let completion = completion{ completion(nil) }
        }
    }
    
    
    func fetchRequestSuggestionsWithFilter(_ filter: SuggestionFilter, completion:  (([Suggestion],PageInfo?)->Void)?) {
        let url = API.getURL(to: "getrequestsuggestion", queryParams: filter.toDict())
        fetchSuggestionsForUrl(url, with: completion)
    }
    
    func fetchRequestsSuggestionsForUrl(_ url: URL, with completion:  (([Suggestion],PageInfo?)->Void)?) {
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
                    var pageInfo : PageInfo?
                    if let pageInfoJson = json["pageInfo"] as? [String: Any] {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: pageInfoJson, options: .prettyPrinted)
                            pageInfo = try decoder.decode(PageInfo.self, from: data)
                        } catch { }
                    }
                    
                    
                    completion(suggestionArray,pageInfo)
                }
            } else {
                if let completion = completion { completion([],nil) }
            }
        }) { (error) in
            print("Error on fetch suggestion \(error.localizedDescription)")
            if let completion = completion { completion([],nil) }
        }
        guard let _ = sessionTask else { return }
    }
    
}
