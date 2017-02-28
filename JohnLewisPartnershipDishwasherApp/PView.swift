//
//  PView.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 27/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import UIKit

class PView: UIView {

    @IBOutlet var view: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView() {
        let bundle = Bundle(for: type(of: self))
        UINib(nibName: "PView", bundle: bundle).instantiate(withOwner: self, options: nil)
        
        addSubview(view)
        view.frame = bounds
    }
}
