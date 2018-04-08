//
//  LoadingView.swift
//  Tagabout
//
//  Created by Karun Pant on 08/04/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!

}

class LoadingInteractor{
    
    public static var shared:LoadingInteractor = LoadingInteractor()
    
    public var viewFrame: CGRect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height) {
        didSet{
            loadingView.frame = viewFrame
        }
    }
    public var color = UIColor.init(white: 1, alpha:0.2){
        didSet{
            loadingView.backgroundColor = color
        }
    }
    
    private var _loadingView : LoadingView? = nil
    private var loadingView:LoadingView{
        if let loadingView = LoadingInteractor.shared._loadingView{
            return loadingView
        }else{
            LoadingInteractor.shared._loadingView = Bundle.main.loadNibNamed("LoadingView", owner: nil, options: nil)?.first as? LoadingView
            return LoadingInteractor.shared._loadingView!
            
        }
    }
    
    func show(){
        loadingView.alpha = 0
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.loadingView.alpha = 1.0
        appDelegate.window?.addSubview(loadingView)
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.alpha = 1.0
        }, completion: { (isComplete) in
            self.loadingView.loadingActivity.startAnimating()
        })
        
    }
    
    func hide(){
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.alpha = 0
        }, completion: { (isComplete) in
            self.loadingView.loadingActivity.stopAnimating()
            self.loadingView.removeFromSuperview()
            self._loadingView = nil
        })
    }
}
