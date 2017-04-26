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
    
    fileprivate weak var client: iTunesAPIClient? = iTunesAPIClient()
    fileprivate var searchTerm: String?
    
    var realm: Realm!
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
    
    func setupItem(with track: Track) {
        let item = Track()
//        if let currentPlatID = currentPlayerID {
//            item.playlistID = currentPlayerID.id
//        }
        item.previewUrl = track.previewUrl
        item.trackName = track.trackName
        item.artistID = track.artistID
        item.artworkUrl = track.artworkUrl
        item.artistName = track.artistName
        item.collectionName = track.collectionName
        saveTrack(track: item)
//        return item
    }
    
    func saveItem(playlistItem: PlaylistItem) {
        let track = playlistItem.track
        var newList = lists.last
    }
    
    func setSearch(string: String?) {
        self.searchTerm = string
    }
    
    // Creates new TrackList
    
    func createNewList(name: String) {
        var newList = TrackList()
        newList.listName = name
        newList.listId = UUID().uuidString
        lists.append(newList)
        save(list: newList)
    }
    
    // Save individual track
    
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
    
    // Save tracklist to Realm
    
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
    
    // Fetch playlist from Realm storage to use
    
    func pullLists() -> TrackList? {
        let realm = try! Realm()
        let results = realm.objects(TrackList.self)
        return results.first
    }
    
    // Donwload preview - form downloading audio
    
    func downloadTrackPreview(for download: Download?) {
        if let client = client {
            client.downloadTrackPreview(for: download)
        }
    }
    
    // Hit with search terms, parse json and return objects
    
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
