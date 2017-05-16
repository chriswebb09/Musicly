//
//  ListControllerDataSource.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class ListControllerDataSource: TracksDataSource, PlaylistCreatorProtocol {
    var image = #imageLiteral(resourceName: "search-button").withRenderingMode(.alwaysOriginal)
    
    var playlist = Playlist()
    
    var tracklist = TrackList() {
        didSet {
            playlist = getPlaylist(from: tracklist)
        }
    }
    var store: iTrackDataStore
    var count: Int {
        return playlist.itemCount
    }
    
    init(store: iTrackDataStore) {
        self.store = store
    }
    
    func cellInstance(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TrackCell
        if let playlistItem = playlist.playlistItem(at: indexPath.row),
            let track = playlistItem.track,
            let url = URL(string: track.artworkUrl) {
            let cellViewModel = TrackCellViewModel(trackName: track.trackName, albumImageUrl: url)
            cell.configureCell(with: cellViewModel, withTime: 0)
            cell.alpha = 1
        }
        return cell
    }

}

extension ListControllerDataSource: TrackStateProtocol {

    var state: TrackContentState {
        return getState(for: count)
    }
}
