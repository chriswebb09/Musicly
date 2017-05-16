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

extension UICollectionView {
    
    func setup(with newLayout: TrackItemsFlowLayout) {
        newLayout.setup()
        collectionViewLayout = newLayout
        frame = UIScreen.main.bounds
    }
    
    func tetherToController(controller: UIViewController) {
        self.dataSource = controller as? UICollectionViewDataSource
        self.delegate = controller as? UICollectionViewDelegate
    }
    
    func register<T: UICollectionViewCell>(_ :T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not deque cell")
        }
        return cell
    }
}
