//
//  DataStore.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

final class iTrackDataStore {
    
    fileprivate weak var client: iTunesAPIClient? = iTunesAPIClient()
    fileprivate var searchTerm: String?
    var savedPlaylist: [NSManagedObjectContext] = []
    var playlists: [Playlist] = [Playlist]()
    
    init(searchTerm: String?) {
        self.searchTerm = searchTerm
        client?.setup()
    }
    
    func setSearch(string: String?) {
        self.searchTerm = string
    }
    
    func downloadTrackPreview(for download: Download?) {
        if let client = client {
            client.downloadTrackPreview(for: download)
        }
    }
    
    func searchForTracks(completion: @escaping (_ playlist: Playlist? , _ error: Error?) -> Void) {
        
        if let searchTerm = searchTerm {
            iTunesAPIClient.search(for: searchTerm) { data, error in
                
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    let tracksData = data["results"] as! [JSON]
                    let playlist: Playlist? = Playlist()
                    tracksData.forEach {
                        if let track = iTrack(json: $0) {
                            let newItem: PlaylistItem? = PlaylistItem()
                            newItem?.track = track
                            guard let playlist = playlist, let item = newItem else { return }
                            playlist.append(newPlaylistItem: item)
                        }
                    }
                    self.playlists.append(playlist!)
                    completion(playlist, nil)
                } else {
                    completion(nil, NSError.generalParsingError(domain: ""))
                }
            }
        }
    }
}

