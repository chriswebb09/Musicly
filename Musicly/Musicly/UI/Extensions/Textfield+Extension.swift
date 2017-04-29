//
//  Textfield+Extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/24/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class TextFieldExtension: UITextField {
    
    // Sets textfield input to + 10 inset on origin x value
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 12,
                      y: bounds.origin.y,
                      width: bounds.width + 12,
                      height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 12,
                      y: bounds.origin.y,
                      width: bounds.width + 12,
                      height: bounds.height)
    }
}
