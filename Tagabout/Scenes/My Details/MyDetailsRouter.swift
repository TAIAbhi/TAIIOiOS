//
//  MyDetailsRouter.swift
//  Tagabout
//
//  Created by Madanlal on 24/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import UIKit

struct MyDetailsRouter {
    
    private weak var viewController: MyDetailsViewController?
    
    init(with viewController: MyDetailsViewController) {
        self.viewController = viewController
    }
    
    func presentAddLocationViewController() {
        viewController?.performSegue(withIdentifier: "MyDetailsToAddLocation", sender: nil)
    }
    
    func showAddContactsViewController(foruser user:User?){
        self.viewController?.navigationController?.pushViewController(AddContactTableViewController.addContactTableViewController(byUser: user!), animated: true)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyDetailsToAddLocation", let vc = segue.destination as? AddLocationViewController {
            vc.delegate = viewController
        }
    }
}
