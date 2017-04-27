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
        layout.minimumLineSpacing = SmallLayoutProperties.minimumLineSpacing
        return layout
    }
    
    static func setupLayout() -> UICollectionViewFlowLayout {
        let newLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        newLayout.sectionInset = EdgeAttributes.sectionInset
        newLayout.itemSize = RowSize.item.rawValue
        newLayout.minimumInteritemSpacing = CollectionViewConstants.layoutSpacingMinItem
        newLayout.minimumLineSpacing = CollectionViewConstants.layoutSpacingMinLine
        return newLayout
    }
}
