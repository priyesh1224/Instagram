//
//  RoundedBtn.swift
//  Instagram
//
//  Created by PRIYESH  on 02/04/17.
//  Copyright © 2017 PRIYESH . All rights reserved.
//

import UIKit

class RoundedBtn: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.blue.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.cornerRadius = self.frame.width/2
        
    }

}
