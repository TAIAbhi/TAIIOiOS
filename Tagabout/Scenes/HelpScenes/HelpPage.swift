//
//  HelpPageViewController.swift
//  Tagabout
//
//  Created by Karun Pant on 07/04/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit


class HelpPage: UIViewController {

    
    @IBOutlet weak var lblPageData: UILabel!
    
    public var pageData : PageData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pageData = pageData, let text = pageData.text{
            self.lblPageData.text = text
        }
        if let pageData = pageData, let link = pageData.link{
            //handle video
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
