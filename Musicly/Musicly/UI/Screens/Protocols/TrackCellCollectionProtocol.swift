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
    func setTrackCell(indexPath: IndexPath, cell: TrackCell, playlist: Playlist)
}

extension TrackCellCollectionProtocol {
    
    func collectionViewRegister(collectionView: UICollectionView, viewController: UIViewController, identifier: String) {
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.dataSource = viewController as? UICollectionViewDataSource
        collectionView.delegate = viewController as? UICollectionViewDelegate
    }
    
    func setupEmptyView(emptyView: EmptyView, for view: UIView) {
        view.backgroundColor = .clear
        view.addSubview(emptyView)
        emptyView.layoutSubviews()
        emptyView.frame = view.frame
    }
    
    func setTrackCell(indexPath: IndexPath, cell: TrackCell, playlist: Playlist) {
        
        var rowTime: Double
        if let track = playlist.playlistItem(at: indexPath.row)?.track {
            if indexPath.row > 10 {
                rowTime = (Double(indexPath.row % 10)) / CollectionViewConstants.rowTimeDivider
            } else {
                rowTime = (Double(indexPath.row)) / CollectionViewConstants.rowTimeDivider
            }
            
            if let url = URL(string: track.artworkUrl) {
                let viewModel = TrackCellViewModel(trackName: track.trackName, albumImageUrl: url)
                cell.configureCell(with: viewModel, withTime: rowTime)
                print("Rowtime: \(rowTime)")
                UIView.animate(withDuration: rowTime / 10) {
                    cell.alpha = 1
                }
            }
        }
    }
}
