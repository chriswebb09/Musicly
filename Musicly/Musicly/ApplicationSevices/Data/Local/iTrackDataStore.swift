//
//  DataStore.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class iTrackDataStore {
    
    fileprivate weak var client: iTunesAPIClient? = iTunesAPIClient()
    fileprivate var searchTerm: String?
    
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
    
    func searchForTracks(completion: @escaping (_ downloads: [iTrack]?, _ error: Error?) -> Void) {
        if let searchTerm = searchTerm {
            iTunesAPIClient.search(for: searchTerm) { data, error in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    if let parsedData = DataParser.parseDataForTracks(json: data) {
                        completion(parsedData, nil)
                    } else {
                        completion(nil, NSError.generalParsingError(domain: ""))
                    }
                }
            }
        }
    }
}
