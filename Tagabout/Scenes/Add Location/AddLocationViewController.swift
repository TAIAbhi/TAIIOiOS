//
//  AddLocationViewController.swift
//  Tagabout
//
//  Created by Madanlal on 24/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var suburbTextField: TextFieldView!
    
    private let interactor = AddLocationInteractor()
    
    private var suburbsArray: [Suburb]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        setupFields()
        
        interactor.fetchSuburbs { [unowned self] (suburbs) in
            self.suburbsArray = suburbs
            self.setupFields()
        }
    }

    @IBAction func closeScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupFields() {
        suburbTextField.hookDropdown(placeHolder: "Suburb",
                                     dataSource: suburbsArray?.map({(suburb) in
                                        if let str = suburb.suburb {
                                            return str
                                        }
                                        return ""
                                        })) { (index, text) in
                                        
        }
    }
}
