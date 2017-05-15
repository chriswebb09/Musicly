//
//  TrackCellCreator.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol TrackCellCreator {
    func setTrackCell(indexPath: IndexPath, cell: TrackCell, playlist: Playlist)
}

extension TrackCellCreator {
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
