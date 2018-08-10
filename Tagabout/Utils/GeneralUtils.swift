//
//  GeneralUtils.swift
//  Tagabout
//
//  Created by Karun Pant on 07/04/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import Crashlytics

struct GeneralUtils {
    static func addCrashlyticsUser(){
        guard let loginData = APIGateway.shared.loginData else {return}
        if let name = loginData.loginDetail?.contactName{
            Crashlytics.sharedInstance().setUserName(name)
        }
        if let contactId = loginData.loginDetail?.contactId{
            Crashlytics.sharedInstance().setUserIdentifier("\(contactId)")
        }
    }
    
    static func extractYoutubeIdFromLink(_ link: String) -> String? {
        
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0,length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            print(firstMatch)
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
    
    static func getAndParseJson(fileName: String) -> NSDictionary? {
        var jsonResult: NSDictionary?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {//OrderTracking
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    
                } catch {
                    let nsError = error as NSError
                    print(nsError.localizedDescription)
                }
            } catch {}
        }
        return jsonResult ?? NSDictionary.init()
    }
    static func deviceUdid() -> String{
        if let UUIDValue = UIDevice.current.identifierForVendor{
            return UUIDValue.uuidString
        }
        return ""
    }
}
extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
//            let extraPadding : CGFloat = 500.0
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
//            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y + extraPadding,width: 1,height: self.frame.height), animated: animated)
            self.contentOffset = CGPoint.init(x: 0, y: childStartPoint.y)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}


