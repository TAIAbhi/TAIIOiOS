//
//  AddLocationViewController.swift
//  Tagabout
//
//  Created by Madanlal on 24/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    @IBOutlet private weak var suburbTextField: TextFieldView!
    @IBOutlet private weak var locationTextField: TextFieldView!
    
    private let interactor = AddLocationInteractor()
    
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
        
        interactor.fetchSuburbs { [unowned self] (suburbs) in
            self.suburbsArray = suburbs
        }
    }

    @IBAction func closeScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddButtonPress(_ sender: Any) {
        
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
        
        interactor.fetchLocationFromQuery(string) { [unowned self] (locations) in
            self.locationsArray = locations
        }
        
        return true
    }
}
