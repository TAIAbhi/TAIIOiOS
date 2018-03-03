//
//  OnboardingPager.swift
//  Tagabout
//
//  Created by Karun Pant on 18/02/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
//import CHIPageControl

class OnboardingPager: UIViewController {

//    @IBOutlet weak var pageControl: CHIPageControlAleppo!
    fileprivate var pages : [UIViewController] = [UIViewController]()
    fileprivate let pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    fileprivate var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let page1 = mainStoryBoard.instantiateViewController(withIdentifier: "pageone")
        let page2 = mainStoryBoard.instantiateViewController(withIdentifier: "pagetwo")
        let page3 = mainStoryBoard.instantiateViewController(withIdentifier: "pagethree")
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([page1], direction: .forward, animated: false, completion: nil)
        let scrollView = pageViewController.view.subviews.filter {$0 is UIScrollView}.first as! UIScrollView
        scrollView.delegate = self
        // Do any additional setup after loading the view.
        view.addSubview(pageViewController.view)
//        view.bringSubview(toFront: pageControl)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension OnboardingPager : UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)
        if currentIndex == 0{
            // first index
            return nil
        }
        let previousIndex = abs((currentIndex! - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)
        if currentIndex == 2 {
            //last index reached
            return nil
        }
        let nextIndex = abs((currentIndex! + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if pages.count > 1 {
//            let point = scrollView.contentOffset;
//
//            let percentComplete = (point.x - self.view.frame.size.width)/self.view.frame.size.width;
//            NSLog("percentComplete: \(percentComplete)");
//            pageControl.progress = Double(percentComplete + CGFloat(currentPage))
//        }
//
//    }
    
}
