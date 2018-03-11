//
//  APIManager.swift
//  Tagabout
//
//  Created by Karun Pant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

struct APIManager {
    static func doPost(request: URLRequest, completion:(([String : Any]?)->())?, onError: ((Error)->())?) -> URLSessionTask?{
        var request = request
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let task = APIGateway.shared.doDataCall(request: request, completion: { (data) in
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let json = json as? [String : Any], let completion = completion{ completion(json) }
            }catch{
                if let completion = completion{ completion(nil) }
                print("Unexpected error: \(error).")
                
            }
        }) { (error) in
            if let onError = onError{ onError(error) }
        }
        return task
    }
    static func doGet(request: URLRequest, completion:(([String : Any]?)->())?, onError: ((Error)->())?) -> URLSessionTask? {
        //request.setValue("application/json; charset=UTF-8" , forHTTPHeaderField: "Content-Type")
        var request = request
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = APIGateway.shared.doDataCall(request: request, completion: { (data) in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let json = json as? [String : Any], let completion = completion { completion(json) }
            } catch {
                if let completion = completion { completion(nil) }
                print("Unexpected error: \(error).")
                
            }
        }) { (error) in
            if let onError = onError{ onError(error) }
        }
        return task
    }
}
