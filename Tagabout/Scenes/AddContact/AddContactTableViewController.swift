//
//  AddContactTableViewController.swift
//  Tagabout
//
//  Created by Arun Jangid on 11/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import AddressBook
import AddressBookUI
import Contacts
import ContactsUI
import DropDown

class AddContactTableViewController: UITableViewController, CNContactPickerDelegate,UITextFieldDelegate {
    
    static func addContactTableViewController(byUser user:User) -> AddContactTableViewController{
        let storyBoard = UIStoryboard.init(name: "UserStory", bundle: Bundle.main)
        let addContact = storyBoard.instantiateViewController(withIdentifier: "AddContactTableViewController") as! AddContactTableViewController
        addContact.user = user
        return addContact
    }
    
    

    @IBOutlet weak var detailsUpdatedButton: UIButton!
    @IBOutlet weak var allowProvideSuggestionButton: UIButton!
    
    private let interactor = MyDetailsInteractor()
    
    private var selectedTextField: SkyFloatingLabelTextField?
    
    @IBOutlet weak var referredByLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var nameLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var contactNumberLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var location1Label: SkyFloatingLabelTextField!
    @IBOutlet weak var location2Label: SkyFloatingLabelTextField!
    @IBOutlet weak var location3Label: SkyFloatingLabelTextField!
    @IBOutlet weak var professionalDetails: SkyFloatingLabelTextField!
    
    private let locationInteractor = AddLocationInteractor()
    private var locations: [Location]? {
        didSet {
            updateDataSourceForDropDown()
        }
    }
    
    private let dropDown = DropDown()
    
    var user:User?
    var getRole:Int{
        if let loginDetail = APIGateway.shared.loginData?.loginDetail, let role = loginDetail.role{
            return role
        }
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if getRole == 2 {
            referredByLabel.isEnabled = false
            referredByLabel.text = user?.contact
        }else{
            referredByLabel.isEnabled = true
        }
    }
    @IBAction func showMyAddedList(_ sender: UIButton) {
        
    }
    @IBAction func actionFetchContacts(_ sender: UIButton) {
        let contactsPicker = CNContactPickerViewController()
        contactsPicker.isEditing = true
        
        contactsPicker.delegate = self
        self.present(contactsPicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let fetchName = contact.givenName
        _ = contact.phoneNumbers
        var phoneNo = ""
        for number in contact.phoneNumbers{
            if contact.givenName.count > 0 && number.value.stringValue.count > 8{
                var numString = number.value.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
                // print("\(numString) - \(numString.letterize().count)")
                numString = numString.replacingOccurrences(of: "(", with: "")
                numString = numString.replacingOccurrences(of: ")", with: "")
                numString = numString.replacingOccurrences(of: "-", with: "")
                numString = numString.replacingOccurrences(of: " ", with: "")
                numString = numString.replacingOccurrences(of: "\u{00a0}", with: "")
                
                //print("\(numString) - \(numString.letterize().count)")
                phoneNo = numString
                
                print("contact details are \(contact.givenName) \(numString) ")
                break
            }
        }
        
        nameLabel.text = fetchName
        contactNumberLabel.text = phoneNo
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
    }
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//
//    }
    
    
    @IBAction func allowProvideSuggestionsAndDetailsSubmitted(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setTitleColor(UIColor.green, for: .normal)
        }else{
            sender.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    

    @IBAction func actionSubmitContact(_ sender: UIButton) {
        
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
        if let comments = professionalDetails.text {
            postData["comments"] = comments
        }
        if let contactId = user?.contactId {
            postData["sourceId"] = contactId
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
        
        interactor.addContactDetailsWithData(postData) { (done) in
            let alert = UIAlertController(title: "Success", message: "Contact Added Succesfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        
        if let textfield = textField as? SkyFloatingLabelTextField,
            textfield == location1Label || textfield == location2Label || textfield == location3Label {
            selectedTextField = textfield
            setDropDownForSelectedTextField()
        }else{
            selectedTextField = nil
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
    
    func setDropDownForSelectedTextField() {
        
        guard let textField = selectedTextField else { return }
        
        // The view to which the drop down will appear on
        
        
        dropDown.shadowRadius = 1
        dropDown.shadowOpacity = 0.2
        dropDown.topOffset = CGPoint(x: 0, y: 54)
        dropDown.bottomOffset = CGPoint(x: 0, y:(textField.bounds.size.height + 5))
        dropDown.anchorView = textField
        dropDown.dismissMode = .automatic
    }
    
    func updateDataSourceForDropDown() {
        guard let textField = selectedTextField else { return }
        
        // The list of items to display. Can be changed dynamically
        guard let locations = locations else { return }
        if textField.text?.trimmingCharacters(in: .whitespaces) != ""{
            dropDown.dataSource = locations.map({ (location) in
                if let locationName = location.locationName, let suburb = location.locSuburb {
                    return "\(locationName) - \(suburb)"
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
