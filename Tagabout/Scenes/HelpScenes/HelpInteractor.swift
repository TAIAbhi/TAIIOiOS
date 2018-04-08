//
//  HelpInteractor.swift
//  Tagabout
//
//  Created by Karun Pant on 07/04/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation


class HelpInteractor{
    func fetchHelpData(with completion:  (([Help])->Void)?) {
//        let url = API.getURL(to: "help")
//        let request = URLRequest.init(url: url)
//        let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
//            if let json = response, let action = json["action"] as? String, action == "success" {
//                if let completion = completion, let data = json["data"] as? [[String: Any]] {
//
//                    var helpArray = [Help]()
//                    let decoder = JSONDecoder()
//                    for d in data {
//                        do {
//                            let data = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
//                            let help = try decoder.decode(Help.self, from: data)
//                            helpArray.append(help)
//                        } catch { }
//                    }
//
//                    completion(helpArray)
//                }
//
//            } else {
//                if let completion = completion { completion([]) }
//            }
//        }) { (error) in
//            print("Error on fetch Help \(error.localizedDescription)")
//            if let completion = completion { completion([]) }
//        }
//        guard let _ = sessionTask else { return }
        
        //get local data
        if let response = GeneralUtils.getAndParseJson(fileName: "help"){
            if let completion = completion, let data = response["data"] as? [[String : Any]] {
                var helpArray = [Help]()
                let decoder = JSONDecoder()
                for d in data {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                        let help = try decoder.decode(Help.self, from: data)
                        helpArray.append(help)
                    } catch { }
                }
                
                completion(helpArray)
            }
        }
        
    }
}
