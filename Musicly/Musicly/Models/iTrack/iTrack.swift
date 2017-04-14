//
//  iTrack.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//


import Foundation

struct iTrack {
    
    weak var delegate: iTrackDelegate?
    
    let trackName: String
    let artistName: String
    let artistId: Int
    let previewUrl: String
    let artworkUrl: String
    let collectionName: String
    var thumbs: Thumbs
    
    var downloaded: Bool {
        didSet {
            delegate?.downloadIsComplete(downloaded: downloaded)
        }
    }
    
    init?(json: [String : Any]) {
        
        if let trackName = json["trackName"] as? String,
            let artistName = json["artistName"] as? String,
            let artistId = json["artistId"] as? Int,
            let previewUrl = json["previewUrl"] as? String,
            let artworkUrl = json["artworkUrl100"] as? String,
            let collectionName = json["collectionName"] as? String {
            
            self.trackName = trackName
            self.artistName = artistName
            self.artistId = artistId
            self.previewUrl = previewUrl
            self.artworkUrl = artworkUrl
            self.collectionName = collectionName
            self.downloaded = false
            self.thumbs = .none
        } else {
            return nil
        }
    }
}

extension iTrack: Hashable {
    
    var hashValue: Int {
        return trackName.hashValue
    }
    
    static func ==(lhs: iTrack, rhs: iTrack) -> Bool {
        return lhs.previewUrl == rhs.previewUrl
    }
}
