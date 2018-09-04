//
//  WebViewController.swift
//  Tagabout
//
//  Created by Arun Jangid on 28/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: ViewController{

    static func webViewController(forCityId cityId:Int) -> WebViewController{
        let webVC = WebViewController.instantiate(fromAppStoryboard: .UserStory)
        webVC.cityId = cityId
      return webVC
    }
    
    @IBOutlet weak var webViewContainer: UIView!
    var contentWebView: WKWebView!
    var cityId : Int? = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWebView(){
        let configuration = WKWebViewConfiguration()
        contentWebView = WKWebView(frame: webViewContainer.bounds, configuration: configuration)
        
        contentWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webViewContainer.addSubview(contentWebView)
        
        contentWebView.uiDelegate = self
        contentWebView.navigationDelegate = self
        
        contentWebView.scrollView.showsVerticalScrollIndicator = true
        contentWebView.scrollView.showsHorizontalScrollIndicator = false
        if let contactNumber = APIGateway.shared.loginData?.loginDetail?.mobile, let cityid = cityId{
            let url = URL(string: "http://tagaboutit.com/RequestSuggestion/SendRequest?cityId=\(cityid)&platform=1&contactnumber=\(contactNumber)")
            contentWebView.load(URLRequest(url: url!))
        }
    }

}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}

