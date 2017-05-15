//
//  PlayerControllerModel.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class PlayerControllerModel {
    var index: Int
    var playlist: Playlist!
    var parentIsPlaylist: Bool = false
    var menuActive: MenuActive = .none
    var playListItem: PlaylistItem?
    
    init(index: Int) {
        self.index = index
    }
}
