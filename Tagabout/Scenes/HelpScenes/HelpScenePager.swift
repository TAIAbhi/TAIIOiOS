//
//  OnboardingPager.swift
//  Tagabout
//
//  Created by Karun Pant on 18/02/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import Foundation

class HelpScenePager: UIViewController {

    fileprivate var pages : [HelpPage] = [HelpPage]()
    fileprivate let pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    fileprivate var currentPage = 0
    
    private var forPath : String = ""
    public var forHelp: Help?
    private var pagesData : [PageData]?
    
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var loadingVideo: UIActivityIndicatorView!
    
    
    private var isLoadRequestDoneForPlayer = false
    private var isLoadDoneForPlayer = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let help = forHelp{
            if let helpTitle = help.moduleTitle{
                forPath = helpTitle
            }
            if let pageData = help.pageData{
                self.pagesData = pageData
            }
        }
        configurePages()
        setBottomButtonTitle()
        
    }
    
    
    func configurePages(){
        guard let pagesData = pagesData else { return }
        let mainStoryBoard = UIStoryboard.init(name: "HelpScenes", bundle: Bundle.main)
        
        for pageData in pagesData {
            if let page = mainStoryBoard.instantiateViewController(withIdentifier: "HelpPage") as? HelpPage{
                page.pageData = pageData
                pages.append(page)
            }
        }
        if let firstPage = pages.first{
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
            pageViewController.dataSource = self
            pageViewController.delegate = self
            view.addSubview(pageViewController.view)
        }
        if pages.count == 1 {
            pageControl.numberOfPages = 0
        }else{
            pageControl.numberOfPages = pages.count
        }
        self.view.bringSubview(toFront: self.pageControl)
        self.view.bringSubview(toFront: self.videoView)
        self.view.bringSubview(toFront: self.btnAdd)
        self.view.bringSubview(toFront: self.btnClose)
        
    }
    
    func setBottomButtonTitle(){
        if let forPathTitle = self.forPath.components(separatedBy: ",").first, currentPage == pages.count - 1{
            btnAdd.setTitle(forPathTitle.uppercased(), for: .normal)
            btnAdd.tag = 2
            playerView.isHidden = true
            lblTemp.isHidden = true
            DispatchQueue.main.async(execute: {[weak self] in
                guard let strongSelf = self else { return }
                if let pageData = strongSelf.pages[strongSelf.currentPage].pageData, let link = pageData.link, let extractedVideoID = GeneralUtils.extractYoutubeIdFromLink(link), !strongSelf.isLoadRequestDoneForPlayer{
                    strongSelf.loadingVideo.startAnimating()
                    strongSelf.playerView.load(withVideoId: extractedVideoID, playerVars: ["playsinline" : true, "autoplay" : true])
                    strongSelf.playerView.delegate = self
                    strongSelf.isLoadRequestDoneForPlayer = true
                }else if strongSelf.isLoadDoneForPlayer {
                    strongSelf.playerView.playVideo()
                }
            })
        }else{
            loadingVideo.stopAnimating()
            btnAdd.tag = 1
            lblTemp.isHidden = false
            btnAdd.setTitle("CONTINUE", for: .normal)
            playerView.isHidden = true
            
        }
    }
    @IBAction func doClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doAdd(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            doContinue()
            break
        case 2:
            doCloseAndOpen()
            break
        default:
            print("some other button tapped")
        }
    }
    func doContinue(){
        var pageIndex = currentPage
        pageIndex = pageIndex < pages.count ? pageIndex + 1 : pages.count - 1
        let page = pages[pageIndex]
        pageViewController.setViewControllers([page], direction: .forward, animated: true, completion: nil)
        currentPage = pageIndex
        pageControl.currentPage = currentPage
        setBottomButtonTitle()
        
    }
    func doCloseAndOpen()  {
        self.dismiss(animated: true) {[weak self] in
            guard let strongSelf = self else { return }
            guard let  name = strongSelf.forHelp?.moduleName,
                let moduleName = ModuleNames(rawValue: name)  else { return }
            HelpRouter.openDesiredScreen(moduleName: moduleName)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension HelpScenePager : UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        currentPage = pages.index(of: (viewController as? HelpPage)!)!
        setBottomButtonTitle()
        if currentPage == 0{
            // first index
            return nil
        }
        let previousIndex = abs((currentPage - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        currentPage = pages.index(of: (viewController as? HelpPage)!)!
        setBottomButtonTitle()
        if currentPage == pages.count - 1 {
            //last index reached
            return nil
        }
        let nextIndex = abs((currentPage + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        let pageIndex = pages.index(of: currentVC as! HelpPage)!
        pageControl.currentPage = pageIndex
    }
}

extension HelpScenePager : YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.loadingVideo.stopAnimating()
        isLoadDoneForPlayer = true
        playerView.playVideo()
        playerView.isHidden = false
    }
}
