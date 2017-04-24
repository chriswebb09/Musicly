//
//  TrackList.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class TrackList: Object {
    
    dynamic var listId: String = ""
    dynamic var listName: String = ""
    dynamic var date: String = ""
    var tracks = List<Track>()
    
    
    func appendToTracks(track: Track) {
        tracks.append(track)
    }
    
    override static func primaryKey() -> String? {
        return "listId"
    }
}
