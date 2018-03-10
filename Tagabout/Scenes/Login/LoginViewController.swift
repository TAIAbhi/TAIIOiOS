//
//  LoginViewController.swift
//  Tagabout
//
//  Created by Madanlal on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private lazy var interactor = LoginInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login"
        
        setup()
    }
    
    func setup() {
        // textfield default colors
        mobileTextField.setCutomDefaultValues()
        passwordTextField.setCutomDefaultValues()
        
        // login button changes
        loginButton.layer.cornerRadius = 4.0
        loginButton.layer.masksToBounds = true
    }

    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        interactor.loginUserWithMobile(mobileTextField.text!, andPassword: passwordTextField.text!, withSuccessHandler: { (data) in
            
        }) { (error) in
            
        }
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
