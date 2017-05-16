//
//  ButtonFactory.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/16/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol ButtonMaker {
    func createButton() -> UIButton
}

class BasicButtonFactory: ButtonMaker {
    var text: String
    var textColor: UIColor
    var buttonBorderWidth: CGFloat
    var buttonBorderColor: CGColor
    var buttonBackgroundColor: UIColor
    
    init(text: String, textColor: UIColor, buttonBorderWidth: CGFloat, buttonBorderColor: CGColor, buttonBackgroundColor: UIColor) {
        self.text = text
        self.textColor = textColor
        self.buttonBorderWidth = buttonBorderWidth
        self.buttonBorderColor = buttonBorderColor
        self.buttonBackgroundColor = buttonBackgroundColor
    }
    
    
    func createButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = buttonBackgroundColor
        button.layer.borderWidth = buttonBorderWidth
        button.setTitle(text, for: .normal)
        return button
    }

    
}
