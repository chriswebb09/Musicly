//
//  TracksViewModel.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class TracksViewControllerDataSource {
    
    var playlist = Playlist() {
        didSet {
            
        }
    }
    var store: iTrackDataStore! {
        didSet {
            
        }
    }

    public var count: Int {
        return playlist.itemCount
    }
    
    var image = #imageLiteral(resourceName: "search-button").withRenderingMode(.alwaysOriginal)
    
    public var state: TrackContentState = .results
    
    func getRowTime(indexPath: IndexPath) -> Double {
        var rowTime: Double = 0
        if indexPath.row > 10 {
            rowTime = (Double(indexPath.row % 10)) / CollectionViewConstants.rowTimeDivider
        } else {
            rowTime = (Double(indexPath.row)) / CollectionViewConstants.rowTimeDivider
        }
        return rowTime
    }
    
    
    func cellModel(for indexPath: IndexPath) -> TrackCellViewModel? {
        guard let track = playlist.playlistItem(at: indexPath.row)?.track else { return nil }
        let name = track.trackName
        guard let url = URL(string: track.artworkUrl) else { return nil }
        let cellModel = TrackCellViewModel(trackName: name, albumImageUrl: url)
        return cellModel
    }
    
    func setTrackCell(indexPath: IndexPath?, cell: TrackCell) {
        var rowTime: Double
        if let index = indexPath {
            rowTime = getRowTime(indexPath: index)
            let cellModel = self.cellModel(for: index)
            cell.configureCell(with: cellModel!, withTime: rowTime)
        }
    }
}


