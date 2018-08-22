//
//  SuggestionListTableViewDataSource.swift
//  Tagabout
//
//  Created by Madanlal on 15/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import Foundation
import UIKit

class SuggestionListTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var suggestions: [Suggestion]?
    
    var editHandler:((Suggestion) -> ())!
    
    func setData(_ data: [Suggestion]) {
        suggestions = data
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions?.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell") as? SuggestionListTableViewCell
        
        cell?.suggestion = suggestions?[indexPath.row]
        cell?.editHandler = { suggestion in
            if self.editHandler != nil {
                self.editHandler(suggestion)
            }
        }
        return cell!
    }
    
}
