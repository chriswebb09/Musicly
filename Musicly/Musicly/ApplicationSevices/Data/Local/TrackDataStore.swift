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
    var realmClient = RealmClient()
    var newTracks = [Track]()
    var trackLists: Results<TrackList>!
    var tracks: Results<Track>!
    var lists = [TrackList]()
    var currentPlaylistID: String?
    var currentPlaylist: TrackList?
    
    init() {
        realmClient.setObjects { trackLists, tracks, id in
            self.trackLists = trackLists
            self.tracks = tracks
            self.currentPlaylistID = id
        }
    }
    
    func setupCurrentPlaylist(currentPlaylistID: String) -> TrackList? {
        let current = realmClient.getFilteredTrackList(predicate: currentPlaylistID)
        guard let last = current.last else { return nil }
        return last
    }
    
    func setCurrentPlaylist(currentPlaylistID: String) -> TrackList? {
        for list in lists {
            if list.listId == currentPlaylistID {
                currentPlaylist = list
                return currentPlaylist
            }
        }
        return nil
    }
    
    func setupItem(with track: Track, currentPlaylistID: String) {
        track.playlistID = currentPlaylistID
        realmClient.save(track: track, playlistID: currentPlaylistID)
    }
    
    func setSearch(string: String?) {
        searchTerm = string
    }
    
    // Creates new TrackList
    
    func createNewList(newList: TrackList, name: String, date: Date, uid: String) {
        let stringDate = String(describing: date)
        newList.listName = name
        newList.listId = uid
        newList.date = stringDate
        lists.append(newList)
        realmClient.save(list: newList)
    }
    
    // Hit with search terms, parse json and return objects
    
    func searchForTracks(completion: @escaping playlistCompletion) {
        print(searchTerm)
        if let searchTerm = searchTerm {
            iTunesAPIClient.search(for: searchTerm) { data, error in
                print(data)
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    print(data)
                    let tracksData = data["results"] as! [[String: Any]]
                    let playlist: Playlist? = Playlist()
                    tracksData.forEach {
                        let track = Track(json: $0)
                        let newItem: PlaylistItem? = PlaylistItem()
                        newItem?.track = track
                        playlist?.append(newPlaylistItem: newItem)
                    }
                    print(playlist)
                    completion(playlist, nil)
                } else {
                    completion(nil, NSError.generalParsingError(domain: ""))
                }
            }
        }
    }
}
