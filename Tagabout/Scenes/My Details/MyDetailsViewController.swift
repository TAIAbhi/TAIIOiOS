//
//  MyDetailsViewController.swift
//  Tagabout
//
//  Created by Madanlal on 14/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MyDetailsViewController: UIViewController {
    
    let interactor = MyDetailsInteractor()
    var user: User? {
        didSet {
            if let user = user {
                referredByLabel.text = user.source ?? ""
                nameLabel.text = user.contact ?? ""
                contactNumberLabel.text = user.contactNumber ?? ""
                location1Label.text = user.location1 ?? ""
                location2Label.text = user.location2 ?? ""
                location3Label.text = user.location3 ?? ""
                detailsTextArea.text = user.contactComments ?? ""
            }
        }
    }

    @IBOutlet weak var referredByLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var nameLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var contactNumberLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var location1Label: SkyFloatingLabelTextField!
    @IBOutlet weak var location2Label: SkyFloatingLabelTextField!
    @IBOutlet weak var location3Label: SkyFloatingLabelTextField!
    @IBOutlet weak var detailsTextArea: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.fetchMyDetails { (user) in
            self.user = user
        }
    }
    
    @IBAction func onUpdateButtonClick(_ sender: UIButton) {
        
    }

}

extension MyDetailsViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 251, 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var tag = textField.tag
        tag += 1
        
        if tag < 7 {
            if let view = view.viewWithTag(tag) as? UITextField {
                view.becomeFirstResponder()
            }
        } else if tag == 7 {
            if let view = view.viewWithTag(tag) as? UITextView {
                view.becomeFirstResponder()
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // TextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 251, 0)
        scrollView.scrollRectToVisible(CGRect(x: 1, y: 600, width: 100, height: 1), animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
}
