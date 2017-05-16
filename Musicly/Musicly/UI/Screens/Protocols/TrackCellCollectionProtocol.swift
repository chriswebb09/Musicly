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
    func setupEmptyView(emptyView: EmptyView, for view: UIView)
}

extension TrackCellCollectionProtocol {
    
    func collectionViewRegister(collectionView: UICollectionView, viewController: UIViewController, identifier: String) {
        collectionView.register(TrackCell.self)
        collectionView.tetherToController(controller: viewController)
    }
    
    func setupEmptyView(emptyView: EmptyView, for view: UIView) {
        view.backgroundColor = .clear
        view.addSubview(emptyView)
        emptyView.layoutSubviews()
        emptyView.frame = view.frame
    }
}
