//
//  RealmClient.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import RealmSwift

class RealmClient {
    
    var realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func getTracks() -> Results<Track> {
        return realm.objects(Track.self)
    }
    
    func getTrackList() -> Results<TrackList> {
        return realm.objects(TrackList.self)
    }
    
    func getFilteredTrackList(predicate: String) -> Results<TrackList> {
        return realm.objects(TrackList.self).filter("listId == %@", predicate)
    }
    
    func save(list: TrackList) {
        if let realm = try? Realm() {
            try! realm.write {
                realm.add(list, update: true)
            }
        }
    }
    
    func save(track: Track, playlistID: String) {
        var tracklist: Results<TrackList>!
        
        if let realm = try? Realm() {
            tracklist = realm.objects(TrackList.self).filter("listId == %@", playlistID)
            guard let lastTracklist = tracklist.last else { return }
            
            try! realm.write {
                lastTracklist.appendToTracks(track: track)
                realm.add(lastTracklist, update: true)
                realm.add(tracklist, update: true)
                realm.refresh()
            }
        }
    }
}
