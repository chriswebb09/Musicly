//
//  PlaylistItem.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/20/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class PlaylistItem {
    var track: iTrack?
    var next: PlaylistItem?
    weak var previous: PlaylistItem?
}

extension PlaylistItem: Equatable {
    static func ==(lhs: PlaylistItem, rhs: PlaylistItem) -> Bool {
        return lhs.track!.previewUrl! == rhs.track!.previewUrl!
    }
}

