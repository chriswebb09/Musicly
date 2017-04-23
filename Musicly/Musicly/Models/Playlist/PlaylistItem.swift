//
//  PlaylistItem.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/20/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class PlaylistItem: Object {
    var track: Track?
    var next: PlaylistItem?
    weak var previous: PlaylistItem?
}

