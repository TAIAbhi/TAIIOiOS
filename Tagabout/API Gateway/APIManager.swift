//
//  APIManager.swift
//  Tagabout
//
//  Created by Karun Pant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

struct APIManager {
    static func doPost(request: URLRequest, completion:((User)->())?, onError: ((Error)->())?) -> URLSessionTask?{
        var request = request
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let task = APIGateway.shared.doDataCall(request: request, completion: { (data) in
            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            print(string1)
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }catch{
                 print("Unexpected error: \(error).")
            }
        }) { (error) in
            if let onError = onError{ onError(error) }
        }
        return task
    }
    static func doGet(){
        //request.setValue("application/json; charset=UTF-8" , forHTTPHeaderField: "Content-Type")
        
    }
}
