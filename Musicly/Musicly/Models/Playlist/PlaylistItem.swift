//
//  PlaylistItem.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/20/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class PlaylistItem {
    
    var playListID: String? = ""
    var identifier: String? = ""
    
    var track: iTrack?
    
    var next: PlaylistItem? = nil
    weak var previous: PlaylistItem? = nil
    
    init(item: iTrack?) {
        self.track = item
    }
}

extension PlaylistItem: Equatable {
    static func ==(lhs: PlaylistItem, rhs: PlaylistItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension PlaylistItem: CustomStringConvertible {
    public var description: String {
        get {
            return "Node(\(identifier))"
        }
    }
}
