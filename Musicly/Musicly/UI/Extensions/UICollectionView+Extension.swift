//
//  UICollectionView+Extension.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: NSStringFromClass(T.self))
    }
    
    func setupMusicIcon(icon: UIView) {
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35).isActive = true
        icon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.13).isActive = true
    }
    
   func setupInfoLabel(infoLabel: UILabel) {
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.02).isActive = true
    }
    
    static func setupCollectionView() -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView.collectionViewLayout.invalidateLayout()
        layout.sectionInset = PlaylistViewControllerConstants.edgeInset
        layout.itemSize = PlaylistViewControllerConstants.itemSize
   
        return collectionView
    }
    
    func setuLayout() {
        self.collectionViewLayout.invalidateLayout()
        self.layoutIfNeeded()
    }
}
