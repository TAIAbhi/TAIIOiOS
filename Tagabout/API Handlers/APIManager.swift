//
//  APIManager.swift
//  Tagabout
//
//  Created by Karun Pant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

struct APIManager {
    static func doPost(request: URLRequest, body: [String: Any], completion:(([String : Any]?)->())?, onError: ((Error)->())?) -> URLSessionTask?{
        var request = request
        if let httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) {
            request.httpBody = httpBody
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            if let authToken = APIGateway.shared.authToken{
                request.setValue(authToken, forHTTPHeaderField: "Token")
            }
//            print("calling POST == \(String(describing: request.url?.absoluteString))")
//            print("POST data  == \(body)")
            let task = APIGateway.shared.doDataCall(request: request, completion: { (data) in
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json = json as? [String : Any], let completion = completion{
                        print("Json data == \(json)")
                        completion(json)
                    }
                }catch{
                    if let completion = completion{ completion(nil) }
                    print("Unexpected error: \(error).")
                    
                }
            }) { (error) in
                if let onError = onError{ onError(error) }
            }
            return task
        }
        
        return nil
    }
    
    static func doPut(request: URLRequest, body: [String: Any], completion:(([String : Any]?)->())?, onError: ((Error)->())?) -> URLSessionTask?{
        var request = request
        if let httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) {
            request.httpBody = httpBody
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            if let authToken = APIGateway.shared.authToken{
                request.setValue(authToken, forHTTPHeaderField: "Token")
            }
            //            print("calling POST == \(String(describing: request.url?.absoluteString))")
                        print("PUT data  == \(body)")
            let task = APIGateway.shared.doDataCall(request: request, completion: { (data) in
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json = json as? [String : Any], let completion = completion{
                        print("Json data == \(json)")
                        completion(json)
                    }
                }catch{
                    if let completion = completion{ completion(nil) }
                    print("Unexpected error: \(error).")
                    
                }
            }) { (error) in
                if let onError = onError{ onError(error) }
            }
            return task
        }
        
        return nil
    }
    
    static func doGet(request: URLRequest, completion:(([String : Any]?)->())?, onError: ((Error)->())?) -> URLSessionTask? {
        var request = request
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(APIGateway.shared.authToken, forHTTPHeaderField: "Token")
        if let authToken = APIGateway.shared.authToken{
            request.setValue(authToken, forHTTPHeaderField: "Token")
        }
        print("calling GET == \(String(describing: request.url?.absoluteString))")
        
        let task = APIGateway.shared.doDataCall(request: request, completion: { (data) in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let json = json as? [String : Any], let completion = completion {
                    print("Json data == \(json)")
                    completion(json)
                }
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
