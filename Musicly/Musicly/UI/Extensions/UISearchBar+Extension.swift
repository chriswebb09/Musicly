//
//  UISearchBar+Extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/6/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    var hasInput: Bool {
        if let searchText = self.text {
            if searchText.characters.count > 0 {
                return true
            }
        }
        return false
    }
}
