//
//  LandingInteractor.swift
//  Tagabout
//
//  Created by Arun Jangid on 04/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import MapKit

class LandingInteractor {
    func fetchCity(withSuccessHandler completion: (([City])->())?) {
        let loginURL = API.getURL(to: "city")
        let request = URLRequest.init(url: loginURL)
        
        let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
            if let json = response, let action = json["action"] as? String, action == "success"{
                if let completion = completion, let data = json["data"] as? [[String: Any]] {
                    
                    var cityArray = [City]()
                    let decoder = JSONDecoder()
                    for d in data {
                        do {
                            let cityData = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                            let city = try decoder.decode(City.self, from: cityData)
                            cityArray.append(city)
                        } catch {
                            print("city decode error")
                        }
                    }
                    completion(cityArray)
                }                                
            }else{
                if let completion = completion{ completion([]) }
            }
        }) { (error) in
            print("Error on Login \(error.localizedDescription)")
            if let completion = completion{ completion([]) }
        }
        guard let _ = sessionTask else { return }
    }
    
    func fetchCategories(forPlacemark placemark:CLPlacemark,forCity city:City,  withSuccessHandler completion: (([BindFilter])->())?) {
        if let contactId = APIGateway.shared.loginData?.loginDetail?.contactId, let suburb = placemark.subLocality?.components(separatedBy: " ").first, let cityID = city.cityId, let latitude = placemark.location?.coordinate.latitude.description, let longitude = placemark.location?.coordinate.longitude.description{
                    let loginURL = API.getURL(to: "bindvsfilterdd", queryParams: ["contactId":"\(contactId)","suburb":suburb,"cityId":"\(cityID)","geoCoordinates":"\(latitude),\(longitude)","address":"\(placemark.locality!)"])
            let request = URLRequest.init(url: loginURL)
            
            let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
                if let json = response, let action = json["action"] as? String, action == "success"{
                    if let completion = completion, let data = json["data"] as? [[String: Any]] {
                        
                        var bindFilterArray = [BindFilter]()
                        let decoder = JSONDecoder()
                        for d in data {
                            do {
                                let bindFilterData = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                                let bindFilter = try decoder.decode(BindFilter.self, from: bindFilterData)
                                bindFilterArray.append(bindFilter)
                            } catch {
                                print("city decode error")
                            }
                        }
                        completion(bindFilterArray)
                    }
                }else{
                    if let completion = completion{ completion([]) }
                }
            }) { (error) in
                print("Error on Login \(error.localizedDescription)")
                if let completion = completion{ completion([]) }
            }
            guard let _ = sessionTask else { return }
        }
    }
    
    func fetchSectionsCategoryWithCount(forBindFilter bindFilter:BindFilter, forCity city:City,  withSuccessHandler completion: (([CategoryCountData])->())?) {
//        http://stringsconnected.com/api/getsectioncategorywithcount?&areaCode=NWP&cityId=2
        
        if let _ = APIGateway.shared.loginData?.loginDetail?.contactId, let cityID = city.cityId, let areaCode = bindFilter.ddValue{
            let loginURL = API.getURL(to: "getsectioncategorywithcount", queryParams: ["uniqueCount":"true","areaCode":"\(areaCode)","cityId":"\(cityID)"])
            let request = URLRequest.init(url: loginURL)
            
            let sessionTask : URLSessionTask? = APIManager.doGet(request: request, completion: { (response) in
                if let json = response, let action = json["action"] as? String, action == "success"{
                    if let completion = completion, let data = json["data"] as? [String: Any], let categoryData = data["CategoryCountData"] as? [[String : Any]]   {
                        
                        var categoryCountDatas = [CategoryCountData]()
                        let decoder = JSONDecoder()
                        for d in categoryData {
                            do {
                                let categoryData = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                                let categoryCount = try decoder.decode(CategoryCountData.self, from: categoryData)
                                categoryCountDatas.append(categoryCount)
                            } catch {
                                print("city decode error")
                            }
                        }
                        completion(categoryCountDatas)
                    }
                }else{
                    if let completion = completion{ completion([]) }
                }
            }) { (error) in
                print("Error on Login \(error.localizedDescription)")
                if let completion = completion{ completion([]) }
            }
            guard let _ = sessionTask else { return }
        }
        
    }

}
