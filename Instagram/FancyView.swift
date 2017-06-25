//
//  FancyView.swift
//  Instagram
//
//  Created by PRIYESH  on 02/04/17.
//  Copyright © 2017 PRIYESH . All rights reserved.
//

import UIKit

class FancyView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 15.0
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
    }
}
