//
//  MenuOptionView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class MenuOptionView: UIView {
    
    var optionLabel: UILabel = {
        let option = UILabel()
        option.textColor = .white
        option.backgroundColor = .clear
        option.textAlignment = .center
        return option
    }()
    
    func setText(string: String) {
        optionLabel.text = string
    }
    
    func setupConstraints() {
        backgroundColor = .clear
        addSubview(optionLabel)
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        optionLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        optionLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
}
