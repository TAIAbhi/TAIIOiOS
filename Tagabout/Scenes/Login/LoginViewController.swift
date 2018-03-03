//
//  LoginViewController.swift
//  Tagabout
//
//  Created by Madanlal on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var mobileView: TextFieldView!
    @IBOutlet weak var passwordView: TextFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        mobileView.setHeader("Mobile:", withPlaceholder: "Mobile", forKey: "mobile")
        passwordView.setHeader("Password:", withPlaceholder: "Password", forKey: "password")
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
