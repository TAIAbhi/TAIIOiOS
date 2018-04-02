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
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    private lazy var loginRouter = LoginRouter(with: self)
    private lazy var interactor = LoginInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login"
        
        setup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setup() {
        // login button changes
        loginButton.layer.cornerRadius = 4.0
        loginButton.layer.masksToBounds = true
        
        // Logo gif
        logoImageView.image = UIImage.gifImageWithName("Logo")
    }

    func triggerLogin() {
        guard let mobile = mobileTextField.text, mobile.count == 10 else { return }
        guard let password = passwordTextField.text else { return }
        
        interactor.loginUserWithMobile(mobile, andPassword: password) { [weak self] (didLogin) in
            guard let strongSelf = self else{ return }
            if didLogin {
                strongSelf.loginRouter.openTabbar()
            } else {
                print("Login failed")
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        triggerLogin()
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case passwordTextField:
            triggerLogin()
        default:
            break
        }
        
        return true
    }
}

// Keyboard delegates
extension LoginViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if logoTopConstraint.constant == 20 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.logoTopConstraint.constant = -231
                    self.view.layoutSubviews()
                })
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if logoTopConstraint.constant != 20 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.logoTopConstraint.constant = 20
                    self.view.layoutSubviews()
                })
            }
        }
    }
}
