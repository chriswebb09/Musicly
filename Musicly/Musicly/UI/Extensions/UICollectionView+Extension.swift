//
//  UICollectionView+Extension.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func getHeader(indexPath: IndexPath, identifier: String) -> HeaderReusableView {
        let reusableView = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                            withReuseIdentifier: identifier,
                                                            for: indexPath) as! HeaderReusableView
        return reusableView
    }

    func updateLayout(newLayout: UICollectionViewLayout) {
        DispatchQueue.main.async {
            self.reloadData()
            self.setCollectionViewLayout(newLayout, animated: true)
        }
    }
    
    func setupMusicIcon(icon: UIView) {
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        icon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.13).isActive = true
    }
    
   func setupInfoLabel(infoLabel: UILabel) {
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.05).isActive = true
    }
    
}
