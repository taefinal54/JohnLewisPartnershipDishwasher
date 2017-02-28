//
//  LandScapeView.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 27/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import UIKit

class LandScapeView: UIView {


    
    @IBOutlet var view: UIView!
    @IBOutlet weak var imagePageView: UIPageControl!
    @IBOutlet weak var sliderImageView: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var itemIndex: Int = 0 // ***
    var imageName: String = "" {
    
        didSet {
    
        if let imageView = sliderImageView {
        imageView.image = UIImage(named: imageName)
        }
    
        }
    }
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
        UINib(nibName: "LandScapeView", bundle: bundle).instantiate(withOwner: self, options: nil)
        
        addSubview(view)
        view.frame = bounds
         sliderImageView!.image = UIImage(named: imageName)
    }

}
