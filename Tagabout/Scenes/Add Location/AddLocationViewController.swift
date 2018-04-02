//
//  AddLocationViewController.swift
//  Tagabout
//
//  Created by Madanlal on 24/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

protocol AddLocationProtocol: class {
    func updateLocation(_ location: String)
}

class AddLocationViewController: UIViewController {

    @IBOutlet private weak var suburbTextField: DropDownView!
    @IBOutlet private weak var locationTextField: DropDownView!
    
    private let interactor = AddLocationInteractor()
    
    weak var delegate: AddLocationProtocol?
    
    private var suburbsArray: [Suburb]? {
        didSet {
            if let suburbs = suburbsArray {
                suburbTextField.updateDataSource(suburbs.map({ (suburb) in
                    if let name = suburb.suburb {
                        return name
                    }
                    return ""
                }))
            }
        }
    }
    
    private var locationsArray: [Location]? {
        didSet {
            if let locations = locationsArray {
                locationTextField.updateDataSource(locations.map({ (location) in
                    if let name = location.locationName {
                        return name
                    }
                    return ""
                }))
            }
        }
    }
    
    private var selectedSuburb: Suburb?
    private var selectedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFields()
        
        interactor.fetchSuburbs { [weak self] (suburbs) in
            guard let strongSelf = self else{ return }
            strongSelf.suburbsArray = suburbs
        }
    }

    @IBAction func closeScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddButtonPress(_ sender: Any) {
        if let suburb = suburbTextField.textField.text, let location = locationTextField.textField.text {
            interactor.addLocation(suburb: suburb, location: location, completion: { (success) in
                if let delegate = self.delegate, success {
                    self.dismiss(animated: true, completion: {
                        delegate.updateLocation("\(location) - \(suburb)")
                    })
                }
            })
        }
    }
    
    func setupFields() {
        suburbTextField.hookDropdown(placeHolder: "Suburb",
                                     dataSource: [String]()) { (index, text) in
                                            if let suburb = self.suburbsArray?[index] {
                                                self.selectedSuburb = suburb
                                            }
                                            
        }
        
        locationTextField.hookDropdown(placeHolder: "Location",
                                     dataSource: [String]()) { (index, text) in
                                        if let str = self.locationsArray?[index] {
                                            self.selectedLocation = str
                                        }
                                        
        }
        
        locationTextField.onTextFieldChange = onTextFieldChange
    }
    
    func onTextFieldChange(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        
        if let text = textField.text, text != "" {
            let query = text + string
            interactor.fetchLocationFromQuery(query) { [weak self] (locations) in
                guard let strongSelf = self else{ return }
                strongSelf.locationsArray = locations
            }
        }
        
        return true
    }
}
