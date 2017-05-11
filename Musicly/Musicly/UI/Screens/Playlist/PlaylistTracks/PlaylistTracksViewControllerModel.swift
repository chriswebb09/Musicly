//
//  PlaylistTracksViewControllerModel.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class TracksPlaylistDataSource {
    
    var playlist = Playlist()
    var store: iTrackDataStore! 
    var tracklist = TrackList() {
        didSet {
            playlist.id = tracklist.listId
            playlist.name = tracklist.listName
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
    
    var count: Int {
        return tracklist.tracks.count
    }
    
    var image = #imageLiteral(resourceName: "search-button").withRenderingMode(.alwaysOriginal)
    
    var state: TrackContentState {
        if count > 0 {
            return .results
        } else {
            return .none
        }
    }
    
    var title: String {
         return tracklist.listName
    }
    
    func getRowTime(indexPath: IndexPath, for rowTime: Double) -> Double {
        if indexPath.row > 10 {
            return (Double(indexPath.row % 10)) / CollectionViewConstants.rowTimeDivider
        } else {
            return (Double(indexPath.row)) / CollectionViewConstants.rowTimeDivider
        }
       
    }
    
    
    func cellModel(for indexPath: IndexPath) -> TrackCellViewModel? {
        guard let track = playlist.playlistItem(at: indexPath.row)?.track else { return nil }
        let name = track.trackName
        guard let url = URL(string: track.artworkUrl) else { return nil }
        let cellModel = TrackCellViewModel(trackName: name, albumImageUrl: url)
        return cellModel
    }
    
    func setTrackCell(indexPath: IndexPath?, cell: TrackCell) {
        var rowTime: Double = 0
        if let index = indexPath {
            rowTime = getRowTime(indexPath: index, for: rowTime)
            let cellModel = self.cellModel(for: index)
            cell.configureCell(with: cellModel!, withTime: rowTime)
        }
    }
}
