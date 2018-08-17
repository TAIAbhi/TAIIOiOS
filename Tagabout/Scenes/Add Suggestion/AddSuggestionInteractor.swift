//
//  AddSuggestionInteractor.swift
//  Tagabout
//
//  Created by Karun Pant on 07/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

struct AddSuggestionInteractor{
    
    func getCategories(completion: (([Category]?)->())?){
        let categoriesURL = API.getURL(to: "categories")
        let request = URLRequest.init(url: categoriesURL)
//        api/categories/{isRequest=isRequest}/{cityId=cityId}/{areaShortCode=areaShortCode}/{location=location}
//        let param = ["isRequest"]
        
        
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
    
    func getMicroCategoriesFor(subcategoryId : Int, completion: (([MicroCategory]?)->())?){
        ///api/microcat?subcategoryId=134
        let microCategoriesURL = API.getURL(to: "microcat", queryParams: ["subcategoryId" : "\(subcategoryId)"])
        let request = URLRequest.init(url: microCategoriesURL)
        let _ : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success", let data = json["data"] as? [[String : Any]] {
                // save auth token to gateway for future use.
                var allMicroCategories : [MicroCategory] = [MicroCategory]()
                let decoder = JSONDecoder()
                for d in data {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                        let microCat = try decoder.decode(MicroCategory.self, from: data)
                        allMicroCategories.append(microCat)
                    } catch { }
                }
                if let completion = completion{ completion(allMicroCategories) }
            }else{
                if let completion = completion{ completion(nil) }
            }
        }) { (error) in
            print("Error getting micro categories \(error.localizedDescription)")
            if let completion = completion{ completion(nil) }
        }
    }
    
    func postSuggestion(suggestion : Suggestion) {//-> URLSessionDataTask {
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(suggestion)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("\(String(describing: jsonString))")
        }catch{
            //error occurred
            print("error suggestion")
        }
    }
    
    
    func postSuggestion(forparams params:[String:Any], completion: ((Bool)->())?){
        
        
        let microCategoriesURL = API.getURL(to: "suggestion")
        let request = URLRequest.init(url: microCategoriesURL)
        let _ : URLSessionTask? = APIManager.doPost(request: request, body: params, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success", let data = json["data"] as? [[String : Any]] {
                // save auth token to gateway for future use.
                var allMicroCategories : [MicroCategory] = [MicroCategory]()
                let decoder = JSONDecoder()
                for d in data {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                        let microCat = try decoder.decode(MicroCategory.self, from: data)
                        allMicroCategories.append(microCat)
                    } catch { }
                }
                if let completion = completion{ completion(true)}
            }else{
                if let completion = completion{ completion(false) }
            }
        }) { (error) in
            print("Error getting micro categories \(error.localizedDescription)")
            if let completion = completion{ completion(true) }
        }
    }
    
}


