//
//  Playlist.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/13/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class Playlist {
    var playlistName: String
    var tracks: [iTrack]
    
    init(tracks: [iTrack], playlistName: String) {
        self.tracks = tracks
        self.playlistName = playlistName
    }
}
