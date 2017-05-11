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
    var trackLists: Results<TrackList>!
    var tracks: Results<Track>!
    
    init() {
        do {
            self.realm = try! Realm()
        }
    }
    
    func setObjects(completion: @escaping (_ trackLists: Results<TrackList>, _ tracks: Results<Track>, _ id: String) -> Void) {
        do {
            if let realm = try? Realm() {
                tracks = realm.objects(Track.self)
                trackLists = realm.objects(TrackList.self)
                if let list = trackLists.last {
                    completion(trackLists, tracks, list.listId)
                }
            }
        }
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
        do {
            if let realm = try? Realm() {
                realm.beginWrite()
                realm.add(list, update: true)
                try! realm.commitWrite()
            }
        }
    }
    
    func save(track: Track, playlistID: String) {
        var tracklist: Results<TrackList>!
        do {
            if let realm = try? Realm() {
                tracks = realm.objects(Track.self)
                tracklist = realm.objects(TrackList.self).filter("listId == %@", playlistID)
                
                guard let lastTracklist = tracklist.last else { return }
                
                if realm.object(ofType: Track.self, forPrimaryKey: track.previewUrl) == nil {
                    try! realm.write {
                        lastTracklist.appendToTracks(track: track)
                        guard !tracklist.contains(lastTracklist) else { return }
                        realm.add(lastTracklist, update: true)
                        realm.add(tracklist, update: true)
                        try! realm.commitWrite()
                        realm.refresh()
                    }
                }
            }
        }
    }
}

