//
//  DesignableView.swift
//  Tagabout
//
//  Created by Karun Pant on 03/03/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit


@IBDesignable
class DesignableView: UIView {

    var contentView: UIView?
    @IBInspectable var nibName: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designableViewSetup()
    }
    
    func designableViewSetup(){
        guard let view = loadFromNIB() else{ return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadFromNIB() -> UIView? {
        guard let nibName = nibName else{ return nil }
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        designableViewSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
