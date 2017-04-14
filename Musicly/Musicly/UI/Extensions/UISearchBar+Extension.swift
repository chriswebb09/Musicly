//
//  UISearchBar+Extension.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    // TODO: - This can be implemented better / Possibly unnecessary
    
    func getTextFromBar() -> String {
        let bar = self
        if let barText = bar.text {
            return barText
        }
        return ""
    }
}

