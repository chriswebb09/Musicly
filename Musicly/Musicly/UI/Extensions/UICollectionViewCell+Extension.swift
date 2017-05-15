//
//  UICollectionViewCell+Extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/6/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
}


extension UICollectionViewCell {
    
    func setupPlaylistCellContentViewLayerStyle(for contentView: UIView) {
        contentView.layer.cornerRadius = PlaylistCellConstants.cornerRadius
        contentView.layer.borderWidth = PlaylistCellConstants.borderWidth
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
    
}
