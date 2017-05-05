//
//  PlaylistItemLayout.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/29/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class PlaylistItemLayout: UICollectionViewFlowLayout {
    
    func setup() {
        
        sectionInset = UIEdgeInsets(top: 15, left: 20, bottom: 40, right: 20)
        itemSize = RowSize.item.rawValue
        minimumInteritemSpacing = 5
        minimumLineSpacing = 25
        scrollDirection = .vertical
    }
}
