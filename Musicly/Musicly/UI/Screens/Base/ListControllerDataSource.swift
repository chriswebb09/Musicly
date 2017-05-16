//
//  ListControllerDataSource.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class ListControllerDataSource {
    
    let image = #imageLiteral(resourceName: "search-button").withRenderingMode(.alwaysOriginal)
    
    var playlist = Playlist()
    
    var tracklist = TrackList() {
        didSet {
            for track in tracklist.tracks {
                let newItem = PlaylistItem()
                newItem.track = track
                if !playlist.contains(playlistItem: newItem) {
                    DispatchQueue.main.async {
                        self.playlist.append(newPlaylistItem: newItem)
                    }
                    
                }
            }
        }
    }
    
    var store: iTrackDataStore!
    
    var count: Int {
        return playlist.itemCount
    }
    
    var state: TrackContentState {
        if count > 0 {
            return .results
        } else {
            return .none
        }
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
