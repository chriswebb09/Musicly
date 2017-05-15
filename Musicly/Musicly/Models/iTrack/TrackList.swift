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

final class TrackList: Object {
    
    dynamic var listId: String = ""
    dynamic var listName: String = ""
    dynamic var date: String = ""
    var tracks = List<Track>()
    
    
    func appendToTracks(track: Track) {
        tracks.append(track)
    }
    
    func removeFromTracks() -> Track? {
        return tracks.removeLast()
    }
    
    override static func primaryKey() -> String? {
        return "listId"
    }
    
    func contains(track: Track) -> Bool {
        if tracks.contains(track) {
            return true
        }
        
        return false
    }
    
    
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
}

extension TrackList: IteratorProtocol {

    func next() -> Track? {
        return removeFromTracks()
    }

    typealias Element = Track
}


extension TrackList: Sequence {
    
}
