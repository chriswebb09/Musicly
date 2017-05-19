//
//  UIView+Extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/18/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UIView {
    
    func constrainEdges(to view: UIView) {
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
}
