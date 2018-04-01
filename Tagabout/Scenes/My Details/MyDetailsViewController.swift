//
//  MyDetailsViewController.swift
//  Tagabout
//
//  Created by Madanlal on 14/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DropDown

class MyDetailsViewController: UIViewController {
    
    private let interactor = MyDetailsInteractor()
    private let locationInteractor = AddLocationInteractor()
    private lazy var router = MyDetailsRouter(with: self)
    private var user: User? {
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
    
    private var selectedTextField: SkyFloatingLabelTextField?
    private var locations: [Location]? {
        didSet {
            updateDataSourceForDropDown()
        }
    }
    private let dropDown = DropDown()

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
        
        interactor.fetchMyDetails { [unowned self] (user) in
            self.user = user
        }
        
        let rightButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(MyDetailsViewController.openAddLocation))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @IBAction func onUpdateButtonClick(_ sender: UIButton) {
        var postData = [String: Any]()
        if let location1 = location1Label.text {
            postData["location1"] = location1
        }
        if let location2 = location2Label.text {
            postData["location2"] = location2
        }
        if let location3 = location3Label.text {
            postData["location3"] = location3
        }
        if let comments = detailsTextArea.text {
            postData["comments"] = comments
        }
        if let contactId = user?.contactId {
            postData["contactId"] = contactId
        }
        interactor.updateMyDetailsWithData(postData) { (done) in
            print(done)
        }
    }
    
    @objc func openAddLocation() {
        router.presentAddLocationViewController()
    }
}

extension MyDetailsViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 251, 0)
        
        if let textfield = textField as? SkyFloatingLabelTextField,
            textfield == location1Label || textfield == location2Label || textfield == location3Label {
            selectedTextField = textfield
            setDropDownForSelectedTextField()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, text != "" {
            let query = text + string
            locationInteractor.fetchLocationFromQuery(query) { [unowned self] (locations) in
                self.locations = locations
            }
        }
        
        return true
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
        selectedTextField = nil
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

extension MyDetailsViewController: AddLocationProtocol {
    func updateLocation(_ location: String) {
        print(location)
    }
}

extension MyDetailsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.prepare(for: segue, sender: sender)
    }
}

extension MyDetailsViewController {
    
    func setDropDownForSelectedTextField() {
        
        guard let textField = selectedTextField else { return }
        
        // The view to which the drop down will appear on
        dropDown.anchorView = textField
        dropDown.direction = .bottom
        dropDown.shadowRadius = 1
        dropDown.shadowOpacity = 0.2
        dropDown.bottomOffset = CGPoint(x: 0, y:48)
    }
    
    func updateDataSourceForDropDown() {
        guard let textField = selectedTextField else { return }
        
        // The list of items to display. Can be changed dynamically
        guard let locations = locations else { return }
        dropDown.dataSource = locations.map({ (location) in
            if let name = location.locSuburb {
                return name
            }
            return ""
        })
        
        dropDown.selectionAction = { (index: Int, item: String) in
            let selectedLocation = locations[index]
            textField.text = selectedLocation.locSuburb
        }
        
        dropDown.show()
    }
    
}
