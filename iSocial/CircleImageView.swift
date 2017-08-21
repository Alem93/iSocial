//
//  CircleImageView.swift
//  iSocial
//
//  Created by Alejandro Mamchur on 8/19/17.
//  Copyright © 2017 Alejandro Mamchur. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    
}
