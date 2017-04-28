//
//  UICollectionViewFlowLayout+extension.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    // collection view layout with small cells - possibly for animations 
    
    static func small() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = EdgeAttributes.sectionInset
        layout.itemSize = RowSize.smallLayout.rawValue
        layout.minimumInteritemSpacing = SmallLayoutProperties.minimumInteritemSpacing
        layout.minimumLineSpacing = 0
        return layout
    }
    
    static func setupLayout() -> UICollectionViewFlowLayout {
        let newLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        newLayout.sectionInset = UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 20)
        newLayout.itemSize = RowSize.item.rawValue
        newLayout.minimumInteritemSpacing = 5
        newLayout.minimumLineSpacing = 25
        return newLayout
    }
}
