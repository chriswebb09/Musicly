//
//  iTrack.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Track: Object {
    
    var thumbs: RealmThumb?
    
    dynamic var playlistID: String = ""
    dynamic var trackName: String = ""
    dynamic var artistName: String = ""
    dynamic var artistID: String = ""
    dynamic var previewUrl: String = ""
    dynamic var artworkUrl: String = ""
    dynamic var collectionName: String = ""
    dynamic var downloaded: Bool = false
   // dynamic var trackId: String = ""
    dynamic var imageData: Data = Data()
    
    let owners = LinkingObjects(
        fromType: TrackList.self,
        property: "tracks"
    )
    
    convenience init(thumb: RealmThumb) {
        self.init(thumb: thumb)
    }
    
    convenience init(json: [String: Any]) {
        self.init()
        if let trackName = json["trackName"] as? String,
            let artistName = json["artistName"] as? String,
            let artistId = json["artistId"] as? Int,
            let previewUrl = json["previewUrl"] as? String,
            let artworkUrl = json["artworkUrl100"] as? String,
            let collectionName = json["collectionName"] as? String {
            self.trackName = trackName
            self.artistName = artistName
            self.artistID = String(describing: artistId)
            self.previewUrl = previewUrl
            self.artworkUrl = artworkUrl
            self.collectionName = collectionName
            self.downloaded = false
            self.thumbs = .none
        }
    }
    
    required init() {
        self.thumbs = RealmThumb(thumb: .none)
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        self.thumbs = RealmThumb(thumb: .none)
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        self.thumbs = RealmThumb(thumb: .none)
        super.init(value: value, schema: schema)
    }
    
    static func saveAlbumImageData(from urlString: String) -> Data {
        let url = URL(string: urlString)!
        var albumImageData = Data()
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            albumImageData = data
            while albumImageData.isEmpty {
                print("downloading")
            }
            }.resume()
        return albumImageData
    }
    
    override static func primaryKey() -> String? {
        return "previewUrl"
    }
}

