//
//  ButtonHelpers.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

enum ButtonType {
    case login(title:String), system(title:String, color: UIColor), tag(title:String, color:UIColor, tag: Int, index: IndexPath)
    
    fileprivate func setupLoginButton(with title:String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0)
        button.setAttributedTitle( NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.blue, NSFontAttributeName: UIFont(name: "Avenir-Book", size: 10)!]), for: .normal)
        button.layer.cornerRadius = 2
        return button
    }
    
    fileprivate func setupSystemButton(with title:String, color: UIColor?) -> UIButton {
        let button = TagButton()
        button.setAttributedTitle( NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0), NSFontAttributeName: UIFont(name: "Avenir-Book", size: 10)!]), for: .normal)
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        return button as UIButton
    }
    
    fileprivate func setupTagButton(with title:String, color: UIColor?, tag: Int, index: IndexPath) -> TagButton {
        let button = TagButton()
        button.setAttributedTitle( NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.blue, NSFontAttributeName: UIFont(name: "Avenir-Book", size: 10)!]), for: .normal)
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.buttonTag = tag
        button.index = index
        return button
    }
    
    var newButton: UIButton {
        switch self {
        case let .login(title):
            return setupLoginButton(with: title)
        case let .system(title, color):
            return setupSystemButton(with: title, color: color)
        default:
            return UIButton()
        }
    }
    
    var tagButton: TagButton {
        switch self {
        case let .tag(title: title, color: color, tag: tag, index:index):
            return setupTagButton(with: title, color: color, tag: tag, index:index)
        default:
            return TagButton()
        }
    }
}

class TagButton: UIButton {
    var buttonTag: Int?
    var index: IndexPath?
}
