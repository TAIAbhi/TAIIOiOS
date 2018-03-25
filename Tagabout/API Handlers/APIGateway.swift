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
    
    private var session : URLSession{
        get{
            let session = URLSession.init(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            return session
        }
    }
    
    public var loginData : LoginData?{
        get{
            if let loginData = UserDefaults.standard.object(forKey: "loginData") as? Data{
                let decoder = JSONDecoder()
                do{
                    let data = try decoder.decode(LoginData.self, from: loginData)
                    return data
                }catch{
                    return nil
                }
            }
            return nil
        }
        set{
            if let loginData = newValue as LoginData?{
                let encoder = JSONEncoder()
                do{
                    let data = try encoder.encode(loginData)
                    UserDefaults.standard.set(data, forKey: "loginData")
                }catch{}
            }
        }
    }
    
    public var authToken : String?{
        get{
            if let loginData = loginData, let authToken = loginData.authToken{
                return authToken
            }else{
                return nil
            }
        }
    }
    public func doDataCall(request: URLRequest, completion: ((Data)->())?, onError: ((Error)->())?) -> URLSessionTask?{
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let httpUrlResponse = response as? HTTPURLResponse
            {
                if let error = error, let onError = onError{
                    onError(error)
                    return
                }else{
                    print("\(httpUrlResponse.allHeaderFields)")
                }
            }
            if let data = data, let completion = completion{
                completion(data)
                return
            }
        }
        task.resume()
        return task
    }
}
