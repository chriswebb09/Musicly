//
//  PlaylistCreatorProtocol.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/16/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol PlaylistCreatorProtocol {
    func getPlaylist(from trackList: TrackList) -> Playlist
}

extension PlaylistCreatorProtocol {
    func getPlaylist(from trackList: TrackList) -> Playlist {
        var playlist = Playlist()
        for track in trackList.tracks {
            let newItem = PlaylistItem()
            newItem.track = track
            if !playlist.contains(playlistItem: newItem) {
                DispatchQueue.main.async {
                    playlist.append(newPlaylistItem: newItem)
                }
            }
        }
        return playlist
    }
}
