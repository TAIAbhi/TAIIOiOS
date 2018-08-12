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
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var detailsUpdatedButton: UIButton!
    @IBOutlet weak var allowProvideSuggestionButton: UIButton!
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
                detailsUpdatedButton.isSelected =  (user.isContactDetailsAdded?.hashValue ?? 0) == 0 ? false : true
                allowProvideSuggestionButton.isSelected = (user.allowProvideSuggestion?.hashValue ?? 0) == 0 ? false : true
                if detailsUpdatedButton.isSelected {
                    detailsUpdatedButton.setTitleColor(UIColor.green, for: .normal)
                }
                if allowProvideSuggestionButton.isSelected {
                    allowProvideSuggestionButton.setTitleColor(UIColor.green, for: .normal)
                }                
                detailsTextArea.layoutSubviews()
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
    @IBOutlet weak var detailsTextArea: FloatLabelTextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var getRole:Int{
        if let loginDetail = APIGateway.shared.loginData?.loginDetail, let role = loginDetail.role{
            return role
        }
        return 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTextArea.layer.cornerRadius = 4
        detailsTextArea.layer.borderColor = Theme.blue.cgColor
        detailsTextArea.layer.borderWidth = 2
        detailsTextArea.contentInset = UIEdgeInsets.init(top: 5, left: 8, bottom: 5, right: 8)
        detailsTextArea.titleFont = Theme.avenirTitle!
        self.fetchMydetails()
        
        if getRole == 1 {
            addButton.isHidden = true
        }
        
        let rightButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(MyDetailsViewController.openAddLocation))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func fetchMydetails(){
        interactor.fetchMyDetails { [weak self] (user) in
            guard let strongSelf = self else{ return }
            strongSelf.user = user
        }
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
            postData["contactid"] = contactId
        }
        
        if let contactName = nameLabel.text {
            postData["contactName"] = contactName
        }
        
        if let contactNumber = contactNumberLabel.text {
            postData["contactNumber"] = contactNumber
        }
        
        postData["contactLevelUnderstanding"] = "\(3)"
        postData["notification"] = "\(3)"
        postData["platform"] = "\(1)"
        postData["isContactDetailsAdded"] = detailsUpdatedButton.isSelected == true ? "true" : "false"
        postData["allowProvideSuggestion"] = allowProvideSuggestionButton.isSelected  == true ? "true" : "false"
        
        interactor.updateMyDetailsWithData(postData) { (done) in
            self.fetchMydetails()
        }
    }
    @IBAction func allowProvideSuggestions(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setTitleColor(UIColor.green, for: .normal)
        }else{
            sender.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    
    @IBAction func actionDetailsUpdated(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setTitleColor(UIColor.green, for: .normal)
        }else{
            sender.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    @IBAction func actionAddContact(_ sender: UIButton) {
        router.showAddContactsViewController(foruser: user)
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
        let query = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if query.trimmingCharacters(in: .whitespaces) != ""{
            locationInteractor.fetchLocationFromQuery(query) { [weak self] (locations) in
                guard let strongSelf = self else{ return }
                strongSelf.locations = locations
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
//        dropDown.topOffset = CGPoint(x: 0, y:64)
        dropDown.shadowRadius = 1
        dropDown.shadowOpacity = 0.2
        dropDown.bottomOffset = CGPoint(x: 0, y:48)
        dropDown.dismissMode = .automatic
    }
    
    func updateDataSourceForDropDown() {
        guard let textField = selectedTextField else { return }
        
        // The list of items to display. Can be changed dynamically
        guard let locations = locations else { return }
        if textField.text?.trimmingCharacters(in: .whitespaces) != ""{
            dropDown.dataSource = locations.map({ (location) in
                if let name = location.locationName, let suburb = location.suburb {
                    return "\(name) - \(suburb)"
                }
                return ""
            })
        }else{
            dropDown.dataSource = []
        }
        
        dropDown.selectionAction = { (index: Int, item: String) in
            let selectedLocation = locations[index]
            if let locationName = selectedLocation.locationName, let suburb = selectedLocation.suburb {
                textField.text = "\(locationName) - \(suburb)"
            }
        }
        
        dropDown.show()
    }
    
}
