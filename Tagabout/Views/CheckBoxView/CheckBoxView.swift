//
//  CheckBoxView.swift
//  Tagabout
//
//  Created by Karun Pant on 08/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit

class CheckBoxView: DesignableView {
    private let imgNormal : UIImage = #imageLiteral(resourceName: "checkboxNormal")
    private let imgSelected : UIImage = #imageLiteral(resourceName: "checkboxSelected")

    @IBOutlet weak var imgCheckBox: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    public var onValueChange : ((Bool) -> ())?
    
    
    private var state = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public func setSelection(_ state : Bool){
        self.state = state
        imgCheckBox.image = state ? imgSelected : imgNormal
    }
    
    @IBAction func changeState(_ sender: UIButton) {
        state = !state
        imgCheckBox.image = state ? imgSelected : imgNormal
        if let onValueChange = self.onValueChange{
            onValueChange(self.state)
        }
    }
    

}
