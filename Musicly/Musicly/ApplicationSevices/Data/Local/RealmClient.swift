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
    
}
