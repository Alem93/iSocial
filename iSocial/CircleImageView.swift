//
//  CircleImageView.swift
//  iSocial
//
//  Created by Alejandro Mamchur on 8/19/17.
//  Copyright © 2017 Alejandro Mamchur. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 9.0
        layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        layer.cornerRadius = 2.0
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.width / 2
    }
    
}
