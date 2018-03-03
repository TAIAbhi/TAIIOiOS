//
//  APIGateway.swift
//  Tagabout
//
//  Created by Karun Pant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation

class APIGateway{
    static let shared = APIGateway()
    private init(){
    }
    
    private var session : URLSession{
        get{
            let config = URLSessionConfiguration.default
            return URLSession.init(configuration: config)
        }
    }
    public func doDataCall(request: URLRequest, completion: ((Data)->())?, onError: ((Error)->())?) -> URLSessionTask?{
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error, let onError = onError{
                onError(error)
            }
            if let data = data, let completion = completion{
                completion(data)
            }
        }
        return task
    }
}
