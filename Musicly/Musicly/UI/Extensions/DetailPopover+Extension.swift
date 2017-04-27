//
//  DetailPopover+Extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/26/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension DetailPopover {
    func setupPop() {
        popView.configureView()
        popView.backgroundColor = CollectionViewAttributes.backgroundColor
        popView.doneButton.setTitleColor(PlaylistViewControllerConstants.mainColor, for: .normal)
        popView.doneButton.titleLabel!.font = UIFont(name: "Avenir-Book", size: 20)!
        popView.doneButton.setTitle("Done", for: .normal)
        popView.doneButton.layer.borderColor = PlaylistViewControllerConstants.mainColor.cgColor
        popView.doneButton.layer.borderWidth = 1.5
        popView.layer.borderWidth = 1.5
    }
}
