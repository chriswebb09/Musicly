//
//  DataStore.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import RealmSwift

final class iTrackDataStore {
    
    typealias playlistCompletion = (_ playlist: Playlist? , _ error: Error?) -> Void
    
    var realm: Realm?
    
    fileprivate weak var client: iTunesAPIClient? = iTunesAPIClient()
    fileprivate var searchTerm: String?
    var newTracks = [Track]()
    var trackLists: Results<Playlist>!
    
    init(searchTerm: String?) {
        self.searchTerm = searchTerm
        client?.setup()
        if let realm = try? Realm() {
            trackLists = realm.objects(Playlist.self)
        }
    }
    
    func setSearch(string: String?) {
        self.searchTerm = string
    }
    
    func downloadTrackPreview(for download: Download?) {
        if let client = client {
            client.downloadTrackPreview(for: download)
        }
    }

    func searchForTracks(completion: @escaping playlistCompletion) {
        if let searchTerm = searchTerm {
            iTunesAPIClient.search(for: searchTerm) { data, error in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    let tracksData = data["results"] as! [JSON]
                    let playlist: Playlist? = Playlist()
                    
                    tracksData.forEach {
                        let track = Track(json: $0)
                        self.newTracks.append(track)
                        let newItem: PlaylistItem? = PlaylistItem()
                        newItem?.track = track
                        playlist?.append(newPlaylistItem: newItem)
                    }
                    completion(playlist, nil)
                } else {
                    completion(nil, NSError.generalParsingError(domain: ""))
                }
            }
        }
    }
}
