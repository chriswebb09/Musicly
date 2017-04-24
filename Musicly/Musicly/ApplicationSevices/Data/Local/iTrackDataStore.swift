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
    
    var realm: Realm!
    
    fileprivate weak var client: iTunesAPIClient? = iTunesAPIClient()
    fileprivate var searchTerm: String?
    var newTracks = [Track]()
    var trackLists: Results<TrackList>!
    var tracks: Results<Track>!
    var lists = [TrackList]()
    
    init(searchTerm: String?) {
        self.searchTerm = searchTerm
        client?.setup()
        if let realm = try? Realm() {
            tracks = realm.objects(Track.self)
            trackLists = realm.objects(TrackList.self)
        }
    }
    
    func saveItem(playlistItem: PlaylistItem) {
        let track = playlistItem.track
        var newList = lists.last
        //    var old = lists.first
        // //  newList?.appendToTracks(track: playlistItem.track!)
    }
    
    func setSearch(string: String?) {
        self.searchTerm = string
    }
    
    func createNewList(name: String) {
        var newList = TrackList()
        newList.listName = name
        newList.listId = UUID().uuidString
        lists.append(newList)
        save(list: newList)
    }
    
    func saveTrack(track: Track) {
        if let realm = try? Realm() {
            
            tracks = realm.objects(Track.self)
            if !tracks.contains(track) {
                var newList = lists.last
                
                try! realm.write {
                    newList?.appendToTracks(track: track)
                    realm.add(track, update: true)
                }
            } else {
                print("Exists")
                return
            }
        }
    }
    
    
    func save(list: TrackList) {
        if let realm = try? Realm() {
            trackLists = realm.objects(TrackList.self)
            
            if !trackLists.contains(list) {
                try! realm.write {
                    realm.add(list, update: true)
                }
            }
        }
    }
    
    func pullLists() -> TrackList? {
        let realm = try! Realm()
        let results = realm.objects(TrackList.self)
        return results.first
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
