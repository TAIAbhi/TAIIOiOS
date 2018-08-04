//
//  APIGateway.swift
//  Tagabout
//
//  Created by Karun Pant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import UIKit

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
                    GeneralUtils.addCrashlyticsUser()
                }catch{}
            }
        }
    }
    
    func shouldShowVideo() -> Bool{
        if self.loginData?.loginDetail?.skipVideo == true {
            return false
        }else{
            return self.loginData?.loginDetail?.showVideo ?? true
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
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let task = session.dataTask(with: request) { (data, response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let httpUrlResponse = response as? HTTPURLResponse
            {
                
                if let error = error, let onError = onError{
                    onError(error)
                    return
                }else{
                    if httpUrlResponse.statusCode == 401 {
                        let storyBoard = UIStoryboard.init(name: "UserStory", bundle: Bundle.main)
                        if let window = UIApplication.shared.keyWindow,
                            let vc :LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                            window.rootViewController = UINavigationController.init(rootViewController: vc)
                            window.makeKeyAndVisible()
                        }
                    }
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
