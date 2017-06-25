//
//  RoundedImageVIew.swift
//  Instagram
//
//  Created by PRIYESH  on 02/05/17.
//  Copyright © 2017 PRIYESH . All rights reserved.
//

import UIKit
class RoundedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.cornerRadius = self.frame.width/2.2
        clipsToBounds = true
        
    }

}
