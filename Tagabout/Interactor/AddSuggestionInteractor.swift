//
//  AddSuggestionInteractor.swift
//  Tagabout
//
//  Created by Karun Pant on 07/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

struct AddSuggestionInteractor{
    
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
}
