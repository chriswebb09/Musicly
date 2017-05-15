//
//  TrackCellCollectionProtocol.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/14/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol TrackCellCollectionProtocol {
    func collectionViewRegister(collectionView: UICollectionView, viewController: UIViewController, identifier: String)
}

extension TrackCellCollectionProtocol {
    func collectionViewRegister(collectionView: UICollectionView, viewController: UIViewController, identifier: String) {
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.dataSource = viewController as? UICollectionViewDataSource
        collectionView.delegate = viewController as? UICollectionViewDelegate
    }
}
