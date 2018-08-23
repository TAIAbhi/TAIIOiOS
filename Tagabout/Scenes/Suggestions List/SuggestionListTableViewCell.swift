//
//  SuggestionListTableViewCell.swift
//  Tagabout
//
//  Created by Madanlal on 15/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

class SuggestionListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    var editHandler:((Suggestion) -> ())!
    
    
    var suggestion: Suggestion? {
        didSet {
            titleLabel.text = suggestion?.businessName ?? ""
            locationLabel.text = suggestion?.location ?? ""
            phoneNumberLabel.text = suggestion?.businessContact ?? ""
            if let comment = suggestion?.comments {
                commentsLabel.text = "Comments: \(comment)"
            } else {
                commentsLabel.text = "Comments:"
            }
            if let contactId = APIGateway.shared.loginData?.loginDetail?.contactId, contactId == suggestion?.contactId!{
                editbutton.isHidden = false
            }else{
                editbutton.isHidden = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func editAction(_ sender: UIButton) {
        if editHandler != nil, let suggestion = suggestion {
            editHandler(suggestion)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
