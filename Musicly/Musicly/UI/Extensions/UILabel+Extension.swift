//
//  UILabel+Extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/13/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UILabel {
    
    static func setupInfoLabel() -> UILabel {
        let infoLabel: UILabel = UILabel()
        infoLabel.textAlignment = .center
        infoLabel.textColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
        infoLabel.font = UIFont(name: "Avenir-Book", size: 18)!
        infoLabel.text = "Search for music"
        return infoLabel
    }
    
    
}
