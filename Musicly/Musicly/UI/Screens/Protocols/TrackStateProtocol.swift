//
//  TrackStateProtocol.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/16/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol TrackStateProtocol {
    func getState(for count: Int) -> TrackContentState
}

extension TrackStateProtocol {
    func getState(for count: Int) -> TrackContentState {
        if count > 0 {
            return .results
        } else {
            return .none
        }
    }
}


protocol DataSourceProtocol {
    var count: Int { get }
    var store: iTrackDataStore { get }
}

protocol TracksDataSource: DataSourceProtocol {
    var playlist: Playlist { get set }
    var tracklist: TrackList { get set }
    var state: TrackContentState { get }
    var image: UIImage { get }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}
