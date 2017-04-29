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
    
    fileprivate var searchTerm: String?
    
    var realm: Realm = try! Realm()
    var newTracks = [Track]()
    var trackLists: Results<TrackList>!
    var tracks: Results<Track>!
    var lists = [TrackList]()
    var currentPlaylistID: String?
    var currentPlaylist: TrackList?
    
    init() {
        if let realm = try? Realm() {
            tracks = realm.objects(Track.self)
            dump(tracks)
            trackLists = realm.objects(TrackList.self)
            
            if let list = trackLists.last {
                currentPlaylistID = list.listId
            }
        }
    }
    
    func setCurrentPlaylist() {
        guard let currentPlaylistID = currentPlaylistID else { return }
        for list in lists {
            if list.listId == currentPlaylistID {
                currentPlaylist = list
            }
        }
    }
    
    func setupItem(with track: Track) {
        if let currentPlaylistID = currentPlaylistID {
            track.playlistID = currentPlaylistID
        }
        
        if let realm = try? Realm() {
            guard let currentPlaylistID = currentPlaylistID else { return }
            trackLists = realm.objects(TrackList.self).filter("listId == %@", currentPlaylistID)
            guard let lastTrackList = trackLists.last else { return }
            currentPlaylist = lastTrackList
            guard let currentPlaylist = currentPlaylist else { return }
            try! realm.write {
                currentPlaylist.appendToTracks(track: track)
                realm.add(currentPlaylist, update: true)
                realm.add(trackLists, update: true)
                realm.refresh()
            }
        }
    }
    
    func setSearch(string: String?) {
        searchTerm = string
    }
    
    // Creates new TrackList
    
    func createNewList(name: String) {
        let date = Date()
        let stringDate = String(describing: date)
        let newList = TrackList()
        newList.listName = name
        newList.listId = UUID().uuidString
        newList.date = stringDate
        lists.append(newList)
        save(list: newList)
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
    
    // Save individual track
    
    func saveTrack(track: Track) {
        if let realm = try? Realm() {
            
            tracks = realm.objects(Track.self)
            if !tracks.contains(track) {
                var newList: TrackList
                try! realm.write {
                    currentPlaylist?.appendToTracks(track: track)
                    realm.add(track, update: true)
                }
            } else {
                print("Exists")
                return
            }
        }
    }
    
    // Hit with search terms, parse json and return objects
    
    func searchForTracks(completion: @escaping playlistCompletion) {
        if let searchTerm = searchTerm {
            iTunesAPIClient.search(for: searchTerm) { data, error in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    let tracksData = data["results"] as! [[String: Any]]
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
