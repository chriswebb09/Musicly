//
//  TrackItemsLayout.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/28/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class TrackItemsFlowLayout: UICollectionViewFlowLayout {

    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 4.5)
        sectionInset = UIEdgeInsets(top: 20, left: 25, bottom: 30, right: 25)
        minimumLineSpacing = 25
    }
}

